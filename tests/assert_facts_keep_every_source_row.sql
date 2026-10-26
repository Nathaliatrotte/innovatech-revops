-- No deal and no weekly snapshot may be lost or duplicated between the raw files and the facts.
select deals_gold, deals_source, snapshots_gold, snapshots_source
from (
    select
        (select count(*) from {{ ref('fct_deals') }})            as deals_gold,
        (select count(*) from {{ ref('deals_meta') }})           as deals_source,
        (select count(*) from {{ ref('fct_deal_snapshots') }})   as snapshots_gold,
        (select count(*) from {{ ref('deals_snapshot') }})       as snapshots_source
)
where deals_gold <> deals_source or snapshots_gold <> snapshots_source
