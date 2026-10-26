-- Grain: one row per deal. Current state + history summarized from the weekly snapshots.
-- Assumption: deals_meta is the CRM state on the as-of date. For deals with history it equals the last
-- snapshot, except three deals with a single snapshot whose CRM stage is ahead of the snapshot.
-- Furthest stage and weeks per stage come from the snapshots only (weekly, so a fast deal can skip a stage).
with deals as (
    select * from {{ ref('stg_deals') }}
),

owners as (
    select * from {{ ref('stg_owners') }}
),

history as (
    select
        deal_id,
        count(*)                                                        as weeks_tracked,
        min(snapshot_date)                                              as first_snapshot_date,
        max(snapshot_date)                                              as last_snapshot_date,
        max(stage_order) filter (where not is_closed)                   as max_open_stage_order,
        min(snapshot_date) filter (where stage = 'Closed Won')          as won_snapshot_date,
        count(*) filter (where stage = 'Prospecting')                   as weeks_in_prospecting,
        count(*) filter (where stage = 'Qualification')                 as weeks_in_qualification,
        count(*) filter (where stage = 'Proposal')                      as weeks_in_proposal,
        count(*) filter (where stage = 'Negotiation')                   as weeks_in_negotiation
    from {{ ref('stg_deal_snapshots') }}
    group by 1
)

select
    d.*,
    date_trunc('quarter', d.close_date)::date                           as close_quarter,
    case h.max_open_stage_order
        when 1 then 'Prospecting'
        when 2 then 'Qualification'
        when 3 then 'Proposal'
        when 4 then 'Negotiation'
    end                                                                 as furthest_open_stage,
    h.max_open_stage_order                                              as furthest_open_stage_order,
    h.weeks_tracked,
    h.first_snapshot_date,
    h.last_snapshot_date,
    h.won_snapshot_date,
    h.weeks_in_prospecting,
    h.weeks_in_qualification,
    h.weeks_in_proposal,
    h.weeks_in_negotiation,

    o.owner_name,
    o.is_active_as_of                                                   as is_owner_active,

    d.close_date - h.won_snapshot_date                                  as days_won_before_close,
    -- DQ: shown as Closed Won more than 6 days before its close_date. Before 9 June 2025 the largest
    -- gap was 6 days, so a bigger gap is out of pattern. False when the deal has no Won snapshot.
    coalesce(d.close_date - h.won_snapshot_date > 6, false)             as is_won_well_before_close,
    -- DQ: deal created after its owner left the company (false for owners still in the company)
    coalesce(d.created_date > o.role_end_date, false)                   as is_created_by_inactive_owner,

    -- Stale = still open but its close date already passed: nobody closed it won or lost.
    d.is_open and d.close_date < date '{{ var("as_of_date") }}'         as is_stale,
    -- Live = open, created by the as-of date and close date still ahead (a deal due on the as-of date counts).
    d.is_open and d.close_date >= date '{{ var("as_of_date") }}'
        and not d.is_created_after_as_of                                as is_live_pipeline,
    -- Orphaned = open deal whose owner has left the company.
    d.is_open and not o.is_active_as_of                                 as is_orphaned,

    -- One word for how the deal stands today.
    case
        when d.is_won   then 'Won'
        when d.is_lost  then 'Lost'
        when d.is_open and d.close_date < date '{{ var("as_of_date") }}' then 'Left open'
        else 'Open'
    end                                                                 as outcome

from deals d
left join owners o using (owner_id)
left join history h using (deal_id)
