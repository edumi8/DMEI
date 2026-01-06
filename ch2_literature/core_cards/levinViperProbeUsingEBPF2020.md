# levinViperProbeUsingEBPF2020

## Problem addressed
Microservice observability requires diverse and adaptive metrics, but modern collection frameworks are static and rigid. The extreme heterogeneity and scale of microservices make collecting all metrics untenable.

## Observability mechanism
- eBPF-based dynamic metrics collection at the container level
- Metrics include: cputime, runq latency, memory cache ratio, page faults, TLB flushes, disk I/O, network bytes/retransmissions, DNS latency
- Offline analysis of microservice design patterns (sidecar, gateway, operator) to determine CriticalMetrics
- k-Shape clustering to identify relevant metric subsets per service

## Privilege assumptions
Host root / kernel eBPF (requires eBPF support, kprobes/uprobes attachment at system level)

## Application code modification
No – zero intrusion to application code; instrumentation limited to underlying middleware and eBPF programs at kernel level

## Telemetry signals
Metrics (deep kernel-level performance counters) at container granularity

## Collection pattern
Host-based eBPF probes per node; per-container filtering via PID namespace; push to Kafka via gRPC; stored in Postgres and visualized via Grafana

## Evaluation performed
- Tested on Amazon EC2: 1 master (8 vCPU, 16GB), 5 nodes (8 vCPU, 16GB each)
- Workload: Google Hipster Shop with 1800 simulated users via Locust
- Metrics: CPU usage, latency (percentiles), sampling overhead

## Overhead reported
- CPU: 10–15% when running all metrics; 3–5% baseline overhead from Python implementation
- Latency: 40–60% at 50th percentile; negligible at higher percentiles
- Sampling had minimal effect on reducing overhead due to eBPF invocation costs in high-frequency paths

## Constraints discussed by authors
- eBPF kprobes always invoked when attached (trap inserted into kernel bytecode), causing overhead even with sampling
- High-frequency paths (tcp_send, sched_switch) expensive to probe
- Container-centric design requires config map lookups per invocation (additional overhead)
- eBPF constraints: fixed stack size, no loops, no floating point, verifiable programs only
- Python-based prototype adds 3–5% baseline overhead; C/C++ would reduce this

## Fit or break under constrained CI/CD
- **Breaks**: Requires host-level eBPF (privileged access), not viable in restricted CI/CD runners without kernel capabilities
- **Breaks**: 10–15% CPU overhead may exceed resource budgets in resource-constrained CI/CD environments
- **Fits**: Container-level granularity and per-container filtering align with containerized CI/CD workloads
- **Fits**: Offline analysis of patterns (like sidecars) could pre-determine CriticalMetrics for standard CI/CD components, reducing runtime overhead
