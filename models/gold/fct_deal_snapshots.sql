-- Grain: one row per deal per weekly snapshot (Mondays).
-- Carries the two questions we ask of history, so they become simple filters:
--   is_forecast_call       the deal was part of the start-of-quarter forecast
--   is_pre_quarter_reading the snapshot used to measure the pipeline ~3 weeks before a quarter starts
with snapshots as (
    select * from {{ ref('stg_deal_snapshots') }}
),

-- For each quarter: the last snapshot at least 21 days before it starts,
-- kept only if it is within 35 days of the start. Assumption: 3 to 5 weeks before the quarter is
-- "the pipeline the team starts with". Quarters with no such snapshot (the first in the data, and
-- future ones) get no reading.
reading_points as (
    select
        q.close_quarter,
        max(s.snapshot_date)                as reading_snapshot_date
    from (select distinct close_quarter from snapshots) q
    join (select distinct snapshot_date from snapshots) s
      on s.snapshot_date <= q.close_quarter - interval 21 day
    group by 1
    having date_diff('day', max(s.snapshot_date), q.close_quarter) <= 35
)

select
    s.*,

    -- First snapshot of a completed quarter, deal due in that quarter, and either forecast as
    -- Commit / Best Case or already won. Assumption: the first snapshot of the quarter is the forecast.
    s.is_quarter_start_snapshot
        and s.close_quarter = s.snapshot_quarter
        and (s.forecast_category in ('Commit', 'Best Case') or s.stage = 'Closed Won')
        and s.snapshot_quarter + interval 3 month <= date '{{ var("as_of_date") }}'
                                                                as is_forecast_call,

    coalesce(s.snapshot_date = r.reading_snapshot_date, false)  as is_pre_quarter_reading

from snapshots s
left join reading_points r on r.close_quarter = s.close_quarter
