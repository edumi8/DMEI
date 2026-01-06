# Evidence Card: karkanPerformanceOverheadOpenTelemetry

**Citation Key:** karkanPerformanceOverheadOpenTelemetry

**Full Reference:** Karkan, T. M. (2024). Performance Overhead Of OpenTelemetry Sampling Methods In A Cloud Infrastructure. *Master Thesis, Master Of Science Programme In Computing Science, Umeå University*.

---

## 1. Problem addressed

Distributed tracing generates substantial overhead in cloud environments (CPU, memory, network) as telemetry data must be generated, transmitted through collectors, and stored in backends. Sampling strategies (head-based, tail-based, mixed) are employed to reduce this overhead, but they introduce information loss and potential failure to detect rare errors or bottlenecks. The thesis investigates how different OpenTelemetry sampling strategies affect system overhead (CPU, memory, network) and error detection capabilities in Kubernetes clusters with varying service deployments (balanced vs. unbalanced node communication) and cluster sizes (2 vs. 4 nodes). Conducted with Nasdaq as stakeholder, the research addresses the need for high-performing monitoring tools in systems handling millions of daily transactions with strict latency SLAs.

---

## 2. Observability mechanism

**OpenTelemetry distributed tracing** using auto-instrumentation injected into pods via the Kubernetes Operator (zero-code solution). Telemetry follows a multi-tier collector architecture:
1. **Daemonset collectors** (one per node): Receive spans from services via HTTP/OTLP, perform head-based sampling (5% for head-only strategy, 20% for mixed strategy)
2. **Loadbalancer**: Routes spans to collectors using trace ID hashing to ensure all spans of a trace reach the same collector (stateful requirement)
3. **Sampling collectors** (2 per cluster): Perform tail-based sampling with 10-second decision wait, sampling traces with HTTP status code ≥400
4. **Jaeger backend**: Stores sampled traces

**Sampling strategies compared**:
- **Head-based**: 5% probabilistic sampling at daemonset level using hashed trace ID
- **Tail-based**: Collects all spans, samples only errors (status code ≥400) after 10-second wait
- **Mixed**: 20% head-based sampling at daemonset + tail-based error sampling at collector level

**Test application**: Emulated Nasdaq clearing house system with 14-service call chain generating 111 spans per user request (56 messages × 2 spans per message - 1 user response).

---

## 3. Privilege assumptions

**Zero-code auto-instrumentation** via Kubernetes Operator requires:
- **Cluster-admin level access** to deploy Operator (manages collector and auto-instrumentation injection)
- **Pod annotation privileges** to enable auto-instrumentation injection into target pods
- **Node-level DaemonSet deployment** for daemonset collectors (runs privileged to access all pod traffic on node)
- **eBPF, bytecode manipulation, or monkey patching** depending on language (Python uses monkey patching, Java uses bytecode manipulation, C/C++ may use eBPF for call injection)

No elevated privileges required for application containers themselves—instrumentation is injected as sidecar or init container during pod creation.

---

## 4. Application code modification

**Zero application code changes** required. The thesis explicitly uses OpenTelemetry's **zero-code auto-instrumentation** approach via Kubernetes Operator. Instrumentation is injected at runtime through:
- Kubernetes Operator detecting annotated pods
- Auto-instrumentation injected as agent to program
- Context propagation enabled automatically between services
- Spans emitted to collectors without manual SDK integration

Alternative code-based approach mentioned (requires importing OpenTelemetry libraries and manual span creation) but **not used** in this research. All 14 services in the call chain application traced without modifying application codebase.

---

## 5. Telemetry signals

- **Distributed traces**: Trace ID (global identifier), span ID (per-request identifier), parent span ID (causal relationships)
- **Span timing**: Start timestamp, span duration
- **Span metadata**: Operation name, HTTP status codes (used for tail sampling decisions)
- **Arbitrary key-value pairs**: Custom attributes attachable to spans
- **Error indicators**: HTTP status codes ≥400 flagged for tail sampling
- **Network topology**: Service-to-service communication patterns (56 messages per trace across 14 services)

Metrics collected separately via Prometheus for overhead measurement (CPU work-seconds, memory allocation, network received bytes)—**not part of OpenTelemetry telemetry stream**.

---

## 6. Collection pattern

**Multi-tier pipelined architecture**:
1. **Span generation**: Auto-instrumented services emit spans via HTTP/OTLP when sending/receiving requests
2. **Daemonset collector** (per-node): Receives spans, applies head-based sampling (if configured), exports to loadbalancer via gRPC/OTLP
3. **Loadbalancer collector**: Stateless routing—hashes trace ID to deterministically route spans to same sampling collector
4. **Sampling collectors** (2 per cluster): Stateful tail-based sampling—buffers spans for 10-second decision wait, applies policies (error detection), exports to Jaeger via gRPC/OTLP
5. **Jaeger backend**: Stores sampled traces for query/visualization

**Sampling decision timing**:
- **Head-based**: Immediate decision at daemonset level using trace ID hash + sampling percentage (5% or 20%)
- **Tail-based**: Deferred decision after 10-second buffer window, evaluates complete trace attributes (status codes)
- **Mixed**: Early 20% probabilistic filter at daemonset + deferred error-only sampling at collector

**Scalability pattern**: Horizontal scaling of sampling collectors requires loadbalancer awareness of collector count for consistent trace ID hashing.

---

## 7. Evaluation performed

**Testbed**: Kubernetes clusters (2-node and 4-node) on VMs (4 GB memory, 2 CPU cores, 3.3 GHz per node). Control plane on Node 1.

**Workload**: Emulated Nasdaq clearing house call chain (14 services, 111 spans per request). User sends request to API gateway → cascades through services (Key-Cloak receives 18 requests per user request).

**Deployment scenarios**:
- **Balanced**: Services co-located on same nodes to minimize inter-node communication
- **Unbalanced**: Services distributed across nodes to maximize inter-node communication

**Sampling strategies tested**: Head-based (5%), tail-based (error-only with 10s wait), mixed (20% head + error-only tail)

**Metrics measured**:
- **CPU overhead**: CPU work-seconds (idle time excluded) via Prometheus, 5-second scrape interval
- **Memory overhead**: Total allocated memory for collectors + Jaeger summed over run duration
- **Network overhead**: Total received bytes per node
- **Error detection rate**: % of injected synthetic error traces (status code ≥400) captured by Jaeger
- **Total run time**: End-to-end time for all requests to complete
- **Trace storage size**: Total memory footprint of traces in Jaeger

**Experimental design**: 7 runs per configuration, results presented as box plots.

---

## 8. Overhead reported

### Two-Node Setup (Balanced):
- **CPU overhead** (work-seconds per run):
  - Tail-based: ~800s (highest)
  - Mixed: ~600s
  - Head-based: ~400s (lowest)
- **Memory overhead** (total GB over run):
  - Tail-based: ~80 GB
  - Mixed: ~60 GB
  - Head-based: ~40 GB (lowest)
- **Network overhead**: Tail-based highest, mixed intermediate, head-based lowest (specific values not provided in text excerpt)
- **Error detection rate**: Tail-based 100%, mixed >95%, head-based <10%

### Four-Node Setup (Balanced):
- **CPU overhead**:
  - Tail-based: ~1200s (highest)
  - Mixed: ~800s
  - Head-based: ~600s (lowest, except on Jaeger node where head-based showed +12.75% overhead vs. mixed due to higher sampling rate increasing Jaeger load)
- **Memory overhead**: Similar pattern to two-node (tail > mixed > head), but absolute values higher
- **Network overhead**: Tail-based 5.6% higher than head-based (average)
- **Error detection rate**: Tail-based 100%, mixed captures more errors than head-based

### Comparative Overhead (Tail vs. Head):
- **Average overhead of tail-based vs. head-based**: +71.33% CPU, +23.7% memory, +5.6% network

### Deployment Impact:
- **Unbalanced deployments** (more inter-node communication): Highest overhead observed when more requests sent between nodes, exacerbating network and latency costs
- **Throughput degradation**: Not quantified but implied by increased run times for unbalanced vs. balanced deployments

### Key Trade-off:
Tail-based sampling captures **all errors** (100% detection) but imposes **~70% higher CPU, ~24% higher memory, ~6% higher network overhead** compared to head-based. Mixed sampling captures **most errors** (>95%) with **intermediate overhead** (~50% lower CPU than tail-based, ~50% higher than head-based).

---

## 9. Constraints discussed by authors

- **Computational resource limits**: Experiments limited by available CPU cores, speed, and memory—**not representative of high-load enterprise systems** processing millions of transactions. Smaller application (14 services) may not reflect overhead scaling for large-scale microservice architectures with hundreds of services.
- **Tail-based sampling decision wait time**: 10-second buffer risks **incomplete traces** if asynchronous requests exceed timeout. Increasing decision wait raises memory consumption as more spans buffered. Requires deep system behavior understanding to tune optimally.
- **Stateful collector requirement**: Tail-based sampling mandates **loadbalancer with trace ID hashing** to route all spans of a trace to same collector. Horizontal scaling complexity increases—loadbalancer must know collector count in advance, complicating dynamic scaling.
- **Sampling policy maintenance**: Tail-based policies (error codes, latency thresholds, service-specific rules) require **constant updates** as services are added/removed or SLAs change. Increases operational overhead.
- **Information loss vs. overhead trade-off**: Head-based sampling (5%) misses **>90% of errors** including rare critical failures. Tail-based captures all errors but **cannot be deployed early in pipeline** (must wait for complete trace), preventing early overhead reduction.
- **Jaeger backend load**: Head-based sampling (5%) with high request rates still generates significant backend load. In 4-node setup, head-based caused **+12.75% CPU overhead on Jaeger node** compared to mixed sampling due to higher total sampling rate.
- **Inter-node communication amplification**: Unbalanced deployments showed **highest time impact** when more requests traverse nodes. Network latency and packet loss multiply overhead in distributed environments—not quantified in single-datacenter VM setup.
- **Network traffic overhead**: Tail-based sampling sends **all spans** to collectors before filtering (unlike head-based dropping spans early), causing **5.6% average increase in network traffic**. In bandwidth-constrained environments (edge computing, multi-region clouds), this may be prohibitive.
- **Mixed sampling tuning challenge**: Selecting optimal head-based percentage (20% in thesis) and tail-based policies requires **iterative experimentation**. No guidance provided for generalizing to other workloads.

---

## 10. Fit or break under constrained CI/CD

**Strong fit with significant constraints**:

### Positive Fit Factors:
- **Zero application code changes**: OpenTelemetry auto-instrumentation aligns with CI/CD requirement for instrumentation-free deployments. No SDK integration, recompilation, or code review cycles needed.
- **Kubernetes-native deployment**: DaemonSet collectors, Operator-based auto-injection, and OTLP-over-HTTP integrate seamlessly with Kubernetes CI/CD pipelines (Helm charts, Operators, GitOps workflows).
- **Tunable overhead**: Head-based sampling (5%) provides **~60-70% lower CPU, ~24% lower memory overhead** than tail-based—acceptable for resource-constrained CI/CD nodes. Mixed sampling (20% head + error-only tail) offers **intermediate overhead with >95% error detection**, balancing resource constraints and observability needs.

### Breaking Constraints:

1. **Privileged DaemonSet requirement**: CI/CD platforms with strict security policies (e.g., Pod Security Standards "Restricted" mode, no eBPF/bytecode manipulation) may **prohibit privileged collectors or auto-instrumentation**. Mitigation: Deploy collectors in separate privileged node pools outside CI/CD workload namespaces.

2. **Tail-based sampling memory explosion**: 10-second decision wait buffers **all spans** (111 spans per trace × thousands of concurrent CI/CD jobs). In ephemeral CI/CD workloads (build/test pipelines completing in <10s), tail-based collectors may **accumulate spans from completed jobs**, wasting memory. **Unacceptable for constrained CI/CD** unless decision wait reduced to <5s and collector memory limits enforced.

3. **Stateful collector horizontal scaling complexity**: Tail-based sampling requires **loadbalancer with pre-configured collector count**. Autoscaling collectors (e.g., HPA based on CPU) **breaks trace completeness** unless loadbalancer dynamically updates routing—not supported in current architecture. CI/CD platforms with bursty workloads (peak scaling during merge queues) cannot efficiently scale tail-based collectors.

4. **Jaeger backend storage overhead**: Thesis showed tail-based sampling stores **2x more trace data** than mixed sampling. CI/CD environments processing thousands of ephemeral jobs (each generating 111 spans) would require **persistent storage provisioning** (Loki, S3, Cassandra)—adding cost and complexity. Head-based sampling (5%) generates **20x less data** but misses >90% of errors, **breaking failure detection requirements** in CI/CD.

5. **Network overhead in multi-node CI/CD**: Unbalanced deployments (services distributed across nodes) showed **highest time impact**. CI/CD pipelines often distribute jobs across nodes for parallelism—tail-based sampling's **+5.6% network overhead** compounds with inter-node job communication, potentially violating CI/CD latency SLAs (<10s per build step).

6. **Error detection trade-off**: Head-based sampling (5%) misses **>90% of errors**, unacceptable for CI/CD where **every test failure/build error must be detected**. Tail-based sampling captures 100% of errors but imposes **~70% higher CPU overhead**—may exceed CI/CD node resource quotas. Mixed sampling (>95% error detection, ~50% overhead) is **acceptable compromise** but requires tuning head-based percentage per workload.

7. **OpenTelemetry version churn**: OpenTelemetry is "in constant change" (thesis quote). CI/CD pipelines require stable observability tooling—frequent Operator/collector upgrades risk breaking auto-instrumentation compatibility with application runtime versions (Java bytecode manipulation, Python monkey patching). **Operational burden** for CI/CD platform teams.

### Recommendation:

**Mixed sampling (20% head + error-only tail)** is **optimal for constrained CI/CD** if:
- Privileged collectors deployed in separate node pools
- Tail-based decision wait reduced to <5s for ephemeral workloads
- Loadbalancer supports dynamic collector scaling (custom implementation required)
- Jaeger backend uses time-based retention (e.g., 7 days) to limit storage growth
- Error detection threshold (status code ≥400) tuned to include test failures (exit code ≠0)

**Avoid tail-based sampling** in CI/CD with:
- Strict no-privileged-container policies
- Ephemeral workloads completing in <10s (decision wait mismatch)
- Bandwidth-constrained inter-node networking
- Autoscaling requirements for collectors

**Use head-based sampling (5%)** only if error detection is handled by **separate CI/CD-native observability** (e.g., test result exporters, build logs) and distributed tracing is for **profiling/optimization only**, not failure detection.
