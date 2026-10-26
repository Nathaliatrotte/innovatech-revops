-- Question 3 (history): how much pipeline was open for each quarter about 3 weeks before it
-- started, and how much that quarter finally booked. The latest row is today's reading for Q3.
-- Assumptions:
--   * bookings_per_pipe_dollar divides ALL the quarter's bookings by the starting pipeline, so it also
--     includes deals created during the quarter. It is not a pure conversion rate.
--   * The first reading (Q2 2024) is small because the history starts in January 2024, so the
--     pipeline had not built up yet. The summary leaves it out.
--   * The latest row is not finished: its bookings so far include the deals marked won early.
with pipe as (
    select
        close_quarter           as quarter,
        min(snapshot_date)      as reading_snapshot_date,
        count(*)                as open_deals,
        sum(amount)             as open_pipe_amount
    from "3_gold".fct_deal_snapshots
    where is_pre_quarter_reading
      and not is_closed
    group by 1
),

bookings as (
    select close_quarter as quarter, sum(amount) as bookings
    from "3_gold".fct_deals
    where is_won
    group by 1
)

select
    p.quarter,
    p.reading_snapshot_date,
    p.open_deals,
    p.open_pipe_amount,
    b.bookings                                          as final_bookings,
    round(b.bookings / p.open_pipe_amount, 2)           as bookings_per_pipe_dollar,
    p.reading_snapshot_date = (select max(snapshot_date) from "3_gold".fct_deal_snapshots)
                                                        as is_current_reading
from pipe p
left join bookings b using (quarter)
order by 1
