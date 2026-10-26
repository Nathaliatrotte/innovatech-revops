-- Grain: one row per owner per quarter.
-- DQ: in 2024 Q2 targets jump 1.75-6.15x per owner, and from 2024 Q3 every target is exactly
-- 6.153x the same owner's prior quarter, so those rows are flagged and must not be used as quota.
-- Assumption: quarters are calendar quarters (Q1 = January to March), as in the rest of the project.
-- The date is only used to put each owner's quarters in order.
with source as (
    select * from {{ ref('targets') }}
),

parsed as (
    select
        quarter                                                     as quarter_label,
        make_date(
            split_part(quarter, ' ', 1)::int,
            (replace(split_part(quarter, ' ', 2), 'Q', '')::int - 1) * 3 + 1,
            1
        )                                                           as quarter_start_date,
        owner_id,
        segment,
        target_amount
    from source
)

select
    *,
    target_amount / lag(target_amount) over (partition by owner_id order by quarter_start_date)
                                                                    as qoq_growth,
    -- Assumption: a quota that grows more than 50% in one quarter is not realistic.
    -- The first quarter has no growth to check, so it counts as plausible.
    coalesce(qoq_growth, 1) <= 1.5                                  as is_target_plausible
from parsed
