#!/usr/bin/env python3
"""Estimate linear benchmark conversions to MMLU from llm.csv."""

from __future__ import annotations

import csv
from pathlib import Path

import numpy as np


INPUT = Path("llm.csv")
OUTPUT = Path("to_mmlu.csv")
DIAGNOSTICS = Path("correlation-diagnostics.csv")
BENCHMARKS = ["MMLU", "MMLU-Pro", "MMLU-Redux", "SWE-Bench-Pro", "LiveCodeBench"]


def as_float(value: str) -> float | None:
    value = value.strip()
    if not value:
        return None
    return float(value)


def fit(xs: list[float], ys: list[float]) -> tuple[float, float]:
    """Return slope and intercept for y = slope*x + intercept."""
    if len(xs) < 2:
        raise ValueError("at least two points are required")
    slope, intercept = np.polyfit(np.array(xs), np.array(ys), 1)
    return float(slope), float(intercept)


def r_squared(xs: list[float], ys: list[float], slope: float, intercept: float) -> float:
    y = np.array(ys)
    predicted = slope * np.array(xs) + intercept
    total = float(np.sum((y - np.mean(y)) ** 2))
    if total == 0.0:
        return 0.0
    residual = float(np.sum((y - predicted) ** 2))
    return 1.0 - residual / total


def direct_pairs(rows: list[dict[str, str]], benchmark: str) -> tuple[list[float], list[float]]:
    xs: list[float] = []
    ys: list[float] = []
    for row in rows:
        x = as_float(row[benchmark])
        y = as_float(row["MMLU"])
        if x is not None and y is not None:
            xs.append(x)
            ys.append(y)
    return xs, ys


def paired_scores(rows: list[dict[str, str]], x_benchmark: str, y_benchmark: str) -> tuple[list[float], list[float]]:
    xs: list[float] = []
    ys: list[float] = []
    for row in rows:
        x = as_float(row[x_benchmark])
        y = as_float(row[y_benchmark])
        if x is not None and y is not None:
            xs.append(x)
            ys.append(y)
    return xs, ys


def main() -> None:
    with INPUT.open(newline="") as f:
        rows = list(csv.DictReader(f))

    conversions: dict[str, tuple[float, float]] = {"MMLU": (1.0, 0.0)}
    diagnostics: list[tuple[str, str, int, float]] = [("MMLU", "identity", 0, 1.0)]

    for benchmark in ["MMLU-Pro", "MMLU-Redux"]:
        xs, ys = direct_pairs(rows, benchmark)
        slope, intercept = fit(xs, ys)
        conversions[benchmark] = (slope, intercept)
        diagnostics.append((benchmark, f"{benchmark}->MMLU direct", len(xs), r_squared(xs, ys, slope, intercept)))

    for coding_benchmark in ["SWE-Bench-Pro", "LiveCodeBench"]:
        coding_xs, coding_pro_ys = paired_scores(rows, coding_benchmark, "MMLU-Pro")
        if len(coding_xs) < 2:
            xs, ys = direct_pairs(rows, coding_benchmark)
            slope, intercept = fit(xs, ys)
            conversions[coding_benchmark] = (slope, intercept)
            diagnostics.append((coding_benchmark, f"{coding_benchmark}->MMLU direct", len(xs), r_squared(xs, ys, slope, intercept)))
            continue

        coding_to_pro_slope, coding_to_pro_intercept = fit(coding_xs, coding_pro_ys)
        pro_to_mmlu_slope, pro_to_mmlu_intercept = conversions["MMLU-Pro"]
        conversions[coding_benchmark] = (
            pro_to_mmlu_slope * coding_to_pro_slope,
            pro_to_mmlu_slope * coding_to_pro_intercept + pro_to_mmlu_intercept,
        )
        diagnostics.append(
            (
                coding_benchmark,
                f"{coding_benchmark}->MMLU-Pro composed with MMLU-Pro->MMLU",
                len(coding_xs),
                r_squared(coding_xs, coding_pro_ys, coding_to_pro_slope, coding_to_pro_intercept),
            )
        )

    with OUTPUT.open("w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["Benchmark name", "slope", "intercept"])
        for benchmark in BENCHMARKS:
            slope, intercept = conversions[benchmark]
            writer.writerow([benchmark, f"{slope:.8f}", f"{intercept:.8f}"])

    with DIAGNOSTICS.open("w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["Benchmark name", "fit path", "n", "r_squared"])
        for benchmark, path, n, r2 in diagnostics:
            writer.writerow([benchmark, path, n, f"{r2:.8f}"])


if __name__ == "__main__":
    main()
