-- Grain: one row per owner per quarter.
-- DQ: in 2024 Q2 targets jump 1.75-6.15x per owner, and from 2024 Q3 every target is exactly
-- 6.153x the same owner's prior quarter, so those rows are flagged and must not be used as quota.
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
    coalesce(qoq_growth, 1) <= 2                                    as is_target_plausible
from parsed
