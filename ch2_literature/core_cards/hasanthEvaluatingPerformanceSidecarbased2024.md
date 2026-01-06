# hasanthEvaluatingPerformanceSidecarbased2024

## Problem addressed
Service mesh solutions with sidecar proxies (Istio, Linkerd) pose challenges in resource consumption and application performance. Sidecar-based architectures increase complexity and resource usage. This paper evaluates sidecarless service mesh (Cilium using eBPF) as alternative to sidecar-based solutions.

## Observability mechanism
- Three service meshes evaluated: Istio (Envoy sidecar), Linkerd (Rust-based lightweight sidecar), Cilium (eBPF-based sidecarless)
- Cilium leverages eBPF in kernel for visibility and control without sidecars
- Hubble for observability: Hubble server collects eBPF visibility data from Cilium, Hubble relay provides cluster-wide unified API
- L7 traffic management (HTTP, Kafka, gRPC, DNS)

## Privilege assumptions
Kernel eBPF access required for Cilium. eBPF programs run in kernel space to control container ingress/egress traffic. Cilium agent manages eBPF programs, requires elevated privileges to interact with kernel and Docker/Kubernetes orchestration events.

## Application code modification
No. All three service meshes (Istio, Linkerd, Cilium) provide functionalities without modifying application code. Networking logic offloaded to proxies (Istio/Linkerd) or eBPF (Cilium). Service mesh operates at infrastructure layer.

## Telemetry signals
Metrics collected via eBPF (Cilium) or Envoy/proxy sidecars (Istio/Linkerd). Signals include: request/response times, error rates, throughput, service health. Hubble provides gRPC API for flows and Prometheus metrics. Distributed tracing, centralized logging, traffic telemetry (health checks, alerting).

## Collection pattern
Cilium: Host-based eBPF collection in kernel, Hubble server per node, Hubble relay aggregates cluster-wide. Istio/Linkerd: Sidecar-based collection, each proxy consumes ~5MB memory per instance (Istio Envoy). Cilium agent on each worker node interacts with deployed microservices via eBPF.

## Evaluation performed
Kubernetes cluster on Chameleon Cloud bare metal (AMD EPYC 7763, 128 cores, 256GB RAM). 3-node cluster (1 master, 2 workers). Google Online Boutique microservices app (11 services). Locust load testing: 50 concurrent users, 574 requests/sec average, 10-minute runtime. Measured response times, latency percentiles, endpoint distribution for GET/POST requests.

## Overhead reported
Linkerd best performance: 29.85% better than Cilium, 63.43% better than Istio in response times. Cilium 99th percentile: 160ms (GET), 200ms (POST). Istio highest response times. Cilium lower resource utilization than Istio/Linkerd (no sidecar, no separate CNI). Envoy sidecar: ~5MB memory per instance, scales with application complexity.

## Constraints discussed by authors
Cilium lacks some features: fault injection, circuit breaking, limited canary rollout support vs Istio. Sidecar-based meshes (Istio/Linkerd) require separate CNI deployment, increasing operational burden and resource consumption. Cilium requires kernel eBPF support. Performance depends on CNI choice for Istio/Linkerd.

## Fit or break under constrained CI/CD
- Kernel eBPF requirement for Cilium likely unavailable in restricted CI/CD containers without privileged access or custom kernel modules.
- Cilium's dual role (CNI + service mesh) reduces operational overhead, beneficial for CI/CD infrastructure simplicity.
- Sidecar-based meshes (Istio/Linkerd) add per-pod memory overhead (~5MB+ per sidecar), multiplying resource consumption in CI/CD pipelines with many ephemeral pods.
- Cilium's lower overall resource utilization and operational costs suit resource-constrained CI/CD environments better than Istio/Linkerd, though kernel access remains a blocker.
