"""Dotfiles commit history — equal-spaced bars with chronological mapping below.

Layout:
  ┌─────────────────────────────┐
  │  stacked bar chart          │  ax_bars — one bar per active month,
  │  (equal spacing on x)       │  equal width, stacked by category,
  │                             │  weighted by lines changed (added+removed)
  └─────────────────────────────┘
           \\  |  |  |  /           connecting lines (ConnectionPatch)
            \\ | | | | /            from bar x-position → timeline x-position
  ─────────────────────────────    ax_time — linear timeline with year ticks

The bar x-axis is ordinal (month 0, 1, 2, ...) so all months with commits
get equal visual weight regardless of calendar gaps. The timeline below is
proportional to real time, so the connecting lines fan out where commits are
dense and collapse where they're sparse (e.g. the 2020–2022 gap).

The timeline is slightly narrower than the bar chart so the outermost
connecting lines angle outward (trapezoid shape, not rectangle).

Data: reads file_changes.csv (one row per file per commit) and
categories.json (classification schema with colors).

Tufte style: no gridlines, no spines, no chart junk. Direct labels.
"""

import argparse
import json
import sys
from datetime import datetime, date

import numpy as np
import polars as pl
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import matplotlib.ticker as mticker
from matplotlib.patches import ConnectionPatch, FancyBboxPatch


def load_schema(path):
    """Load category order and colors from categories.json."""
    with open(path) as f:
        schema = json.load(f)
    categories = list(schema["categories"].keys())
    colors = {cat: info["color"] for cat, info in schema["categories"].items()}
    return categories, colors


def load_data(path):
    """Load file_changes.csv into a polars DataFrame."""
    return pl.read_csv(path, try_parse_dates=True)


# =========================================================================
# MILESTONE ANNOTATIONS
# Each entry: (bar_index, label, side)
# side controls text offset: "left" or "right" of the connecting line.
# Heights are auto-staggered to avoid overlap.
# =========================================================================
# Each entry: (bar_index, label, y_frac, ha, x_nudge)
# y_frac: fraction of ymax for text placement
# ha: horizontal alignment ("center", "left", "right")
# x_nudge: offset in bar-units — text sits here, leader line angles from bar to text
MILESTONES = [
    (0,  "first dotfiles",       0.55, "left",    1.5),
    (2,  "vim config begins",    0.38, "left",    1.5),
    (10, "snippets & templates", 0.55, "center",  0),
    (16, "shell/tmux overhaul",  0.68, "center",  0),
    (24, "fresh start (v2)",     0.55, "left",    1.5),
    (35, "packer → lazy.nvim",   0.42, "right",  -3.0),
    (36, "AI tooling arrives",   0.55, "right",  -1.5),
    (37, "AI explosion",         0.68, "right",  -2.0),
]


def plot(data_path, schema_path, out_path, annotate=False):
    cat_order, colors = load_schema(schema_path)
    df = load_data(data_path)

    # total churn per file-change row
    df = df.with_columns(
        (pl.col("added") + pl.col("removed")).alias("loc"),
        pl.col("date").dt.truncate("1mo").alias("month"),
    )

    # aggregate: lines changed per (month, category)
    monthly = (
        df.group_by(["month", "category"])
        .agg(pl.col("loc").sum())
        .pivot(on="category", index="month", values="loc")
        .fill_null(0)
        .sort("month")
    )

    for cat in cat_order:
        if cat not in monthly.columns:
            monthly = monthly.with_columns(pl.lit(0).alias(cat))

    n = len(monthly)           # number of active months (bars)
    xs = np.arange(n)          # ordinal x positions: 0, 1, 2, ...
    # mid-month timestamps for mapping to the linear timeline
    month_dates = monthly["month"].to_list()
    timestamps = [m.replace(day=15) for m in month_dates]

    # find the first month belonging to the "current" (v2) repo
    month_repos = (
        df.group_by("month").agg(pl.col("repo").first())
        .sort("month")
    )
    repo_map = dict(zip(
        month_repos["month"].to_list(),
        month_repos["repo"].to_list(),
    ))
    boundary_idx = None
    for i, m in enumerate(month_dates):
        if repo_map.get(m) == "current":
            boundary_idx = i
            break

    # =====================================================================
    # FIGURE LAYOUT
    # Two subplots stacked vertically: bars (4x height) and timeline (1.4x).
    # hspace=0.30 leaves room for the connecting lines between them.
    # =====================================================================
    fig, (ax_bars, ax_time) = plt.subplots(
        2, 1, figsize=(12, 5.4),
        gridspec_kw={"height_ratios": [4, 1.4], "hspace": 0.30},
        sharex=False,
    )

    # =====================================================================
    # STACKED BAR CHART (ax_bars)
    # Each bar is one month with commits. Width 0.85 leaves a small gap.
    # Categories stacked bottom-to-top in schema order.
    # =====================================================================
    bottom = np.zeros(n)
    for cat in cat_order:
        vals = monthly[cat].to_numpy().astype(float)
        if vals.sum() == 0:
            continue
        ax_bars.bar(
            xs, vals, bottom=bottom, width=0.85,
            color=colors[cat], label=cat, edgecolor="none",
        )
        bottom += vals

    # v1/v2 divider — vertical line at the repo boundary
    if boundary_idx is not None:
        bx = boundary_idx - 1.5
        ax_bars.axvline(bx, color="#666666", linewidth=0.8)
        ymax = ax_bars.get_ylim()[1]
        ax_bars.text(bx - 0.5, ymax * 0.96, "v1",
                     fontsize=8.5, color="#999999", ha="right", va="top",
                     style="italic")
        ax_bars.text(bx + 0.5, ymax * 0.96, "v2",
                     fontsize=8.5, color="#999999", ha="left", va="top",
                     style="italic")

    # right-side padding so the last bar isn't jammed against the edge
    ax_bars.set_xlim(-0.5, n + 0.5)
    ax_bars.yaxis.set_major_locator(mticker.MaxNLocator(integer=True, nbins=5))
    ax_bars.set_xticks([])
    for spine in ax_bars.spines.values():
        spine.set_visible(False)
    ax_bars.tick_params(axis="y", length=0, labelsize=8.5, colors="#444444")
    ax_bars.set_ylabel("lines changed / month", fontsize=8, color="#888888",
                        labelpad=8)

    # legend — top left, offset right of y-axis label
    handles = [mpatches.Patch(color=colors[c], label=c) for c in cat_order]
    ax_bars.legend(
        handles=handles, frameon=False, fontsize=7.5, loc="upper left",
        ncol=3, handlelength=1, handletextpad=0.4, columnspacing=1,
        bbox_to_anchor=(0.06, 1.0),
    )

    # =====================================================================
    # TIMELINE (ax_time)
    # A horizontal line with year ticks, positioned proportional to real
    # calendar time. Narrower than the bar chart (8% margin each side)
    # so connecting lines form a trapezoid shape: \  |  |  /
    # =====================================================================
    ts_numeric = np.array([t.timestamp() for t in timestamps])
    t_min, t_max = ts_numeric.min(), ts_numeric.max()
    t_span = t_max - t_min if t_max != t_min else 1

    # inset margins — makes the timeline narrower than the bars above
    margin = n * 0.08
    tl_left = margin               # left edge of timeline in bar-x coords
    tl_right = n - 1 - margin      # right edge
    tl_span = tl_right - tl_left

    def t_to_x(t):
        """Map a unix timestamp to a position in bar-x coordinate space."""
        return tl_left + ((t - t_min) / t_span) * tl_span

    time_xs = np.array([t_to_x(t) for t in ts_numeric])

    # timeline axis line — extends slightly past outermost data points
    tl_pad = tl_span * 0.03
    ax_time.plot([tl_left - tl_pad, tl_right + tl_pad], [0, 0],
                 color="#777777", linewidth=1.5, solid_capstyle="butt", zorder=10)

    # year ticks at Jan 1st of each year, linearly spaced by real time
    first_year = timestamps[0].year
    last_year = timestamps[-1].year
    for yr in range(first_year, last_year + 1):
        jan1 = datetime(yr, 1, 1).timestamp()
        tx = t_to_x(jan1)
        if tx < tl_left - 0.5 or tx > tl_right + 0.5:
            continue
        ax_time.plot([tx, tx], [-0.1, 0.1], color="#666666", linewidth=1.3, zorder=10)
        ax_time.text(tx, -0.2, str(yr), ha="center", va="top",
                     fontsize=7.5, color="#444444")

    ax_time.set_xlim(-0.5, n + 0.5)
    ax_time.set_ylim(-1.6, 0.6)
    ax_time.set_xticks([])
    ax_time.set_yticks([])
    for spine in ax_time.spines.values():
        spine.set_visible(False)

    # =====================================================================
    # CAREER TIMELINE (Gantt bars below the year-tick line)
    # Two rows: "role" (employment) and "education", using t_to_x mapping.
    # =====================================================================
    # career phases: (label, start, end, color)
    # colors: muted blue-grey for staff roles, green for PhD, warm for postdocs
    CAREER = [
        ("UCD Genome Center",   date(2009, 9, 1),  date(2012, 6, 1),  "#A8B8CC"),
        ("bioinfo",             date(2012, 6, 1),  date(2014, 9, 1),  "#A8B8CC"),
        ("PhD",                date(2014, 9, 1),  date(2019, 9, 1),  "#B5C9A1"),
        ("Postdoc (Oregon)",   date(2019, 9, 1),  date(2022, 10, 1), "#D4BAA0"),
        ("Postdoc (Berkeley)", date(2022, 11, 1), date(2025, 3, 1),  "#D4BAA0"),
        ("IDM",                date(2025, 3, 1),  date(2026, 3, 1),  "#C0B8D4"),
    ]

    bar_h = 0.28
    career_y = -0.68  # y-center for career row
    # visible time range for clipping
    vis_left = tl_left - tl_pad
    vis_right = tl_right + tl_pad

    for label, d_start, d_end, color in CAREER:
        x0 = t_to_x(datetime(d_start.year, d_start.month, d_start.day).timestamp())
        x1 = t_to_x(datetime(d_end.year, d_end.month, d_end.day).timestamp())
        # clip to visible timeline range
        x0_vis = max(x0, vis_left)
        x1_vis = min(x1, vis_right)
        if x1_vis <= x0_vis:
            continue
        w = x1_vis - x0_vis
        ax_time.add_patch(FancyBboxPatch(
            (x0_vis, career_y - bar_h / 2), w, bar_h,
            boxstyle="round,pad=0.02",
            facecolor=color, edgecolor="white", linewidth=0.8,
            zorder=5,
        ))
        # label centered in the visible portion of the bar
        mid_x = (x0_vis + x1_vis) / 2
        ax_time.text(mid_x, career_y, label, ha="center", va="center",
                     fontsize=5.5, color="#444444", zorder=6,
                     clip_on=True)

    # =====================================================================
    # CONNECTING LINES (bar positions → timeline positions)
    # Each line goes from the bottom of a bar (ordinal x) straight down
    # to the corresponding point on the linear timeline. The trapezoid
    # shape emerges because the timeline is narrower than the bars.
    # =====================================================================
    for i in range(n):
        con = ConnectionPatch(
            xyA=(xs[i], -0.02), coordsA=ax_bars.transData,
            xyB=(time_xs[i], 0.06), coordsB=ax_time.transData,
            color="#CCCCCC", linewidth=0.6,
            arrowstyle="-",       # plain line, no arrowheads
            shrinkA=1, shrinkB=0, # tiny gap at bar end, flush at timeline
            capstyle="round",      # round endcaps at timeline
        )
        con.set_antialiased(True)
        fig.add_artist(con)

    # =====================================================================
    # MILESTONE ANNOTATIONS (enabled with --annotate flag)
    # Small text labels above selected bars with thin leader lines.
    # Heights stagger between two levels to avoid overlap.
    # =====================================================================
    if annotate:
        ymax = ax_bars.get_ylim()[1]
        for bar_idx, label, y_frac, ha, x_nudge in MILESTONES:
            level = ymax * y_frac
            bar_top = bottom[bar_idx]
            text_x = xs[bar_idx] + x_nudge
            # angled leader line from bar top to text position
            ax_bars.plot(
                [xs[bar_idx], text_x],
                [bar_top + ymax * 0.02, level - ymax * 0.02],
                color="#AAAAAA", linewidth=0.5, solid_capstyle="butt",
            )
            ax_bars.text(
                text_x, level, label,
                ha=ha, va="bottom", fontsize=6.5, color="#666666",
                style="italic",
            )

    # subtle attribution for blog use
    fig.text(0.98, 0.05, "github.com/vsbuffalo/dotfiles", fontsize=6.5,
             color="#AAAAAA", ha="right", va="bottom",
             transform=ax_time.transAxes)
    
    fig.savefig(out_path, dpi=200, facecolor="white",
                bbox_inches="tight", pad_inches=0.15)
    print(f"wrote {out_path}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("data")
    parser.add_argument("schema")
    parser.add_argument("output")
    parser.add_argument("--annotate", action="store_true",
                        help="Show milestone annotations on bars")
    args = parser.parse_args()
    plot(args.data, args.schema, args.output, annotate=args.annotate)
