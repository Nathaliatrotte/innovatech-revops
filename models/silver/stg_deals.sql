-- Grain: one row per deal (current CRM state).
with source as (
    select * from {{ ref('deals_meta') }}
)

select
    deal_id,
    owner_id,
    created_date,
    close_date,
    deal_stage                                        as stage,
    {{ stage_order('deal_stage') }}                   as stage_order,
    forecast_category,
    record_type                                       as sales_motion,
    deal_type,
    deal_order_type,
    account_industry,
    account_region,
    account_size                                      as segment,
    deal_source,
    deal_amount                                       as amount,

    deal_stage = 'Closed Won'                         as is_won,
    deal_stage = 'Closed Lost'                        as is_lost,
    deal_stage not in ('Closed Won', 'Closed Lost')   as is_open,

    -- DQ: forecast category ahead of the stage (Commit before Negotiation, Best Case before Proposal)
    (forecast_category = 'Commit'    and deal_stage in ('Prospecting', 'Qualification', 'Proposal'))
    or (forecast_category = 'Best Case' and deal_stage in ('Prospecting', 'Qualification'))
                                                      as is_forecast_ahead_of_stage,

    -- DQ: created after the last snapshot, so it has no history
    created_date > date '{{ var("as_of_date") }}'     as is_created_after_as_of

from source
