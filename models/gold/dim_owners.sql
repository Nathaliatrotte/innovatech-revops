-- Grain: one row per sales rep. The only place that says who is still in the company on the as-of date.
select * from {{ ref('stg_owners') }}
