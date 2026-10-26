# Innovatech: Q1 miss, stalled deals and the Q3 outlook

Data as of 9 June 2025, the last weekly pipeline snapshot. Amounts are in US dollars. Charts are drawn from the data by `scripts/build_charts.py`.

## The answers

1. **Q1 missed because there was not enough pipeline.** On 6 January the forecast was $871k, about 75% of the target, and only 47% of it was won. Another $354k reached its close date and was left open: nobody won it, lost it or moved the date.
2. **Deals reach their close date in every stage and are never cleaned up.** The problem is across the whole pipeline, not in one stage. The CRM now holds 387 open deals past their close date, worth $21.8M, against only $3.1M of real pipeline. Cleaning them up makes the numbers honest, but it does not add revenue.
3. **Q3 is not on track.** Open pipeline is $1.74M, under half the usual level, and $774k of it belongs to two reps who have left. Almost no new deals have been created since early May. The one exception is 13 deals ($1.08M) marked won on the last snapshot, which need checking.

**The main lever is creating more pipeline early in each quarter.** Cleanup and better forecast rules support that, because they show how much real pipeline there is.

## 1. Why Q1 missed

![Q1 forecast and bookings](charts/1_q1_forecast.svg)

- Of the 6 January forecast, 47% was won, 12% lost and 41% was left open after its close date.
- Q1 still closed $949k, because $535k came from deals not in the forecast. Most of it was new deals created during Q1.
- The forecast never covered the target. The realistic target is about $1.16M (see "What to keep in mind").
- Only 1 of the forecast deals was in the strictest category (Commit), so in practice the forecast was just the "Best Case" list.
- The three quarters before Q1 look the same.

**Do next:**
1. Set a pipeline target for the start of each quarter. At a 47% win rate, the 6 January forecast would need to be about $2.5M, roughly twice the target, to book $1.16M from forecast deals alone. New deals created during the quarter help, but they should not be the plan.
2. Define Commit as a deal in Negotiation with an agreed close date, and review every forecast deal in the week before its close date.

## 2. Where deals stall

![Where deals end up, by stage](charts/2_stalled_deals.svg)

- Deals that do progress spend about 6 weeks in Prospecting and 3–4 weeks in each later stage.
- Deals reach their close date without a decision in every stage: 116 in Prospecting, 92 in Qualification, 101 in Proposal and 78 in Negotiation. The problem is in the whole pipeline, not in one stage.
- The weekly pipeline report hides these deals once their date passes, but the CRM still lists them as open.

Closing these deals does not create revenue. It shows the real pipeline, so the team knows how much more it has to build, and it frees reps from deals that are not moving.

**Do next:**
1. Add a checkpoint at the end of every stage, so a deal cannot sit in a stage until its close date without someone deciding to move it, push the date or close it.
2. Automatically close as lost any deal 30 days past its close date, with a required reason. The reasons will show which losses can be avoided.

## 3. Is Q3 on track?

![Open pipeline before each quarter](charts/3_q3_pipeline.svg)

- **How we measure it:** the CRM saves a snapshot of every deal each week. For each quarter we take the snapshot from about 3 weeks before the quarter started (for Q3, 9 June) and add up the deals that were still open and due to close in that quarter. This is the pipeline the team starts the quarter with.
- **Q3 is far below normal.** In each of the last four quarters, the team started with $3.4M–$4.6M of open pipeline across 67–73 deals. For Q3 it is $1.74M across 32 deals.
- **Almost half of it has no active owner.** $774k (44%) belongs to two reps who left in April and May, so nobody is working these deals.
- **What this pipeline should produce:** about $0.44M–$0.51M, which is 38–44% of the $1.16M target. We get this two ways. Weighting each deal by how often past deals at the same stage were won gives $0.44M. Applying the 29 cents of bookings per pipeline dollar of the last four quarters gives $0.51M.
- **To check:** 13 deals worth $1.08M were marked Won on 9 June, although their close dates are in July–September. Before this, no deal in the data was marked Won more than 6 days before its close date, and these were 24–141 days early. They are not part of the $1.74M, because they are no longer open. We don't know yet if they are real signed contracts or a bulk update in the CRM.
  - If Finance confirms they are signed, Q3 would reach about $1.5M–$1.6M, above the target.
  - If not, Q3 would miss the target by 56–62%.

**Do next:**
1. Give the $774k to active reps this week.
2. Ask Finance about the 13 deals.
3. Find out why so few deals were created after early May, and start building Q3 pipeline now. If the 13 deals are not confirmed, new pipeline is the only way to close the 56–62% gap.

## What to keep in mind

- **The rep targets are overestimated, so we use a more realistic target of $1.16M.** Q1 2024 totals $664k, which looks realistic. From Q2 2024 every rep's target is exactly 6.15 times their own target of the previous quarter, reaching $589M for Q1 2025 and $22.3B for Q3 2025. The team booked between $0.95M and $1.29M in each quarter from Q2 2024 to Q2 2025, so these targets are not achievable. Two facts support $1.16M: Q1 2025 booked $949k, which is 82% of $1.16M (the 18% miss), and $1.16M is close to the average of $1.12M booked per quarter over those five quarters. We use the same $1.16M for Q3.
- **Few new deals after early May.** 13 deals were created in May, none in June or July. This may be a real slowdown or a gap in the data export.
- **22 deals were created under reps who had already left.** Either their end dates are wrong or deals are being logged under former reps.
