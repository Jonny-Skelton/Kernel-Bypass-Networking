#!/usr/bin/env bash
set -euo pipefail

run_ping () {
  local label="$1"
  shift
  sudo ip netns exec cli perf stat -r 3 -e task-clock \
    ping -4 -c100 -i0.01 10.0.0.1 "$@" \
    | tee "benchmarks/${label}.txt"
}

run_iperf () {
  local label="$1"
  shift
  sudo ip netns exec cli perf stat -r 3 -e task-clock \
    iperf3 -u -l 64 -b 0 -t 15 -c 10.0.0.1 "$@" \
    | tee "benchmarks/${label}.txt"
}

record_ping_flood () {
  local label="$1"
  sudo ip netns exec cli \
    ping -i 0.001 -c 5000 -D 10.0.0.1 | tee "benchmarks/ping_flood_${label}.txt"
}


record_mpstat () {
  local label="$1"
  mpstat -P ALL 1 15 | tee "benchmarks/mpstat_${label}.txt" &
  echo $!
}

record_bcc () {
  local label="$1"
  if [[ -f /usr/share/bcc/tools/runqlat ]]; then
    sudo /usr/share/bcc/tools/runqlat 1 15 > "benchmarks/runqlat_${label}.txt" &
    RUNQLAT_PID=$!
  fi
  if [[ -f /usr/share/bcc/tools/softirqs ]]; then
    sudo /usr/share/bcc/tools/softirqs 1 15 > "benchmarks/softirq_${label}.txt" &
    SOFTIRQ_PID=$!
  fi
}

##### Baseline ###############################################################
Scripts/manage_xdp.sh clear-xdp

# record_bcc baseline
# MP_PID=$(record_mpstat baseline)
# run_ping  baseline_ipv4
#run_iperf baseline_iperf
record_ping_flood baseline
# kill $MP_PID 2>/dev/null || true
# kill $RUNQLAT_PID $SOFTIRQ_PID 2>/dev/null || true

##### XDP ####################################################################
Scripts/manage_xdp.sh clear-xdp
Scripts/manage_xdp.sh attach-pass
Scripts/manage_xdp.sh attach-echo

# record_bcc xdp
# MP_PID=$(record_mpstat xdp)
# run_ping  xdp_ipv4
# run_iperf xdp_iperf
record_ping_flood xdp
# kill $MP_PID 2>/dev/null || true
# kill $RUNQLAT_PID $SOFTIRQ_PID 2>/dev/null || true

