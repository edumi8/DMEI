# Evidence Card: kannanDesigningLightweightNetwork2024

**Citation Key:** kannanDesigningLightweightNetwork2024

**Full Reference:** Kannan, P. G., Gupta, S. M., Behl, D., Raichstein, E., & Takvorian, J. (2024). Designing a Lightweight Network Observability agent for Cloud Applications. *IBM Research & Red Hat*.

---

## 1. Problem addressed

Network observability in cloud deployments (especially Kubernetes microservices) is critical for operators to diagnose problems, tune provisioning, and meet strict SLA requirements (latency, throughput, downtime). Existing host-based tools (libpcap-based pmacct, tcpdump) and OpenVSwitch-based solutions impose significant performance overhead (50-70% throughput degradation), drop packets under line-rate traffic, and consume excessive CPU/memory resources. The paper identifies that the choice of eBPF data structures (ring buffers, hash maps) in monitoring datapaths significantly impacts both observed traffic performance and agent overhead—a gap not systematically studied before.

---

## 2. Observability mechanism

The paper proposes **netobserv-ebpf-agent**, an eBPF-based network traffic monitoring tool that attaches to the **Traffic Control (TC)** hook-point of host-node interfaces. The agent uses **Per-CPU hash maps** to aggregate flow-level metrics (5-tuple flow-id, packet/byte counters, timestamps, TCP flags) directly in the eBPF datapath. Per-CPU architecture eliminates lock contention by maintaining separate hash buckets per CPU core. The agent exports aggregated flow records via gRPC/Kafka/IPFIX protocols. A secondary **Packet Capture Agent (PCA)** uses Per-CPU Perf buffers to selectively capture full packet payloads for deep inspection (e.g., DNS, protocol analysis) when enabled by filter configuration.

---

## 3. Privilege assumptions

Requires **CAP_BPF, CAP_NET_ADMIN, CAP_PERFMON** capabilities to attach eBPF programs to TC hook-points and access kernel network stack. Deployed as a **DaemonSet** in Kubernetes/OpenShift, running one privileged agent pod per cluster node. Host-level access is necessary to monitor all network interfaces on the node. Does not require modifications to container runtime or CNI plugins.

---

## 4. Application code modification

**Zero** application code changes required. The agent operates transparently at the kernel network layer, independent of application logic, programming languages, or container implementations. Works agnostically with any Container Network Interface (CNI) deployed by the orchestrator (e.g., OVN-Kubernetes, Calico, Cilium). Applications remain unaware of monitoring activity.

---

## 5. Telemetry signals

- **Flow-level metrics**: 5-tuple flow identifiers (source/destination IP, source/destination port, protocol), packet counts, byte counts
- **Timestamps**: Flow start time (monotonic), flow end time (last-seen timestamp)
- **Protocol details**: TCP flags (SYN, FIN, RST, etc.), Ethernet protocol type, transport protocol
- **Interface metadata**: Network interface index, direction (ingress/egress), source/destination MAC addresses
- **Kubernetes enrichment** (post-processing): Pod names, namespace, application labels, network topology relationships
- **Packet payloads** (optional PCA mode): Full packet capture for selective flows based on protocol/port filters

---

## 6. Collection pattern

**Hybrid kernel-userspace aggregation**:
1. **eBPF datapath** aggregates flow metrics in Per-CPU hash maps per packet arrival
2. **Userspace daemon** periodically evicts hash map entries based on configurable timeout (e.g., every 10s)
3. Evicted per-CPU entries are aggregated across CPU buckets in userspace to produce unified flow records
4. **Ring buffer fallback**: When hash map is full or busy (during eviction), flow records are sent directly via ring buffer to userspace
5. **Accounter** performs final aggregation of hash map and ring buffer flows
6. **Exporter** sends records to downstream collectors (flowlogs-pipeline for Kubernetes enrichment, Prometheus for metrics, Loki for storage, Grafana/OpenShift dashboard for visualization)
7. **PCA mode**: Packet payloads streamed via Per-CPU Perf buffers to PCAP consumers (Wireshark, Zeek) when collector connects

Eviction timing and hash map size are tunable parameters balancing memory usage and aggregation efficiency.

---

## 7. Evaluation performed

**Bare-metal benchmarks** (2x 80-core Xeon Gold servers, 40 Gbps Mellanox Connect-X5 NICs):
- Compared netobserv-ebpf-agent against tcpdump, pmacct, and netobserv-ebpf-agent-v0 (ring buffer-only version)
- Traffic scenarios: TCP short flows (100-byte packets, 128 flows via iperf3), UDP egress/ingress (75-byte packets, 40 flows via PcapPlusPlus)
- Measured throughput impact, monitoring rate (% of packets observed), CPU overhead, memory footprint

**eBPF map micro-benchmarks**:
- Evaluated ring buffer, hash map, Per-CPU hash map, array, Per-CPU array performance under single-flow and multi-flow UDP bursts
- Found ring buffer and shared hash maps severely degraded throughput due to lock contention; Per-CPU hash maps achieved near-native performance

**Production deployment**:
- Red Hat OpenShift on AWS m6i.4xlarge instances (16 vCPU, 64 GB, 12.5 Gbps)
- Workloads: Node-density-heavy (25 nodes), Cluster-density (120 nodes)
- Measured flows/minute, total CPU cores, total memory consumption

---

## 8. Overhead reported

**Throughput degradation**:
- netobserv-ebpf-agent: ~10% degradation (TCP 11.75 Mpps baseline → ~10.5 Mpps, UDP 4.7 Mpps → ~4.2 Mpps)
- tcpdump: 50-70% degradation
- pmacct: 50-70% degradation
- netobserv-ebpf-agent-v0 (ring buffer): 50-70% degradation

**Monitoring rate** (% of line-rate traffic observed):
- netobserv-ebpf-agent: 100% for all scenarios (TCP, UDP egress/ingress)
- tcpdump: 100% UDP egress (but high throughput cost), drops packets in other scenarios
- pmacct, netobserv-ebpf-agent-v0: significant packet drops due to userspace processing bottleneck

**Resource overhead** (bare-metal line-rate traffic):
- netobserv-ebpf-agent: 11.19% extra CPU (TCP), 0.08% (UDP egress), 20.17% (UDP ingress); 12 MB memory
- tcpdump: 51.48% CPU (TCP), 670.46% (UDP ingress); 27.4 MB memory
- pmacct: 234.23% CPU (TCP), 416.85% (UDP ingress); 89.2 MB memory
- netobserv-ebpf-agent-v0: 220.4% CPU (TCP), 233.24% (UDP ingress); 11 MB memory

**OpenShift production overhead** (m6i.4xlarge, 120-node cluster-density workload):
- Processes 1.92M flows/min
- Total cluster: 10.14 CPU cores, 11.13 GB memory
- Per-node overhead: 0.52% CPU, 0.14% memory (extrapolated from 120 nodes × 16 vCPU × 64 GB)

---

## 9. Constraints discussed by authors

- **Hash map memory limits**: Per-CPU hash maps can become full under extreme packet bursts; fallback to ring buffer incurs performance penalty. Userspace must trigger immediate eviction to minimize ring buffer usage.
- **Per-CPU memory residue**: Removed hash map entries do not zero memory; old flow data persists until overwritten. Mitigation: discard entries with last-seen timestamp before last eviction time during aggregation.
- **Hash collisions**: Handled by libbpf via chained key/value pairs per bucket, but adds lookup latency.
- **Packet Capture overhead**: Full payload capture via PCA is resource-intensive; disabled by default, enabled only with protocol/port filters for selective capture.
- **Kubernetes enrichment latency**: Flow records exported from eBPF contain only IP addresses/ports; enrichment with pod names/namespace requires downstream processing by flowlogs-pipeline, adding end-to-end latency.
- **CNI independence trade-off**: Attaching at TC hook-point provides CNI-agnostic monitoring but misses in-CNI processing details (e.g., OVS internal flow table decisions).
- **Eviction timing tuning**: Shorter eviction intervals reduce memory usage but increase userspace CPU consumption; longer intervals risk hash map exhaustion.

---

## 10. Fit or break under constrained CI/CD

**Strong fit** for constrained CI/CD environments:

- **Minimal overhead**: 10% throughput degradation, <1% CPU/memory in realistic deployments—negligible impact on build/test workloads
- **No application changes**: Zero instrumentation burden; no SDK integration, code recompilation, or container image modifications required
- **No elevated privileges for workloads**: Only the DaemonSet agent runs privileged; application containers remain unprivileged
- **CNI-agnostic deployment**: Works with any Kubernetes CNI (OVN-Kubernetes, Calico, Cilium) without configuration changes—critical for multi-tenant CI/CD clusters with heterogeneous networking
- **Tunable resource usage**: Hash map size and eviction intervals are configurable to balance observability fidelity vs. resource footprint
- **Selective deep inspection**: PCA mode enables targeted packet capture only when needed (e.g., debugging DNS resolution failures), avoiding always-on payload overhead

**Potential constraints**:

- **Root/privileged DaemonSet requirement**: Some CI/CD platforms with strict security policies may prohibit privileged pods or CAP_BPF/CAP_NET_ADMIN capabilities. Mitigation: deploy agent outside workload namespaces in dedicated observability node pool.
- **OpenShift/Kubernetes-specific enrichment**: Full contextual metadata (pod names, namespaces) requires integration with Kubernetes API and flowlogs-pipeline. Standalone CI/CD runners (bare-metal, VMs) get IP-level flows only unless custom enrichment is built.
- **Line-rate burst handling**: Under extreme packet bursts (>4.7 Mpps sustained), hash map exhaustion triggers ring buffer fallback, increasing CPU usage. CI/CD network traffic (container image pulls, artifact uploads) is typically bursty but intermittent, reducing risk.
- **eBPF kernel version dependency**: Requires Linux kernel 4.18+ with eBPF support. Legacy CI/CD infrastructure on older kernels (e.g., CentOS 7 with kernel 3.10) cannot use the agent without kernel upgrades.

**Recommendation**: netobserv-ebpf-agent is **highly suitable** for constrained CI/CD observability due to exceptional performance, zero application impact, and flexible deployment. Address privileged container policies via dedicated node pools and verify kernel version compatibility during planning.
