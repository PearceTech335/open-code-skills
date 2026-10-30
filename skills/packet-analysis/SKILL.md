---
name: packet-analysis
description: Packet capture analysis methodology — capture validity, protocol distribution, retries, PHY/MCS/QoS, airtime and root-cause correlation. Use for pcap/Wireshark tasks.
license: MIT
compatibility: opencode
metadata:
  domain: packet-analysis
---

# Packet Analysis

## Pipeline

Capture validity → protocol distribution → sources/destinations → retries → data/control/management split → PHY (MCS/NSS/BW/GI) → TID/QoS → BlockAck → airtime/congestion → temporal correlation → root-cause hypothesis.

## Correlation

Do not infer health from a single metric. A retry spike is not automatically RF — correlate retry rate, volume, MCS, SNR, RSSI, airtime, channel utilisation, latency, loss, peer changes.

Require every finding to state: Observed, Evidence, Hypothesis, Test, Finding, Remediation, Validation.
