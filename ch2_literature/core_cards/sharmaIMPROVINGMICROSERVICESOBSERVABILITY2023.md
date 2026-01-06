# sharmaIMPROVINGMICROSERVICESOBSERVABILITY2023

## Problem addressed
Managing complexity of consistently instrumenting multiple microservices across application platforms and programming languages for observability in cloud-native deployments. Traditional agent-based approaches (OpenTelemetry, cAdvisor, Node Exporter) deployed in user space incur additional resource overheads that impact deployed workload performance.

## Observability mechanism
- eBPF-based solution with small event-triggered programs extending OS functionality in kernel space
- Multi-layered design: application layer (OTel libraries for distributed trace context), network layer (eBPF agents for network observability), node layer (eBPF agents for host metrics)
- eBPF programs write to eBPF maps in kernel space accessible from user space
- Custom eBPF scripts including accept-latency, cachestat, llcstat, malloc, oomkill, runqlat, shrinklat, tcpbacklog
- Prometheus collector for data storage, Grafana for visualization

## Privilege assumptions
Host kernel eBPF (eBPF programs run in kernel space; requires kernel v5.15 or newer based on related paper)

## Application code modification
Yes (optional) for application-layer observability: OTel language SDK to generate metrics, logs, and traces; eBPF agent then collects this data using port ID or process ID as key

## Telemetry signals
- Metrics: Container-aware host-level metrics from /proc virtual filesystem, resource utilization per container, block I/O latency histograms, network traffic, over 2000 kernel metrics/tracepoints
- Traces: Distributed traces from X-Request-ID headers extracted from network packets in kernel space, full span creation
- Logs: Log aggregation and analysis mentioned as part of three-pillar observability

## Collection pattern
Host-based eBPF agent (DaemonSet on cluster nodes); eBPF programs in kernel space write to eBPF maps; Prometheus scrapes agents at 1-second intervals; eliminates sidecar proxies by using kernel-level packet parsing

## Evaluation performed
- Setup: 3-node Kubernetes cluster (1 master, 2 workers) on Chameleon Cloud bare-metal; Intel Xeon E5-2670 v3 (48 threads, 128GB RAM, InfiniBand networking); 10-microservice e-commerce application (OpenTelemetry demo) with multiple languages (TypeScript, Go, Javascript, C++, C#)
- Load: Up to 1000 concurrent users at 20 users/second spawn rate using Locust; synthetic load generation and stress tests
- Scale: Multi-node bare-metal cluster with distributed services
- Metrics: CPU (%), RAM usage, I/O performance (Fio), network performance, comparison with Node Exporter, cAdvisor, OpenTelemetry Collector, Envoy proxy

## Overhead reported
- CPU: eBPF solution <1% of Node Exporter overhead; 21x to 210x fewer CPU resources than alternatives
- Memory: eBPF solution requires up to 159% less memory than alternatives; ~12% more than most memory-optimized tool (Node Exporter)
- No information loss due to sampling intervals (eBPF captures all events directly from kernel)
- Workload testing shows eBPF adds minimal overhead to bare-metal baseline, while cAdvisor had highest overheads

## Constraints discussed by authors
- Requires Linux kernel v5.15 or newer for eBPF support
- eBPF solution dynamically injected without recompilation/redeployment
- Containers run as root user by default in Docker; if compromised, can cause severe damage
- Kubernetes configuration drift possible (desired state may not match current state)
- Sampling interval in traditional tools (Node Exporter, cAdvisor) causes information loss; eBPF avoids this by capturing all kernel events

## Fit or break under constrained CI/CD
- Fits: Extremely low overhead (<1% of Node Exporter, 21-210x less CPU) makes it ideal for resource-constrained CI/CD pipelines
- Fits: Dynamic injection without recompilation/redeployment allows observability in CI without modifying build artifacts or container images
- Fits: No sampling-related information loss; captures all events for accurate debugging in ephemeral CI/CD container lifecycles
- Breaks: Requires host kernel access with eBPF support (v5.15+); constrained CI/CD environments may have restricted kernel access or older kernel versions incompatible with eBPF
