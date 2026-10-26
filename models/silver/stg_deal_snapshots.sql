-- Grain: one row per deal per weekly snapshot (Mondays).
with source as (
    select * from {{ ref('deals_snapshot') }}
)

select
    deal_id,
    snapshot_date,
    date_trunc('quarter', snapshot_date)::date          as snapshot_quarter,
    owner_id,
    stage,
    {{ stage_order('stage') }}                          as stage_order,
    forecast_category,
    amount,
    close_date,
    date_trunc('quarter', close_date)::date             as close_quarter,
    stage in ('Closed Won', 'Closed Lost')              as is_closed,

    -- first snapshot of each quarter = the "start of quarter" forecast call
    snapshot_date = min(snapshot_date) over (partition by date_trunc('quarter', snapshot_date))
                                                        as is_quarter_start_snapshot

from source
