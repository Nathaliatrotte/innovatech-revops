-- Question 2: where are deals stalling, and why?
-- Deals whose close date has passed, grouped by the furthest stage they reached.
with deals as (
    select *
    from "3_gold".fct_deals
    where weeks_tracked is not null
      and outcome <> 'Open'
      and close_date < (select max(snapshot_date) from "3_gold".fct_deal_snapshots)
),

stages as (
    select * from (values (1, 'Prospecting'), (2, 'Qualification'), (3, 'Proposal'), (4, 'Negotiation'))
        as t (stage_order, stage)
)

select
    s.stage_order,
    s.stage,
    count(*) filter (where d.furthest_open_stage_order >= s.stage_order)               as deals_reached,

    -- Weeks spent in the stage by deals that moved past it. Deals that expire are left out:
    -- they sit in their stage until the close date, which says nothing about how long a stage takes.
    round(avg(case
        when d.furthest_open_stage_order > s.stage_order
          or (d.furthest_open_stage_order = s.stage_order and d.is_won)
        then case s.stage_order
            when 1 then nullif(d.weeks_in_prospecting, 0)
            when 2 then nullif(d.weeks_in_qualification, 0)
            when 3 then nullif(d.weeks_in_proposal, 0)
            when 4 then nullif(d.weeks_in_negotiation, 0)
        end
    end), 1)                                                                            as avg_weeks_before_advancing,

    round(avg(d.weeks_tracked) filter (where d.furthest_open_stage_order = s.stage_order and d.outcome = 'Left open'), 1)
                                                                                        as avg_weeks_tracked_expired,

    -- What happened to deals whose furthest stage was this one
    count(*) filter (where d.furthest_open_stage_order = s.stage_order)                 as deals_ended_here,
    count(*) filter (where d.furthest_open_stage_order = s.stage_order and d.outcome = 'Won')       as won,
    count(*) filter (where d.furthest_open_stage_order = s.stage_order and d.outcome = 'Lost')      as lost,
    count(*) filter (where d.furthest_open_stage_order = s.stage_order and d.outcome = 'Left open') as stale_no_decision,
    sum(d.amount) filter (where d.furthest_open_stage_order = s.stage_order and d.outcome = 'Left open')
                                                                                        as stale_amount
from stages s
cross join deals d
group by 1, 2
order by 1
