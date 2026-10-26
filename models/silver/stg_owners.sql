-- Grain: one row per owner. Email (PII) is dropped here.
with source as (
    select * from {{ ref('owners') }}
)

select
    owner_id,
    name                                                as owner_name,
    role,
    manager,
    segment,
    role_start_date,
    role_end_date,
    role_end_date is null
        or role_end_date > date '{{ var("as_of_date") }}' as is_active_as_of

from source
