// SPDX-License-Identifier: GPL-2.0
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>

#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/icmp.h>
#include <linux/in.h>

static __always_inline void swap_src_dst_mac(struct ethhdr *eth) {
    __u8 tmp[ETH_ALEN];
    __builtin_memcpy(tmp,        eth->h_dest,   ETH_ALEN);
    __builtin_memcpy(eth->h_dest,eth->h_source, ETH_ALEN);
    __builtin_memcpy(eth->h_source, tmp,        ETH_ALEN);
}

static __always_inline void swap_src_dst_ipv4(struct iphdr *ip) {
    __be32 t = ip->saddr;
    ip->saddr = ip->daddr;
    ip->daddr = t;
}

SEC("xdp")
int xdp_icmp_echo(struct xdp_md *ctx)
{
    void *data_end = (void *)(long)ctx->data_end;
    void *data     = (void *)(long)ctx->data;
    struct ethhdr  *eth;
    struct iphdr   *ip;
    struct icmphdr *icmp;

    /* 1) check full headers fit */
    if (data + sizeof(*eth) + sizeof(*ip) + sizeof(*icmp) > data_end)
        return XDP_PASS;

    /* 2) parse Ethernet */
    eth = data;
    if (eth->h_proto != bpf_htons(ETH_P_IP))
        return XDP_PASS;

    /* 3) parse IPv4 */
    ip = data + sizeof(*eth);
    if (ip->protocol != IPPROTO_ICMP)
        return XDP_PASS;

    /* 4) parse ICMP */
    icmp = (void*)ip + (ip->ihl * 4);
    if ((void*)icmp + sizeof(*icmp) > data_end)
        return XDP_PASS;
    if (icmp->type != ICMP_ECHO)
        return XDP_PASS;

    /* 5) swap MACs */
    swap_src_dst_mac(eth);

    /* 6) swap IPs & clear IP checksum */
    swap_src_dst_ipv4(ip);
    ip->check = 0;

    /* 7) change ICMP type to ECHOREPLY & fix checksum */
    {
        __u8  old = ICMP_ECHO;
        __u8  nw  = ICMP_ECHOREPLY;
        __u16 old16 = bpf_htons((__u16)old << 8 | icmp->code);
        __u16 new16 = bpf_htons((__u16)nw  << 8 | icmp->code);
        icmp->type  = nw;
        __u32 csum = bpf_csum_diff(&old16, sizeof(old16),
                                   &new16, sizeof(new16),
                                   (__u32)icmp->checksum);
        icmp->checksum = (__u16)csum;
    }

    /* 8) send it back out the same interface */
    return XDP_TX;
}

char _license[] SEC("license") = "GPL";
