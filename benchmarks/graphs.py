import re
import pandas as pd, matplotlib.pyplot as plt, numpy as np, pathlib

# Parse Functions
def parse_ping(file):
    times = []
    for line in pathlib.Path(file).read_text().splitlines():
        if 'time=' in line:
            t = float(line.split('time=')[1].split()[0])    # ms
            times.append(t)
    return pd.Series(times, name=pathlib.Path(file).stem)

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


baseline = parse_ping('benchmarks/baseline_ipv4.txt')
xdp      = parse_ping('benchmarks/xdp_ipv4.txt')
mp_baseline = load_mpstat('benchmarks/baseline_mpstat.txt')
mp_xdp      = load_mpstat('benchmarks/xdp_mpstat.txt')
rtt_baseline = load_ping_times('benchmarks/baseline_ping_flood.txt')
rtt_xdp      = load_ping_times('benchmarks/xdp_ping_flood.txt')

df       = pd.concat([baseline, xdp], axis=1)

#Grouped bar
fig, ax = plt.subplots()
metrics = ['mean', 'median']
bar_w   = 0.35
x       = np.arange(len(metrics))

for i, col in enumerate(df):
    vals = [getattr(df[col], m)() for m in metrics]
    errs = df[col].std() if col == 'baseline_ipv4' else df[col].std()
    ax.bar(x + i*bar_w, vals, bar_w, label=col, yerr=errs, capsize=4)

ax.set_xticks(x + bar_w/2, metrics)
ax.set_ylabel('RTT (ms)')
ax.set_title('Central tendency with jitter')
ax.legend()

# Box 
fig2, ax2 = plt.subplots()
ax2.boxplot([baseline, xdp], labels=['Baseline', 'XDP'], showfliers=True)
ax2.set_ylabel('RTT (ms)')
ax2.set_title('Distribution of all 100 samples')

# CDF 
fig3, ax3 = plt.subplots()
for col, ser in df.items():
    sorted_t = np.sort(ser)
    cdf      = np.arange(1, len(ser)+1) / len(ser) * 100
    ax3.plot(sorted_t, cdf, label=col)

ax3.set_xscale('log')
ax3.set_xlabel('RTT (ms)')
ax3.set_ylabel('CDF (%)')
ax3.set_title('Tail-latency view (log scale)')
ax3.legend()

# stacked bar CPU utilisation
fig1, ax1 = plt.subplots(figsize=(6,4))

categories = ['%usr','%sys','%irq','%soft','%idle']
colors     = ['#4c72b0','#55a868','#c44e52','#8172b3','#bbbbbb'] 

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


#Latency CDF + split violins
fig4, (ax_cdf, ax_vio) = plt.subplots(1, 2, figsize=(10,4), gridspec_kw={'width_ratios':[3,1]})

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

parts = ax_vio.violinplot([rtt_baseline, rtt_xdp], positions=[0.9, 1.1],
                          widths=0.8, showmeans=True, vert=True)

for pc, col in zip(parts['bodies'], ['grey','tab:blue']):
    pc.set_facecolor(col)
    pc.set_edgecolor('black')
    pc.set_alpha(0.7)

ax_vio.set_xticks([0.9,1.1], ['Baseline','XDP'])
ax_vio.set_ylabel("RTT (ms)")
ax_vio.set_title("Distribution snapshot")
ax_vio.grid(axis='y', ls=':')

plt.tight_layout()
plt.show()

input('Press Enter to continue...')