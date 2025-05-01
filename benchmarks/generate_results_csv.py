#!/usr/bin/env python3
import re, csv, statistics as stats
from pathlib import Path

BENCH = Path("benchmarks")   # change if your folder differs

# ────────────────────────────── parsing helpers ──────────────────────────────
def parse_ping(path):
    rx = re.compile(r"time=([\d.]+)")
    rtt = [float(m.group(1)) for line in path.read_text().splitlines()
           if (m := rx.search(line))]
    if not rtt:
        raise ValueError(f"No RTT samples in {path}")
    return rtt

def load_mpstat(path):
    """
    Returns dict with average %usr, %sys, %irq, %soft, %idle
    from `mpstat -P ALL 1 15` output.
    """
    cols = ['time','CPU','%usr','%nice','%sys','%iowait',
            '%irq','%soft','%steal','%guest','%gnice','%idle']
    keep = []
    for line in path.read_text().splitlines():
        parts = line.split()
        if len(parts) == 12 and (parts[1].isdigit() or parts[1]=='all'):
            keep.append(dict(zip(cols, parts)))
    if not keep:
        raise ValueError(f"No mpstat rows in {path}")
    sums = {k:0.0 for k in ['%usr','%sys','%irq','%soft','%idle']}
    for row in keep:
        for k in sums:
            sums[k] += float(row[k])
    n = len(keep)
    return {k: v/n for k,v in sums.items()}

def pct(lst, p):
    """Return p-th percentile (0-100) using nearest-rank method."""
    if not lst:
        return None
    k = int(round((len(lst)-1) * p/100))
    return sorted(lst)[k]

# ───────────────────────────── load artefacts ────────────────────────────────
ipv4_base = parse_ping(BENCH/"baseline_ipv4.txt")
ipv4_xdp  = parse_ping(BENCH/"xdp_ipv4.txt")

flood_base = parse_ping(BENCH/"baseline_ping_flood.txt")
flood_xdp  = parse_ping(BENCH/"xdp_ping_flood.txt")

cpu_base = load_mpstat(BENCH/"baseline_mpstat.txt")
cpu_xdp  = load_mpstat(BENCH/"xdp_mpstat.txt")

# ─────────────────────────── build result table ──────────────────────────────
rows = [
    ("ping_mean_ms",       stats.mean(ipv4_base),  stats.mean(ipv4_xdp)),
    ("ping_median_ms",     stats.median(ipv4_base),stats.median(ipv4_xdp)),
    ("ping_std_ms",        stats.stdev(ipv4_base), stats.stdev(ipv4_xdp)),
    ("ping_min_ms",        min(ipv4_base),         min(ipv4_xdp)),
    ("ping_95p_ms",        pct(ipv4_base,95),      pct(ipv4_xdp,95)),
    ("ping_99p_ms",        pct(ipv4_base,99),      pct(ipv4_xdp,99)),
    ("ping_max_ms",        max(ipv4_base),         max(ipv4_xdp)),
    ("flood_mean_ms",      stats.mean(flood_base), stats.mean(flood_xdp)),
    ("flood_99p_ms",       pct(flood_base,99),     pct(flood_xdp,99)),
    ("cpu_busy_pct",       100-cpu_base['%idle'],  100-cpu_xdp['%idle']),
    ("cpu_usr_pct",        cpu_base['%usr'],       cpu_xdp['%usr']),
    ("cpu_sys_pct",        cpu_base['%sys'],       cpu_xdp['%sys']),
    ("cpu_irq_pct",        cpu_base['%irq'],       cpu_xdp['%irq']),
    ("cpu_soft_pct",       cpu_base['%soft'],      cpu_xdp['%soft']),
]

# ─────────────────────────────── write CSV ───────────────────────────────────
with open("results_summary.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["metric","baseline","xdp"])
    writer.writerows(rows)

print("✓ Wrote results_summary.csv with", len(rows), "rows")
