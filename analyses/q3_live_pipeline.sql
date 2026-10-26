-- Question 3 (today): live pipeline (open, close date still ahead) by close quarter and stage,
-- weighted by the share of past deals that reached that stage and were won.
-- Past deals = won, lost or left open after their close date.
with deals as (
    select * from "3_gold".fct_deals
),

win_rates as (
    select
        s.stage_order,
        count(*) filter (where d.is_won)::double / count(*)     as win_rate
    from (select distinct stage_order from deals where is_open) s
    join deals d
      on d.furthest_open_stage_order >= s.stage_order
     and d.outcome in ('Won', 'Lost', 'Left open')
    group by 1
)

select
    d.close_quarter,
    d.stage,
    d.stage_order,
    count(*)                                                    as deal_count,
    sum(d.amount)                                               as pipeline_amount,
    round(w.win_rate, 3)                                        as historical_win_rate,
    round(sum(d.amount) * w.win_rate)                           as weighted_amount,
    sum(d.amount) filter (where d.is_orphaned)                  as orphaned_amount
from deals d
join win_rates w using (stage_order)
where d.is_live_pipeline
group by 1, 2, 3, w.win_rate
order by 1, 3
