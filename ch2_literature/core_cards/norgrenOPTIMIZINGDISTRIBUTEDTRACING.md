# norgrenOPTIMIZINGDISTRIBUTEDTRACING

## Problem addressed
Determining optimal collector deployment strategy for OpenTelemetry in Kubernetes clusters. Comparing performance overhead of daemonset (one collector per node) versus sidecar (one collector per pod) deployments.

## Observability mechanism
- OpenTelemetry automatic instrumentation via Kubernetes operator
- W3C TraceContext propagation (40 bytes per HTTP header: version, trace ID, parent ID, trace flags)
- Collector pipeline: receiver → processor (e.g., sampling) → exporter
- Supports multiple protocols (OTLP, Jaeger, Prometheus)

## Privilege assumptions
None (uses standard Kubernetes pod deployment and init container injection via OpenTelemetry operator)

## Application code modification
No – automatic instrumentation via OpenTelemetry operator injects init container into annotated pods; no code changes required

## Telemetry signals
Traces (spans with trace context) exported to collector, then to back-end (e.g., Zipkin, Jaeger)

## Collection pattern
Two patterns tested: (1) Daemonset – one collector per node, services on that node push spans; (2) Sidecar – one collector per pod, co-located with service

## Evaluation performed
- Kubernetes (K3s) cluster on CloudGuru: 2-node (2×8GB RAM, 2 cores each) and 4-node (1×4GB + 3×2GB) setups
- Emulated Nasdaq clearing house system: 13 microservices in directed acyclic graph, deterministic call patterns
- Load generator simulating production workload; metrics collected via Prometheus
- Tests: 4 scenarios (2/4 nodes × balanced/unbalanced service placement)

## Overhead reported
**Daemonset vs. no OpenTelemetry:**
- CPU usage: +46.5% on average
- Network usage: +18.25% on average
- Memory usage: +47.5% on average

**Sidecar vs. daemonset:**
- Sidecar performed worse in most cases, especially in RAM and CPU usage (specific numbers not provided in excerpt)

## Constraints discussed by authors
- Cloud provider (CloudGuru) resource limits: max 4 nodes, limited CPU/RAM per node
- Lack of control over VM placement and potential interference from other VMs
- W3C TraceContext adds 40 bytes to HTTP header per call
- Sampling used to reduce telemetry volume but still incurs collection overhead
- OpenTelemetry adds overhead in all tested cases

## Fit or break under constrained CI/CD
- **Breaks**: 46.5% CPU and 47.5% memory overhead for daemonset exceeds typical CI/CD resource budgets
- **Breaks**: Sidecar even worse than daemonset in CPU/RAM, making it non-viable in resource-constrained CI/CD
- **Fits**: No code modification required (automatic instrumentation) aligns with CI/CD zero-intrusion requirement
- **Partial fit**: Daemonset pattern (one collector per node) could work if CI/CD runner has dedicated nodes, but overhead remains prohibitive
