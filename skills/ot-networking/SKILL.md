---
name: ot-networking
description: Industrial OT networking covering deterministic traffic, industrial Ethernet, segmentation, reliability and operational constraints. Use for ICS/SCADA/plant-floor networks.
license: MIT
compatibility: opencode
metadata:
  domain: ot-networking
---

# OT Networking

## Primary principle

Safety and availability take precedence over convenience. Never recommend a change solely because it is technically valid. Consider operational impact, maintenance windows, redundancy, failover, vendor support, deterministic traffic, broadcast/multicast behaviour, control-system dependencies, recovery procedures.

## Investigation

Distinguish control, management, safety, voice, video, telemetry, multicast, broadcast traffic. Classify symptoms as physical, RF, L2, L3, application, control-plane, congestion, or timing-related.

## Evidence

Prefer packet captures and device counters over assumptions. For wireless: RSSI, SNR, MCS, NSS, bandwidth, retries, airtime, PHY rate, association state, retransmission, latency, loss. Do not treat RSSI alone as link quality.
