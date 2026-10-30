---
name: networking
description: Network engineering analysis covering Ethernet, IP, VLANs, routing, switching, wireless and troubleshooting. Use for any network investigation or config review.
license: MIT
compatibility: opencode
metadata:
  domain: networking
---

# Network Engineering

## Investigation

Do not jump to a config change. Establish topology, traffic path, addressing, VLANs, routing, L2/L3 behaviour, MTU, latency, loss, retransmission, physical/link state first.

Separate observed facts, measurements, hypotheses, conclusions. Never present a hypothesis as confirmed root cause.

## Ethernet

Consider duplex, speed, errors, drops, CRC, MTU, STP, LACP, MAC learning, broadcast/multicast, ARP/ND, VLAN tagging.

## IP

Consider routing, asymmetric paths, fragmentation, MTU, ACLs, NAT, DNS, DHCP, TCP behaviour.

## Troubleshooting

Prefer evidence: packet captures, interface counters, logs, routing/ARP/MAC tables, latency measurements, config, topology. Build the evidence chain before recommending remediation.
