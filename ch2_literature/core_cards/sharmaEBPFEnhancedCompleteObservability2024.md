# sharmaEBPFEnhancedCompleteObservability2024

## Problem addressed
Achieving complete observability for cloud-native microservices without the overhead and complexity of instrumenting applications across multiple languages and platforms. Traditional observability requires language-restricted libraries and cannot monitor uninstrumented or hidden processes in multi-tenant cloud environments.

## Observability mechanism
- eBPF programs running in kernel space, triggered by system calls
- Three-layer approach: microservices layer (OTel for distributed trace context), container network layer (eBPF agents for RED metrics), infrastructure layer (eBPF agents for detailed host telemetry)
- eBPF agents deployed as DaemonSet on all cluster nodes
- Automatic extraction of trace IDs from network packet headers using Deepflow library
- Block I/O latency measurement and histogram generation via eBPF maps

## Privilege assumptions
Host kernel eBPF (requires Linux kernel v5.15 or newer; eBPF programs run in kernel space with kernel-level privileges)

## Application code modification
No for kernel-level metrics; Yes (optional) for application-level distributed trace context propagation using OTel libraries in application headers

## Telemetry signals
- Metrics: Over 2000 kernel-level metrics and tracepoints including container-aware resource utilization, block I/O latency histograms, network throughput, latency, error codes (RED metrics)
- Traces: Distributed traces extracted from X-Request-ID headers in network packets, full span creation by mapping trace IDs
- Logs: Mentioned as part of complete observability but implementation details not provided

## Collection pattern
Host-based eBPF agent (DaemonSet on worker nodes); eBPF programs write to kernel-space eBPF maps; Prometheus collector scrapes agents at 1-second intervals; eliminates sidecar proxies for distributed tracing

## Evaluation performed
- Setup: 3-node Kubernetes cluster (1 master, 2 workers) on Chameleon Cloud bare-metal; Intel Xeon E5-2670 v3 (48 threads, 128GB RAM, InfiniBand networking); 14-microservice e-commerce application (10 unique services) in multiple languages
- Load: Up to 1000 concurrent users at 20 users/second spawn rate using Locust
- Scale: Multi-node cluster with distributed microservices
- Metrics: CPU usage (%), memory usage (MB), I/O performance (Fio tests), distributed trace latency

## Overhead reported
- CPU: 21x to 214x fewer CPU resources than alternatives (OTel, Envoy, cAdvisor, Node Exporter consume 218%, 110%, 140%, 75% respectively; eBPF solution uses 2.8%)
- Memory: 30.95% to 159.5% less memory than alternatives (Node Exporter uses 84MB, eBPF solution uses ~12% more at 5.3MB)
- Latency: Eliminates ~250µs blocking POST request per proxy traversal in traditional distributed tracing (cumulative across N hops)
- Bare metal workload testing shows minimal overhead compared to baseline (no observability)

## Constraints discussed by authors
- Requires Linux kernel v5.15 or newer
- eBPF solution provides comprehensive kernel-level metrics but cannot expose custom organization-specific application telemetry without OTel instrumentation
- For full application-layer observability, two-step approach needed: OTel SDK for custom metrics plus eBPF agent for collection
- Sidecars eliminated for distributed tracing but still useful for container health checks and lifecycle events (not provided by eBPF solution)

## Fit or break under constrained CI/CD
- Fits: Drastically reduced resource overhead (21-214x less CPU, 30-159% less memory) makes it highly suitable for resource-constrained CI/CD pipelines
- Fits: No application code modification required for kernel-level observability; eliminates need to instrument containers in CI builds
- Fits: Eliminates sidecar containers that consume valuable cluster resources (computing, storage, networking), reducing per-pod overhead
- Breaks: Requires host kernel access and eBPF support (kernel v5.15+), which may not be available in containerized CI/CD environments with restricted privileges or older kernels
