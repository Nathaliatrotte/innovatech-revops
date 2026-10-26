-- Total bookings in the deal fact must equal the Closed Won amount in the raw file.
select gold_total, source_total
from (
    select
        (select sum(amount) from {{ ref('fct_deals') }} where is_won)                           as gold_total,
        (select sum(deal_amount) from {{ ref('deals_meta') }} where deal_stage = 'Closed Won')  as source_total
)
where gold_total <> source_total
