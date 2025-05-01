#!/usr/bin/env bash

manage_xdp.sh: common tasks for XDP echo project

Usage: manage_xdp.sh  [args]

Commands:

setup-netns            - create namespaces srv, cli and veth pair

clear-xdp              - detach any XDP programs from veth0 and veth1

attach-pass           - attach basic XDP_PASS on cli:veth1

attach-echo           - attach UDP echo XDP on srv:veth0

show-progs            - list attached XDP programs on both ends

Configurable paths

echo_prog_obj="$(pwd)/xdp_udp_echo.o"
pass_prog_obj="$HOME/xdp-tutorial/basic01-xdp-pass/xdp_pass_kern.o"

Netns names

NS_SRV=srv
NS_CLI=cli
VETH0=veth0
VETH1=veth1

function setup_netns() {
sudo ip netns add $NS_SRV || true
sudo ip netns add $NS_CLI || true
sudo ip link add $VETH0 type veth peer name $VETH1 || true
sudo ip link set $VETH0 netns $NS_SRV
sudo ip link set $VETH1 netns $NS_CLI
sudo ip netns exec $NS_SRV ip link set lo up
sudo ip netns exec $NS_CLI ip link set lo up
sudo ip netns exec $NS_SRV ip addr add 10.0.0.1/24 dev $VETH0
sudo ip netns exec $NS_SRV ip link set $VETH0 up
sudo ip netns exec $NS_CLI ip addr add 10.0.0.2/24 dev $VETH1
sudo ip netns exec $NS_CLI ip link set $VETH1 up
echo "Network namespaces and veth setup complete."
}

function clear_xdp() {
sudo ip netns exec $NS_SRV ip link set dev $VETH0 xdp off || true
sudo ip netns exec $NS_CLI ip link set dev $VETH1 xdp off || true
echo "Cleared XDP programs on $NS_SRV:$VETH0 and $NS_CLI:$VETH1."
}

function attach_pass() {
sudo ip netns exec $NS_CLI ip link set dev $VETH1 xdp object $pass_prog_obj sec xdp
echo "Attached XDP_PASS on $NS_CLI:$VETH1."
}

function attach_echo() {
sudo ip netns exec $NS_SRV ip link set dev $VETH0 xdp object $echo_prog_obj sec xdp
echo "Attached UDP echo XDP on $NS_SRV:$VETH0."
}

function show_progs() {
echo "--- srv namespace ---"
sudo ip netns exec $NS_SRV bpftool net list
echo "--- cli namespace ---"
sudo ip netns exec $NS_CLI bpftool net list
}

case "$1" in
setup-netns) setup_netns ;;clear-xdp)  clear_xdp  ;;attach-pass) attach_pass ;;attach-echo) attach_echo ;;show-progs) show_progs ;;*) echo "Usage: $0 {setup-netns|clear-xdp|attach-pass|attach-echo|show-progs}"; exit 1 ;;
esac

