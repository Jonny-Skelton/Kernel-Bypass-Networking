#!/usr/bin/env python3
"""
plot_xdp_benchmarks.py
Produce stacked-bar CPU-util graphs (mpstat) and latency CDF/violin graphs
from the XDP benchmark artefacts.

Run:  python3 plot_xdp_benchmarks.py
      (PNG files written to ./fig_cpu_util.png and ./fig_latency.png)
"""

import re
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

# ---------------------------------------------------------------------------
# 1. Helpers to parse mpstat & ping-flood outputs
# ---------------------------------------------------------------------------

def load_mpstat(file):
    """
    Return a dict with average %usr, %sys, %irq, %soft, %idle for that file.
    Handles mpstat output recorded with:  mpstat -P ALL 1 15
    """
    cols = ['time', 'CPU', '%usr', '%nice', '%sys', '%iowait',
            '%irq', '%soft', '%steal', '%guest', '%gnice', '%idle']
    rows = []
    with open(file) as f:
        for line in f:
            sp = line.split()
            # Heuristic: valid data rows have 12 columns and CPU is a number or "all"
            if len(sp) == 12 and (sp[1].isdigit() or sp[1] == 'all'):
                rows.append(dict(zip(cols, sp)))
    if not rows:
        raise ValueError(f"No mpstat data parsed from {file}")
    df = pd.DataFrame(rows)
    df[['%usr','%sys','%irq','%soft','%idle']] = df[['%usr','%sys','%irq','%soft','%idle']].astype(float)
    return df[['%usr','%sys','%irq','%soft','%idle']].mean().to_dict()

def load_ping_times(file):
    """
    Extract RTTs (ms, float) from flood-ping output.
    """
    times = []
    rx = re.compile(r'time=([\d.]+)')
    with open(file) as f:
        for line in f:
            m = rx.search(line)
            if m:
                times.append(float(m.group(1)))
    if not times:
        raise ValueError(f"No ping RTTs parsed from {file}")
    return np.array(times)


# ---------------------------------------------------------------------------
# 2. Load data
# ---------------------------------------------------------------------------
bench = Path("benchmarks")
mp_baseline = load_mpstat(bench / "mpstat_baseline.txt")
mp_xdp      = load_mpstat(bench / "mpstat_xdp.txt")

rtt_baseline = load_ping_times(bench / "ping_flood_baseline.txt")
rtt_xdp      = load_ping_times(bench / "ping_flood_xdp.txt")

# ---------------------------------------------------------------------------
# 3. Figure 1 – stacked bar CPU utilisation
# ---------------------------------------------------------------------------
fig1, ax1 = plt.subplots(figsize=(6,4))

categories = ['%usr','%sys','%irq','%soft','%idle']
colors     = ['#4c72b0','#55a868','#c44e52','#8172b3','#bbbbbb']  # colour-blind OK

def stack_bar(values, x_off, label):
    bottom = 0
    for cat, c in zip(categories, colors):
        ax1.bar(x_off, values[cat], bottom=bottom, color=c, width=0.5)
        bottom += values[cat]
    ax1.text(x_off, 102, label, ha='center', va='bottom', fontsize=11)

stack_bar(mp_baseline, 0, "Baseline")
stack_bar(mp_xdp,      1, "XDP")

ax1.set_ylabel("CPU utilisation (%) over 15 s")
ax1.set_xticks([])
ax1.set_ylim(0, 105)
ax1.legend(categories, loc='upper right', frameon=False)
ax1.set_title("Figure 1 – CPU budget (mpstat)")

fig1.tight_layout()
fig1.savefig("fig_cpu_util.png", dpi=300)

# ---------------------------------------------------------------------------
# 4. Figure 2 – Latency CDF + split violins
# ---------------------------------------------------------------------------
fig2, (ax_cdf, ax_vio) = plt.subplots(1, 2, figsize=(10,4), gridspec_kw={'width_ratios':[3,1]})

# 4a. CDF
for data, lab, col in [(rtt_baseline,"Baseline",'grey'), (rtt_xdp,"XDP",'tab:blue')]:
    s = np.sort(data)
    pct = np.linspace(0,100,len(s))
    ax_cdf.plot(s, pct, label=lab, color=col)
ax_cdf.set_xscale('log')
ax_cdf.set_xlabel("RTT (ms, log scale)")
ax_cdf.set_ylabel("Empirical CDF (%)")
ax_cdf.grid(True, which='both', axis='x', ls=':')
ax_cdf.legend()
ax_cdf.set_title("Tail-latency CDF (flood-ping)")

# 4b. Split violins (half-width each side)
parts = ax_vio.violinplot([rtt_baseline, rtt_xdp], positions=[0.9, 1.1],
                          widths=0.8, showmeans=True, vert=True)
# Colour them
for pc, col in zip(parts['bodies'], ['grey','tab:blue']):
    pc.set_facecolor(col)
    pc.set_edgecolor('black')
    pc.set_alpha(0.7)
# Clean up axes
ax_vio.set_xticks([0.9,1.1], ['Baseline','XDP'])
ax_vio.set_ylabel("RTT (ms)")
ax_vio.set_title("Distribution snapshot")
ax_vio.grid(axis='y', ls=':')

fig2.tight_layout()
fig2.savefig("fig_latency.png", dpi=300)

print("✓ Wrote fig_cpu_util.png and fig_latency.png")
plt.show()
