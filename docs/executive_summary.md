# Innovatech: Q1 miss, stalled deals and the Q3 outlook

Data as of 9 June 2025, the last weekly pipeline snapshot. Amounts are in US dollars. Charts are drawn from the data by `scripts/build_charts.py`.

## The answers

1. **Q1 missed because the forecast was small and nearly half of it never closed.** On 6 January the forecast was $871k, 75% of the target. Only 47% of it was won; 41% ($354k) reached its close date and was left open. Deals outside the forecast added $535k and limited the miss to 18%.
2. **Deals reach their close date without a decision in every stage.** The problem is across the whole pipeline, not in one stage. The CRM holds 387 open deals past their close date, worth $21.8M, against only $3.1M of real pipeline.
3. **Q3 is not on track.** Open pipeline is $1.74M, under half the usual level, and $774k of it belongs to two reps who have left. The one exception is 13 deals ($1.08M) marked won on the last snapshot, which need checking.

Cleaning up stale deals makes the numbers honest but adds no revenue. For Q3 the main lever is building pipeline now.

## 1. Why Q1 missed

![Q1 forecast and bookings](charts/1_q1_forecast.svg)

- Of the 6 January forecast, 47% was won, 12% lost and 41% was left open after its close date.
- Q1 still closed $949k, because $535k came from deals not in the forecast. Most of it, $349k, was new deals created during Q1.
- The pipeline was not unusually small. Three weeks before Q1 there was $4.19M open, in the normal range. But it turned into only 23 cents of bookings per dollar, against 28–34 cents in the other quarters since mid-2024.
- The forecast is unreliable in every quarter. In the four quarters with a forecast (Q2 2024 to Q1 2025), 25–47% of it was won and 36–52% was left open.
- Only 1 of the 20 forecast deals was in the strictest category (Commit), so in practice the forecast was the "Best Case" list.

**Do next:**
1. Define Commit as a deal in Negotiation with an agreed close date.
2. Review every forecast deal in the week before its close date: win it, lose it or move the date.
3. Plan each quarter with enough pipeline. The team booked $0.95M–$1.29M from a starting pipeline of $3.4M–$4.6M, so about 3 times the target ($3.5M) is the level to aim for three weeks before the quarter.

## 2. Where deals stall

![Where deals end up, by stage](charts/2_stalled_deals.svg)

- Deals reach their close date without a decision in every stage: 116 in Prospecting, 92 in Qualification, 101 in Proposal and 78 in Negotiation. The problem is in the whole pipeline, not in one stage.
- Deals that do progress spend about 6 weeks in Prospecting and 3–4 weeks in each later stage. The ones that end up left open were tracked for 12–14 weeks on average.
- The weekly pipeline report hides these deals once their date passes, but the CRM still lists them as open.

Closing these deals does not create revenue. It shows the real pipeline, so the team knows how much more it has to build, and it frees reps from deals that are not moving.

**Do next:**
1. Add a checkpoint at the end of every stage, so a deal cannot sit in a stage until its close date without someone deciding to move it, push the date or close it.
2. Automatically close as lost any deal 30 days past its close date, with a required reason. The reasons will show which losses can be avoided.

## 3. Is Q3 on track?

![Open pipeline before each quarter](charts/3_q3_pipeline.svg)

- **How we measure it:** the CRM saves a snapshot of every deal each week. For each quarter we take the snapshot from about 3 weeks before it started (for Q3, 9 June) and add up the deals still open and due to close in that quarter. This is the pipeline the team starts the quarter with.
- **Q3 is far below normal.** In each of the last four quarters the team started with $3.4M–$4.6M across 67–73 deals. For Q3 it is $1.74M across 32 deals.
- **Almost half of it has no active owner.** $774k (44%) belongs to two reps who left in April and May. This includes $561k of the $644k in Negotiation, the most valuable stage.
- **What this pipeline should produce:** $0.37M–$0.50M, which is 32–43% of the $1.16M target.
  - Low end ($0.37M): weight each deal by how often past deals at the same stage were won.
  - High end ($0.50M): apply 29 cents of bookings per pipeline dollar, the average of the last four quarters. This assumes new deals keep arriving at the normal rate.
- **To check:** 13 deals worth $1.08M, due in July–September, were marked Won on 9 June. Before that, no deal was marked won more than 6 days before its close date, and these were 24–112 days early. They are not part of the $1.74M, because they are no longer open. We don't know yet if they are signed contracts or a bulk update in the CRM. The list is in `analyses/q3_deals_to_check.sql`.
  - If Finance confirms they are signed, Q3 would reach $1.45M–$1.58M, above the target.
  - If not, Q3 would miss the target by 57–68%.

**Do next:**
1. Give the $774k to active reps this week.
2. Ask Finance about the 13 deals.
3. Start building Q3 pipeline now, and find out why no deals were created after 8 May. If the 13 deals are not confirmed, new pipeline is the only way to close the gap.

## What to keep in mind

- **The $1.16M target is an estimate, and the targets file overestimates it.** Q1 2024 totals $664k, which looks realistic. In Q2 2024 each rep's target jumps 1.75–6.15 times, and from Q3 2024 every target is exactly 6.15 times the previous quarter, reaching $589M for Q1 2025. The team booked $0.95M–$1.29M in each quarter from Q2 2024 to Q2 2025, so these targets are not achievable. We worked back from the 18% miss: Q1 booked $949k, which is 82% of about $1.16M. That is close to the $1.12M average booked per quarter. We use the same $1.16M for Q3.
- **No deals were created between 9 May and 31 July.** The data has about 40 new deals a month until April, then 13 in May, none in June and July, and 50 in August. This may be a real pause or a gap in the data export. Please confirm.
- **50 deals created in August are left out.** They are after the last snapshot and have no history.
- **22 deals were created under reps who had already left.** Either their end dates are wrong or deals are being logged under former reps.
- **The stage of a deal comes from weekly snapshots.** A fast deal can skip a stage: 4 of the 5 deals shown as won in Prospecting were won in the week after their Prospecting snapshot, and the fifth has no later snapshot.
