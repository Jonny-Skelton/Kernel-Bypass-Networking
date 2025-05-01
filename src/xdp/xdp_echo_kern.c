// SPDX-License-Identifier: GPL-2.0
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/if_ether.h>
#include <linux/in.h>
#include <linux/ip.h>
#include <linux/udp.h>

SEC("xdp")
int xdp_udp_echo(struct xdp_md *ctx)
{
    void *data_end = (void *)(long)ctx->data_end;
    void *data     = (void *)(long)ctx->data;

    // bounds-check L2+L3+L4
    if (data + sizeof(struct ethhdr) +
        sizeof(struct iphdr) +
        sizeof(struct udphdr) > data_end)
        return XDP_ABORTED;

    struct ethhdr *eth = data;
    struct iphdr  *ip  = data + sizeof(*eth);
    struct udphdr *udp = (void*)ip + sizeof(*ip);

    // only echo UDP
    if (ip->protocol != IPPROTO_UDP)
        return XDP_PASS;

    // swap MACs
    __u8 tmp[ETH_ALEN];
    __builtin_memcpy(tmp,        eth->h_dest,   ETH_ALEN);
    __builtin_memcpy(eth->h_dest,eth->h_source, ETH_ALEN);
    __builtin_memcpy(eth->h_source,tmp,        ETH_ALEN);

    // swap IPs & clear checksum
    __be32 sip = ip->saddr;
    ip->saddr   = ip->daddr;
    ip->daddr   = sip;
    ip->check   = 0;

    // swap UDP ports & clear checksum
    __be16 sp = udp->source;
    udp->source = udp->dest;
    udp->dest   = sp;
    udp->check  = 0;

    return XDP_TX;
}

char _license[] SEC("license") = "GPL";
