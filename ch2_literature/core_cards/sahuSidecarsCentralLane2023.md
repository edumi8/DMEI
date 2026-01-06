# Evidence Card: Sidecars on the Central Lane: Impact of Network Proxies on Microservices

**Citation Key:** sahuSidecarsCentralLane2023  
**Authors:** Prateek Sahu, Lucy Zheng, Marco Bueso, Shijia Wei, Neeraja J. Yadwadkar, Mohit Tiwari  
**Year:** 2023  
**Venue:** HotInfra'23  
**Type:** Workshop Position Paper

---

## Research Focus

**Problem Addressed:**
- Lack of understanding of how sidecar proxies impact microservice performance and resource utilization
- Traditional metrics (latency, CPU, memory) insufficient to explain performance bottlenecks
- No comprehensive methodology exists to characterize sidecar performance across diverse policies
- Existing studies neglect the impact of complex and varied network policy configurations

**Key Argument:**
Sidecar proxies need deep study using **microarchitectural metrics** and **comprehensive methodologies** covering diverse policies with varying complexity.

---

## Technical Analysis

### Challenge 1: Inadequate Metrics
**Problem:** Traditional system-level metrics fail to highlight pipeline-level bottlenecks

**Evidence from Experiments:**
- **vCPU Allocation Test:** Allocating 2 virtual cores (threads) on same physical core provides **no performance increase** over single core
- **Root Cause:** Requires microarchitectural analysis (pipeline occupancy, logical unit contention)
- **Implication:** Cannot optimize resource allocation without understanding hardware-level interactions

**IP Tagging Policy Analysis:**
| Tags | Latency Overhead | Cycle Overhead | Instructions Overhead | L2 Cache Misses |
|------|------------------|----------------|-----------------------|------------------|
| 1 | 1.034× | 1.035× | 1.052× | Baseline |
| 5 | 1.039× | 1.054× | 1.088× | +2.1% |
| 10 | 1.048× | 1.108× | 1.147× | +10% |

**Key Finding:** Non-linear cycle overhead (1.8% for 5 tags, 7% for 10 tags) despite linear instruction increase due to L2 cache misses.

### Challenge 2: Policy Diversity Neglected
**Problem:** Performance studies focus on request sizes/rates but ignore policy complexity

**RBAC vs. IP Tag Comparison:**
| Policy | Latency Overhead | Cycle Overhead | Instructions Overhead |
|--------|------------------|----------------|-----------------------|
| IP Tag (1) | 1.034× | 1.035× | 1.052× |
| IP Tag (10) | 1.048× | 1.108× | 1.147× |
| RBAC (100 rules) | 1.029× | 1.123× | 1.014× |
| RBAC (10k rules) | 1.044× | 1.137× | 1.014× |

**Key Finding:** Similar latency but significantly different instruction footprints between policies.

---

## Background Context

### Service Mesh Sidecars
- **Purpose:** Apply security, networking, monitoring policies without modifying application logic
- **Architecture:** Co-located with each application container
- **Filter Chains:** Execute complex logic through configurable filters
- **Programmability:** Support for custom filters enhances configurability but increases complexity

### Reported Overheads
**Prior Research:**
- 30-185% latency increase
- 41-92% CPU usage overhead
- 2-6× latency from service mesh vendors
- 0-0.35 vCPU per 1000 requests

**Example Policies:**
- **mTLS:** Mutual authentication via traffic encryption
- **RBAC:** Application-layer role-based access control
- **Request Tagging:** Telemetry collection through header augmentation

---

## Experimental Setup

### Platform
- **Sidecar:** Envoy proxy
- **Policies Tested:**
  - RBAC (100 and 10k rules)
  - IP Tag (1, 5, 10 tags)

### Metrics Collected
- **Traditional:** P90 latency, throughput, CPU utilization
- **Microarchitectural:**
  - Cycle counts
  - Dynamic instruction counts
  - Pipeline occupancy (top-down analysis)
  - L2 cache miss rates
  - Logical unit contention

---

## Research Directions Proposed

### 1. Performance Prediction and Optimization
- Build automated tools using microarchitectural metrics
- Enable dynamic prediction of service mesh performance
- Improve hardware utilization while maintaining QoS
- Reduce need for manual profiling and tuning

### 2. Hardware Support for Service Meshes
- Design specialized hardware for sidecar acceleration
- Offload service mesh components to dedicated accelerators
- Reduce interference with application containers
- Enable more scalable microservice deployments

**Existing Trends:**
- Hardware vendors designing accelerators for cloud infrastructure (network, storage)
- Opportunity to extend to service mesh data plane

---

## Relevance to DMEI Research

### Direct Contributions
1. **Microarchitectural Analysis:** Demonstrates need for low-level metrics beyond latency/CPU
2. **Policy-Aware Characterization:** Shows performance varies significantly across policy types
3. **Resource Optimization:** Hardware-level understanding enables better resource allocation
4. **Sidecar Pattern Validation:** Confirms sidecar proxies as central observability/policy enforcement point

### Observability Implications
- **Monitoring Overhead:** Sidecars add measurable performance cost
- **Metric Selection:** Traditional metrics insufficient for optimization
- **Hardware Awareness:** Observability solutions must consider microarchitectural impacts
- **Policy Complexity:** Monitoring/security policies have non-obvious performance profiles

### Alignment with DMEI Objectives
- **Container-Level Monitoring:** Sidecars provide container-adjacent monitoring point
- **CI/CD Observability:** Need to understand sidecar overhead in build/test pipelines
- **Resource Efficiency:** Microarchitectural insights enable optimized monitoring infrastructure
- **Cross-Platform Considerations:** Hardware-specific behavior affects portability

### Limitations for DMEI Context
1. **Envoy-Specific:** Analysis focused on single sidecar implementation
2. **Policy Focus:** Emphasizes network policies over general observability
3. **Production Gap:** No evaluation on real CI/CD workloads
4. **Linux/x86 Only:** Microarchitectural metrics may differ on other platforms

---

## Key Insights for Observability Design

### Performance Characteristics
1. **Non-Linear Scaling:** Adding more policies doesn't scale linearly (cache effects)
2. **Hardware Dependencies:** Same configuration performs differently on different CPU topologies
3. **Filter Interactions:** Combined policies may have unexpected performance profiles
4. **Resource Contention:** vCPU allocation strategy significantly impacts throughput

### Design Implications
1. **Metric Granularity:** Need both system-level and microarchitectural metrics
2. **Policy-Aware Monitoring:** Observability overhead depends on active policies
3. **Hardware Profiling:** Must characterize performance on target platforms
4. **Dynamic Optimization:** Tools should adapt to policy complexity and hardware capabilities

---

## Comparison with Related Work

**Microservice Benchmarking:**
- Most studies focus on application-level metrics (request size, rate)
- Neglect infrastructure components like sidecars
- Missing microarchitectural analysis

**Service Mesh Vendor Studies:**
- Focus on single-policy scenarios
- Use traditional metrics only
- Lack comprehensive policy coverage

**"Datacenter Tax" (Kanev et al.):**
- Protocol management, RPC, data movement consume 20%+ CPU cycles
- Motivates deeper study of operational tasks (now consolidated in sidecars)

---

## Future Work Identified

### By Authors
1. Characterize wider range of policies and complexity levels
2. Develop predictive models for sidecar performance
3. Explore hardware acceleration opportunities
4. Build automated optimization tools

### For DMEI Research
1. Extend analysis to observability-specific sidecars (Prometheus, Jaeger agents)
2. Study sidecar performance in CI/CD environments (build containers, test runners)
3. Investigate alternative sidecar implementations (Linkerd, Cilium)
4. Analyze cross-platform microarchitectural differences (ARM, x86, Windows)

---

## Keywords
Microservices, Sidecars, Service Mesh, Performance Analysis, Microarchitecture, Envoy, Network Policies, Resource Utilization, Cache Behavior, Pipeline Contention

---

## Notes
- **Position Paper:** Identifies problems and proposes research directions (not full solution)
- **Unique Contribution:** First to argue for microarchitectural metrics in sidecar characterization
- **Practical Impact:** Explains previously unexplained performance anomalies (e.g., vCPU allocation)
- **Hardware Focus:** Bridges software (sidecars) and hardware (microarchitecture) research
- **Limited Scope:** Only 2 policies tested; needs broader evaluation for comprehensive methodology
