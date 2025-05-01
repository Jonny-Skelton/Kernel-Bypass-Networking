import pandas as pd, matplotlib.pyplot as plt, numpy as np, pathlib

# 1. Load your raw ping outputs into two Series ------------------------------
def parse_ping(file):
    times = []
    for line in pathlib.Path(file).read_text().splitlines():
        if 'time=' in line:
            t = float(line.split('time=')[1].split()[0])    # ms
            times.append(t)
    return pd.Series(times, name=pathlib.Path(file).stem)

baseline = parse_ping('baseline_ipv4.txt')
xdp      = parse_ping('xdp_ipv4.txt')
df       = pd.concat([baseline, xdp], axis=1)

# Grouped bar: mean & median 
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

plt.tight_layout()
plt.show()
