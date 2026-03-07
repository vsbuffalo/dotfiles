"""Dotfiles commit history — Tufte-style timeline with category breakdown."""

import re
import sys
from datetime import datetime, timezone

import numpy as np
import polars as pl
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import matplotlib.ticker as mticker


CATEGORIES = {
    "editor": [
        r"n?vim", r"neovim", r"lazy", r"packer", r"lsp", r"treesitter",
        r"plugin", r"remap", r"keybind", r"keymap", r"complet", r"snippet",
        r"ultisnip", r"vundle", r"ctrlp", r"lightline", r"lualine",
        r"vimtex", r"telescope", r"nvimtree", r"yanky", r"comment plugin",
        r"copilot", r"rustaceanvim", r"mason", r"debugg", r"dap\b",
        r"breakpoint", r"spell", r"syntax highlight", r"stan syntax",
        r"filetypes",
    ],
    "shell & terminal": [
        r"zsh", r"tmux", r"prezto", r"antidote", r"alias", r"shell",
        r"terminal", r"PATH\b", r"antigen", r"starship", r"alacritty",
        r"direnv", r"extrakto", r"pane",
    ],
    "dev tools": [
        r"\bgit\b", r"conda", r"mamba", r"python", r"ipython", r"ptpython",
        r"\bR\b", r"r package", r"rust", r"ocaml", r"opam", r"cargo",
        r"snakemake", r"bioinfo", r"pyright", r"stan\b", r"gdb", r"latex",
        r"latexmk",
    ],
    "infrastructure": [
        r"setup\.sh", r"tailscale", r"router", r"brew", r"install",
        r"bootloader", r"savio", r"font", r"linux compat", r"infrastructure",
        r"gh cli", r"cloudflare",
    ],
    "AI & automation": [
        r"claude", r"dewey", r"agent", r"skill", r"arcana", r"permission",
    ],
}

COLORS = {
    "editor": "#4C72B0",
    "shell & terminal": "#DD8452",
    "dev tools": "#55A868",
    "infrastructure": "#C44E52",
    "AI & automation": "#8172B3",
    "other": "#CCCCCC",
}


def categorize(msg):
    msg_lower = msg.lower()
    for cat, patterns in CATEGORIES.items():
        for p in patterns:
            if re.search(p, msg_lower):
                return cat
    return "other"


def load_commits(path, label):
    rows = []
    with open(path) as f:
        for line in f:
            parts = line.split(",", 1)
            if len(parts) == 2:
                date_str, msg = parts[0].strip(), parts[1].strip()
                if date_str:
                    rows.append({
                        "date": datetime.fromisoformat(date_str),
                        "repo": label,
                        "category": categorize(msg),
                    })
    return pl.DataFrame(rows)


def plot(current_path, archived_path, out_path):
    df = pl.concat([
        load_commits(archived_path, "v1 (2013\u20132019)"),
        load_commits(current_path, "v2 (2023\u2013present)"),
    ]).sort("date")

    # truncate to month start for grouping
    df = df.with_columns(
        pl.col("date").dt.truncate("1mo").alias("month")
    )

    cat_order = list(COLORS.keys())

    # count commits per (month, category)
    monthly = (
        df.group_by(["month", "category"])
        .agg(pl.len().alias("count"))
        .pivot(on="category", index="month", values="count")
        .fill_null(0)
        .sort("month")
    )

    # ensure all categories present
    for cat in cat_order:
        if cat not in monthly.columns:
            monthly = monthly.with_columns(pl.lit(0).alias(cat))

    months = monthly["month"].to_list()
    # convert to matplotlib-friendly datetime
    month_dates = [m.replace(tzinfo=None) for m in months]

    fig, ax = plt.subplots(figsize=(10, 3.2))

    bottom = np.zeros(len(months))
    for cat in cat_order:
        vals = monthly[cat].to_numpy().astype(float)
        if vals.sum() == 0:
            continue
        ax.bar(
            month_dates, vals, bottom=bottom,
            width=25, color=COLORS[cat], label=cat, edgecolor="none",
        )
        bottom += vals

    # fresh start annotation
    ax.annotate(
        "fresh start", xy=(datetime(2023, 1, 15), 0),
        xytext=(datetime(2021, 6, 1), 12),
        fontsize=7.5, color="#666666",
        arrowprops=dict(arrowstyle="-", color="#AAAAAA", linewidth=0.7),
        va="center",
    )

    # tufte: strip chart junk
    for spine in ax.spines.values():
        spine.set_visible(False)
    ax.yaxis.set_ticks_position("none")
    ax.yaxis.set_major_locator(mticker.MaxNLocator(integer=True, nbins=4))
    ax.xaxis.set_major_locator(mdates.YearLocator())
    ax.xaxis.set_major_formatter(mdates.DateFormatter("%Y"))
    ax.tick_params(axis="x", length=3, width=0.6, color="#999999")
    ax.tick_params(axis="y", length=0)
    ax.tick_params(axis="both", labelsize=8.5, colors="#444444")

    # direct label instead of axis title
    ax.text(
        month_dates[0], ax.get_ylim()[1] * 0.97,
        "commits / month", fontsize=8, color="#888888", va="top",
    )

    ax.legend(
        frameon=False, fontsize=7.5, loc="upper right",
        ncol=2, handlelength=1, handletextpad=0.4, columnspacing=1,
    )

    fig.tight_layout()
    fig.savefig(out_path, dpi=150, bbox_inches="tight", facecolor="white")
    print(f"wrote {out_path}")


if __name__ == "__main__":
    plot(sys.argv[1], sys.argv[2], sys.argv[3])
