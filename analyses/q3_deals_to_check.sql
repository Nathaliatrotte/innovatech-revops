-- Question 3 (to check): deals marked Won well before their close date.
-- Before 9 June 2025 no deal was marked won more than 6 days before its close date. These deals were all
-- marked won on 9 June, the last snapshot. Finance needs to confirm they are signed.
select
    deal_id,
    owner_name,
    amount,
    close_date,
    close_quarter,
    won_snapshot_date,
    days_won_before_close
from "3_gold".fct_deals
where is_won_well_before_close
order by close_date
