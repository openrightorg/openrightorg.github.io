#!/usr/bin/env python3
"""Generate density.webp from llm.csv and to_mmlu.csv."""

from __future__ import annotations

import argparse
import csv
import math
from datetime import datetime
from pathlib import Path

import matplotlib.dates as mdates
import matplotlib.pyplot as plt


DATA = Path("llm.csv")
CONVERSIONS = Path("to_mmlu.csv")
OUTPUT = Path("density.webp")
BENCHMARKS = ["MMLU", "MMLU-Pro", "MMLU-Redux", "LiveCodeBench", "SWE-Bench-Pro"]
DISABLED_BENCHMARKS = {"SWE-Bench-Pro"}
LABEL_COLLISION_Y = 0.010
COLORS = {
    "MMLU": "#1b6ca8",
    "MMLU-Pro": "#2a9d55",
    "MMLU-Redux": "#7b4ab8",
    "LiveCodeBench": "#c77d00",
    "SWE-Bench-Pro": "#b23a48",
}


def as_float(value: str) -> float | None:
    value = value.strip()
    if not value:
        return None
    return float(value)


def density(score: float, size_gb: float) -> float:
    return -math.log(1.0 - score / 100.0) / size_gb


def load_conversions() -> dict[str, tuple[float, float]]:
    with CONVERSIONS.open(newline="") as f:
        return {
            row["Benchmark name"]: (float(row["slope"]), float(row["intercept"]))
            for row in csv.DictReader(f)
        }


def to_mmlu(score: float, benchmark: str, conversions: dict[str, tuple[float, float]]) -> float:
    slope, intercept = conversions[benchmark]
    return slope * score + intercept


def inverse_mmlu(score: float, benchmark: str, conversions: dict[str, tuple[float, float]]) -> float:
    slope, intercept = conversions[benchmark]
    return (score - intercept) / slope


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate density plots from llm.csv and to_mmlu.csv.")
    parser.add_argument("--min-params", type=float, help="Minimum total parameters (billions) to include.")
    parser.add_argument("--max-params", type=float, help="Maximum total parameters (billions) to include.")
    parser.add_argument("--output", type=str, default="density.webp", help="Output image filename (default: density.webp).")
    args = parser.parse_args()

    conversions = load_conversions()
    enabled_benchmarks = [benchmark for benchmark in BENCHMARKS if benchmark not in DISABLED_BENCHMARKS]
    points: dict[str, list[tuple[datetime, float, str, float]]] = {benchmark: [] for benchmark in enabled_benchmarks}
    all_densities: list[float] = []

    with DATA.open(newline="") as f:
        for row in csv.DictReader(f):
            size = as_float(row["Quantized Model Size"])
            params = as_float(row["Total Parameters (billions)"])
            if size is None or size <= 0:
                continue
            if args.min_params is not None and (params is None or params < args.min_params):
                continue
            if args.max_params is not None and (params is None or params > args.max_params):
                continue
            date = datetime.fromisoformat(row["Model Release Date"])

            for benchmark in enabled_benchmarks:
                score = as_float(row[benchmark])
                if score is None:
                    continue
                d = density(score, size)
                points[benchmark].append((date, d, row["Model Name"], score))
                all_densities.append(d)

    if not all_densities:
        raise RuntimeError("no benchmark values found")

    reference_size = 1.0
    min_density = min(all_densities)
    max_density = max(all_densities)

    # Calculate equivalent MMLU scores for the density limits at reference_size
    # Y = -ln(1 - R/100) / reference_size  =>  R = 100 * (1 - exp(-Y * reference_size))
    min_equiv = 100 * (1 - math.exp(-min_density * reference_size))
    max_equiv = 100 * (1 - math.exp(-max_density * reference_size))

    # Add some buffer to the scores for axis limits
    min_equiv = max(0.1, min_equiv - 2.0)
    max_equiv = min(99.9, max_equiv + 2.0)

    fig, ax_mmlu = plt.subplots(figsize=(12, 7))
    ax_pro = ax_mmlu.twinx()
    ax_redux = ax_mmlu.twinx()
    ax_lcb = ax_mmlu.twinx()
    ax_swe = ax_mmlu.twinx()

    axis_for = {
        "MMLU": ax_mmlu,
        "MMLU-Pro": ax_pro,
        "MMLU-Redux": ax_redux,
        "LiveCodeBench": ax_lcb,
        "SWE-Bench-Pro": ax_swe,
    }
    right_axes = [benchmark for benchmark in enabled_benchmarks if benchmark != "MMLU"]
    for index, benchmark in enumerate(right_axes):
        if index == 0:
            continue
        axis_for[benchmark].spines.right.set_position(("axes", 1.0 + 0.12 * index))
    markers = {"MMLU": "o", "MMLU-Pro": "s", "MMLU-Redux": "D", "LiveCodeBench": "P", "SWE-Bench-Pro": "^"}

    for benchmark in enabled_benchmarks:
        # Plot everything on ax_mmlu to avoid clipping by twinned axes with different limits
        xs = [p[0] for p in points[benchmark]]
        ys = [p[1] for p in points[benchmark]]
        ax_mmlu.scatter(xs, ys, s=52, color=COLORS[benchmark], marker=markers[benchmark], label=benchmark, alpha=0.86)

    # Autoscale Y axis to fit the actual densities being plotted
    y_buffer = (max_density - min_density) * 0.05 if max_density > min_density else 0.1
    ax_mmlu.set_ylim(min_density - y_buffer, max_density + y_buffer)
    for benchmark, ax in [
        ("MMLU-Pro", ax_pro),
        ("MMLU-Redux", ax_redux),
        ("LiveCodeBench", ax_lcb),
        ("SWE-Bench-Pro", ax_swe),
    ]:
        if benchmark not in enabled_benchmarks:
            ax.set_visible(False)
            continue
        lower = inverse_mmlu(min_equiv, benchmark, conversions)
        upper = inverse_mmlu(max_equiv, benchmark, conversions)
        lower = max(0.1, min(98.0, lower))
        upper = max(lower + 0.1, min(98.0, upper))
        ax.set_ylim(density(lower, reference_size), density(upper, reference_size))

    candidate_labels: list[tuple[float, float, datetime, float, str, str]] = []
    for benchmark in enabled_benchmarks:
        for date, native_y, label, score in points[benchmark]:
            mmlu_y = density(to_mmlu(score, benchmark, conversions), reference_size)
            candidate_labels.append((mmlu_y, native_y, date, native_y, benchmark, label))

    kept_labels: list[tuple[float, float, datetime, float, str, str]] = []
    for candidate in sorted(candidate_labels, reverse=True):
        _mmlu_y, native_collision_y, _date, _native_y, _benchmark, label = candidate
        collides = any(
            label == kept_label
            and (
                abs(native_collision_y - kept_native_collision_y) <= LABEL_COLLISION_Y
                or abs(_mmlu_y - kept_mmlu_y) <= LABEL_COLLISION_Y
            )
            for kept_mmlu_y, kept_native_collision_y, _kept_date, _kept_native_y, _kept_benchmark, kept_label in kept_labels
        )
        if not collides:
            kept_labels.append(candidate)

    for _mmlu_y, _native_collision_y, date, native_y, benchmark, label in kept_labels:
        ax_mmlu.annotate(label, (date, native_y), xytext=(4, 4), textcoords="offset points", fontsize=7)

    ax_mmlu.set_title("Open Model Intelligence Density Over Time")
    ax_mmlu.set_xlabel("Model release date")
    ax_mmlu.set_ylabel("MMLU density: -ln(error) per quantized GB", color=COLORS["MMLU"])
    ax_pro.set_ylabel("MMLU-Pro density per quantized GB", color=COLORS["MMLU-Pro"])
    ax_redux.set_ylabel("MMLU-Redux density per quantized GB", color=COLORS["MMLU-Redux"])
    ax_lcb.set_ylabel("LiveCodeBench density per quantized GB", color=COLORS["LiveCodeBench"])
    ax_swe.set_ylabel("SWE-Bench-Pro density per quantized GB", color=COLORS["SWE-Bench-Pro"])

    for benchmark, ax in axis_for.items():
        if benchmark not in enabled_benchmarks:
            continue
        ax.tick_params(axis="y", colors=COLORS[benchmark])
        ax.spines["right" if benchmark != "MMLU" else "left"].set_color(COLORS[benchmark])

    ax_mmlu.grid(True, axis="both", alpha=0.22)
    ax_mmlu.xaxis.set_major_locator(mdates.MonthLocator(interval=4))
    ax_mmlu.xaxis.set_major_formatter(mdates.DateFormatter("%Y-%m"))
    fig.autofmt_xdate()

    handles, labels = [], []
    for benchmark in enabled_benchmarks:
        ax = axis_for[benchmark]
        h, l = ax.get_legend_handles_labels()
        handles.extend(h)
        labels.extend(l)
    ax_mmlu.legend(handles, labels, loc="upper left", frameon=False)

    fig.text(
        0.01,
        0.01,
        "Density uses quantized footprint. Axis limits use a shared MMLU-equivalent score range via to_mmlu.csv; plotted values remain native benchmark densities.",
        fontsize=8,
        color="#444444",
    )
    right_margin = max(0.78, 0.92 - 0.06 * max(0, len(right_axes) - 1))
    fig.tight_layout(rect=(0, 0.035, right_margin, 1))
    fig.savefig(args.output, dpi=180)


if __name__ == "__main__":
    main()
