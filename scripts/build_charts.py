"""Draw the three charts of the executive summary as SVG files in docs/charts/.

Run after `dbt build`:  python scripts/build_charts.py   (or give another database file as the first argument)
Runs the question queries in analyses/. No extra libraries needed.
"""
import sys
from pathlib import Path

import duckdb

ROOT = Path(__file__).resolve().parents[1]
DB = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "innovatech.duckdb"
OUT = ROOT / "docs" / "charts"
ANALYSES = ROOT / "analyses"

MISS = 0.18  # Q1 missed its bookings target by 18% (given by the CRO). The target is worked back from it.
QUARTER = "date '2025-01-01'"  # the quarter of question 1

STYLE = """<style>
  :root { --ink:#0b0b0b; --muted:#52514e; --grid:#d9d8d3; --won:#1baf7a; --lost:#e45d52; --open:#2a78d6; --extra:#8fd3b6; --pipe:#2a78d6; --orphan:#eb6834; }
  @media (prefers-color-scheme: dark) {
    :root { --ink:#f0efec; --muted:#c3c2b7; --grid:#3a3a38; --won:#199e70; --lost:#d9534a; --open:#3987e5; --extra:#7cc3a5; --pipe:#3987e5; --orphan:#d95926; }
  }
  text { font-family: system-ui, -apple-system, 'Segoe UI', sans-serif; fill: var(--ink); font-size: 13px; }
  .muted { fill: var(--muted); font-size: 12px; }
  .strong { font-weight: 600; }
  .on { fill: #0b0b0b; font-size: 12px; font-weight: 600; }
  .grid { stroke: var(--grid); stroke-width: 1; }
  .won { fill: var(--won); } .open { fill: var(--open); } .lost { fill: var(--lost); } .extra { fill: var(--extra); } .pipe { fill: var(--pipe); } .orphan { fill: var(--orphan); }
</style>"""


def run(con, query, columns, where=""):
    """Run analyses/<query>.sql and return the chosen columns."""
    sql = (ANALYSES / f"{query}.sql").read_text()
    return con.execute(f"select {columns} from ({sql}) {where}").fetchall()


def k(v):
    return f"${v / 1000:,.0f}k"


def m(v):
    return f"${v / 1e6:.2f}M"


def svg(width, height, title, desc, body):
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width} {height}" role="img" '
        f'aria-labelledby="t d">\n<title id="t">{title}</title><desc id="d">{desc}</desc>\n'
        f"{STYLE}\n{body}\n</svg>\n"
    )


def legend(items, x, y):
    out, cx = [], x
    for cls, label in items:
        out.append(f'<rect x="{cx}" y="{y}" width="12" height="12" rx="2" class="{cls}"/>')
        out.append(f'<text x="{cx + 18}" y="{y + 11}" class="muted">{label}</text>')
        cx += 18 + 7 * len(label) + 22
    return "\n".join(out)


def stacked_row(x0, y, h, scale, parts):
    """parts = [(class, value, label)]. 2px gap between segments; label only if it fits."""
    out, x = [], x0
    for cls, v, label in parts:
        w = v * scale
        if w <= 0:
            continue
        out.append(f'<rect x="{x:.1f}" y="{y}" width="{max(w - 2, 1):.1f}" height="{h}" class="{cls}"><title>{label}</title></rect>')
        if w >= 44:
            out.append(f'<text x="{x + (w - 2) / 2:.1f}" y="{y + h / 2 + 4}" text-anchor="middle" class="on">{label}</text>')
        x += w
    return "\n".join(out)


def chart_forecast(con):
    rows = {
        r[0]: r[1:]
        for r in run(con, "q1_forecast", "bucket, forecast_amount::double, booked_amount::double",
                     f"where quarter = {QUARTER}")
    }
    won, lost, left = (rows[b][0] for b in ("1. Called -> won in quarter", "2. Called -> lost", "3. Called -> expired, never closed"))
    booked_called = rows["1. Called -> won in quarter"][1]
    booked_other = sum(v[1] for b, v in rows.items() if b.startswith(("5.", "6.")))
    target = (booked_called + booked_other) / (1 - MISS)
    call_date = con.execute(
        f"select min(snapshot_date) from \"3_gold\".fct_deal_snapshots where is_forecast_call and snapshot_quarter = {QUARTER}"
    ).fetchone()[0]
    x0, scale = 200, 425 / 1e6
    body = [
        legend([("won", "Won"), ("lost", "Lost"), ("open", "Left open after close date"), ("extra", "Won, not in the forecast")], 200, 12),
        f'<text x="190" y="82" text-anchor="end" class="strong">Forecast on {call_date.day} {call_date:%b}</text>',
        f'<text x="190" y="99" text-anchor="end" class="muted">{k(won + lost + left)}</text>',
        stacked_row(x0, 66, 44, scale, [("won", won, k(won)), ("lost", lost, k(lost)), ("open", left, k(left))]),
        f'<text x="190" y="152" text-anchor="end" class="strong">Q1 bookings</text>',
        f'<text x="190" y="169" text-anchor="end" class="muted">{k(booked_called + booked_other)}</text>',
        stacked_row(x0, 136, 44, scale, [("won", booked_called, k(booked_called)), ("extra", booked_other, k(booked_other))]),
        f'<line x1="{x0 + target * scale:.1f}" x2="{x0 + target * scale:.1f}" y1="52" y2="196" stroke="var(--ink)" stroke-dasharray="4 3"/>',
        f'<text x="{x0 + target * scale:.1f}" y="214" text-anchor="end" class="muted">Target about {m(target)} (worked back from the 18% miss)</text>',
    ]
    return svg(720, 226, "Q1 forecast and bookings",
               f"On {call_date.day} {call_date:%B} the Q1 forecast was {k(won + lost + left)}: {k(won)} was won, {k(lost)} lost and {k(left)} left open after its close date. Q1 booked {k(booked_called + booked_other)}.",
               "\n".join(body))


def chart_funnel(con):
    rows = run(con, "q2_where_deals_stall", "stage, won, lost, stale_no_decision", "order by stage_order")
    x0, scale = 200, 480 / 230
    body = [legend([("won", "Won"), ("lost", "Lost"), ("open", "Left open after close date")], 200, 12)]
    for i, (stage, w_, l_, o_) in enumerate(rows):
        y = 50 + i * 50
        body.append(f'<text x="190" y="{y + 16}" text-anchor="end" class="strong">{stage}</text>')
        body.append(f'<text x="190" y="{y + 32}" text-anchor="end" class="muted">{w_ + l_ + o_} deals</text>')
        body.append(stacked_row(x0, y, 36, scale, [("won", w_, str(w_)), ("lost", l_, str(l_)), ("open", o_, str(o_))]))
    body.append(f'<text x="{x0}" y="258" class="muted">Deals whose close date has passed, by the furthest stage they reached</text>')
    left = {stage: o_ for stage, _, _, o_ in rows}
    return svg(720, 270, "Where deals end up, by stage",
               "Deals reach their close date without a decision in every stage. Left open: "
               + ", ".join(f"{n} in {stage}" for stage, n in left.items()) + ".",
               "\n".join(body))


def chart_pipeline(con):
    rows = run(con, "q3_pipeline_before_quarter",
               "strftime(quarter, '%Y') || ' Q' || quarter(quarter), open_pipe_amount::double, is_current_reading",
               "order by quarter")
    left = run(con, "q3_live_pipeline", "coalesce(sum(orphaned_amount), 0)::double",
               "where close_quarter = date '2025-07-01'")[0][0]
    base, top, ymax = 262, 56, 5e6
    scale = (base - top) / ymax
    body = [legend([("pipe", "Open pipeline"), ("orphan", "Owned by a rep who has left")], 60, 12)]
    for t in range(0, 6):
        y = base - t * 1e6 * scale
        body.append(f'<line x1="60" x2="710" y1="{y:.1f}" y2="{y:.1f}" class="grid"/>')
        body.append(f'<text x="52" y="{y + 4:.1f}" text-anchor="end" class="muted">{"$0" if t == 0 else f"${t}M"}</text>')
    slot = 650 / len(rows)
    for i, (q, amount, now) in enumerate(rows):
        cx = 60 + slot * i + slot / 2
        bw = 58
        active = amount - (left if now else 0)
        h1 = active * scale
        body.append(f'<rect x="{cx - bw / 2:.1f}" y="{base - h1:.1f}" width="{bw}" height="{h1:.1f}" class="pipe"><title>{q}: {m(active)}</title></rect>')
        if now:
            h2 = left * scale
            body.append(f'<rect x="{cx - bw / 2:.1f}" y="{base - h1 - h2 - 2:.1f}" width="{bw}" height="{h2:.1f}" class="orphan"><title>Owner has left: {k(left)}</title></rect>')
            body.append(f'<text x="{cx:.1f}" y="{base - h1 - h2 / 2 + 2:.1f}" text-anchor="middle" class="on">{k(left)}</text>')
        body.append(f'<text x="{cx:.1f}" y="{base - (amount * scale) - 8:.1f}" text-anchor="middle" class="strong">{m(amount)}</text>')
        body.append(f'<text x="{cx:.1f}" y="{base + 18}" text-anchor="middle" class="muted">{q}{" (now)" if now else ""}</text>')
    body.append(f'<text x="60" y="304" class="muted">Open pipeline for each quarter, measured about 3 weeks before it started</text>')
    body.append(f'<text x="60" y="322" class="muted">Q2 2024 is low because the data starts in January 2024</text>')
    past = [amount for _, amount, now in rows if not now]
    return svg(720, 332, "Open pipeline before each quarter",
               f"Three weeks before each quarter, open pipeline was {m(min(past))} to {m(max(past))}. For Q3 2025 it is {m(rows[-1][1])}, of which {k(left)} belongs to reps who have left.",
               "\n".join(body))


def main():
    con = duckdb.connect(str(DB), read_only=True)
    OUT.mkdir(parents=True, exist_ok=True)
    for name, fn in [("1_q1_forecast", chart_forecast), ("2_stalled_deals", chart_funnel), ("3_q3_pipeline", chart_pipeline)]:
        (OUT / f"{name}.svg").write_text(fn(con))
        print("wrote", OUT / f"{name}.svg")


if __name__ == "__main__":
    main()
