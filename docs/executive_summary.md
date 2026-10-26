# Innovatech: Q1 miss, stalled deals and the Q3 outlook

Data as of 9 June 2025, the last weekly pipeline snapshot. Amounts are in US dollars. Charts are drawn from the data by `scripts/build_charts.py`.

## The answers

1. **Q1 missed because the forecast was too small and its deals were never closed out.** On 6 January the forecast was $871k, about 75% of the target. Of that, $354k reached its close date and was left open: nobody won it, lost it or moved the date.
2. **Deals stall at the start and are never cleaned up.** Deals that don't leave Prospecting sit there until their close date passes. The CRM now holds 387 such open deals worth $21.8M, against only $3.1M of real pipeline.
3. **Q3 is not on track.** Open pipeline is $1.74M, under half the usual level, and $774k of it belongs to two reps who have left. The one exception is 13 deals ($1.08M) marked won on the last snapshot, which need checking.

## 1. Why Q1 missed

![Q1 forecast and bookings](charts/1_q1_forecast.svg)

- Of the 6 January forecast, 47% was won, 12% lost and 41% was left open after its close date.
- Q1 still closed $949k, because $535k came from deals not in the forecast. Most of it was new deals created during Q1.
- The forecast never covered the target. The target is about $1.16M, worked back from the 18% miss.
- Only 1 of the forecast deals was in the strictest category (Commit), so in practice the forecast was just the "Best Case" list.
- The three quarters before Q1 look the same.

**Do next:** define Commit as a deal in Negotiation with an agreed close date, and review every forecast deal in the week before its close date.

## 2. Where deals stall

![Where deals end up, by stage](charts/2_stalled_deals.svg)

- Deals that do progress spend about 6 weeks in Prospecting and 3–4 weeks in each later stage.
- Before Negotiation, 94% of deals never get a decision.
- The weekly pipeline report hides these deals once their date passes, but the CRM still lists them as open.

**Do next:** automatically close as lost any deal 30 days past its close date, with a required reason. Add a checkpoint at the end of Prospecting.

## 3. Is Q3 on track?

![Open pipeline before each quarter](charts/3_q3_pipeline.svg)

- Three weeks before a quarter there is normally $3.4M–$4.6M of open pipeline across 67–73 deals. Q3 has $1.74M across 32.
- $774k (44%) is owned by two reps who left in April and May. Nobody is working these deals.
- From the open pipeline we expect $0.44M–$0.51M, which is 38–44% of the $1.16M target.
- **To check:** 13 deals worth $1.08M were switched from Negotiation to Won on 9 June, with close dates in July–September. This has not happened before in the data. If Finance confirms they are signed, Q3 reaches about $1.5M–$1.6M. If not, Q3 is 56–62% short.

**Do next:** give the $774k to active reps this week, and ask Finance about the 13 deals.

## What to keep in mind

- **The target is an estimate.** The targets table is unusable after Q1 2024 (each quarter is exactly 6.15 times the last), and no other comparison gives the 18% miss. Please confirm the target with the CRO.
- **Few new deals after early May.** 13 deals were created in May, none in June or July. This may be a real slowdown or a gap in the data export.
- **22 deals were created under reps who had already left.** Either their end dates are wrong or deals are being logged under former reps.
