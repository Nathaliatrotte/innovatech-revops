-- Question 1: what blew the Q1 forecast?
-- For each completed quarter: what happened to the start-of-quarter forecast, and where the
-- bookings that were not in it came from.
-- Assumptions:
--   * A deal is "lost" whenever it was lost, even if after the quarter ended.
--   * The forecast amount is the amount at the start of the quarter; the booked amount is the final
--     amount, so they can differ for the same won deal.
--   * Bucket 4 (moved to a later quarter) is empty in the current data, but is kept so no deal is dropped.
with called as (
    select snapshot_quarter as quarter, deal_id, amount as forecast_amount
    from "3_gold".fct_deal_snapshots
    where is_forecast_call
),

called_outcomes as (
    select
        c.quarter,
        case
            when d.is_won and d.close_quarter = c.quarter   then '1. Called -> won in quarter'
            when d.is_lost                                  then '2. Called -> lost'
            when d.outcome = 'Left open' and d.close_quarter = c.quarter
                                                            then '3. Called -> expired, never closed'
            else                                                 '4. Called -> moved to a later quarter'
        end                                                 as bucket,
        c.forecast_amount,
        case when d.is_won and d.close_quarter = c.quarter then d.amount else 0 end as booked_amount
    from called c
    join "3_gold".fct_deals d using (deal_id)
),

not_called as (
    select
        d.close_quarter                                     as quarter,
        case when d.created_date >= d.close_quarter
             then '5. Not called -> created during the quarter'
             else '6. Not called -> already open at the call'
        end                                                 as bucket,
        0                                                   as forecast_amount,
        d.amount                                            as booked_amount
    from "3_gold".fct_deals d
    where d.is_won
      and d.close_quarter in (select quarter from called)
      and not exists (select 1 from called c where c.deal_id = d.deal_id and c.quarter = d.close_quarter)
)

select
    quarter,
    bucket,
    count(*)                as deal_count,
    sum(forecast_amount)    as forecast_amount,
    sum(booked_amount)      as booked_amount
from (select * from called_outcomes union all select * from not_called)
group by 1, 2
order by 1, 2
