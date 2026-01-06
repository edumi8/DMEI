# usmanDESKDistributedObservability2023

## Problem addressed
DESK addresses the challenge of detecting and troubleshooting performance issues in edge-based containerized microservices where existing observability tools operate independently without systematically covering the entire data workflow. The framework targets runtime performance observability for infrastructure, platform, and containerized microservices in Kubernetes-orchestrated edge clusters.

## Observability mechanism
- Metrics collection via Telegraf agent (88 metrics from 8 input plugins)
- Logs acquisition using Promtail agent
- Traces acquisition via Jaeger agent
- Apache Kafka for reliable data pipeline and aggregation
- Prometheus for metrics storage
- Loki for logs storage
- Elasticsearch for traces and long-term storage
- Grafana for visualization and dashboards
- Prometheus AlertManager for anomaly detection and alerts

## Privilege assumptions
Not stated

## Application code modification
Yes – traces require application instrumentation with OpenTelemetry tracing SDKs and APIs (demonstrated with Python application)

## Telemetry signals
Metrics, logs, and traces at infrastructure, platform, and application level

## Collection pattern
Host-based using Kubernetes DaemonSet (one agent per node); push mode via Apache Kafka

## Evaluation performed
Testbed with 1 master + 3 worker nodes (Intel i7-6700, 16GB RAM, Ubuntu 22.04, Kubernetes 1.26.0). Experiments with varying measurement intervals (250ms to 10s), varying pod counts (50 to 110 pods), and continuous IoT sensor data streams processed via ThingsBoard platform.

## Overhead reported
- Metrics: ~50 MiB memory (consistent across intervals), 62 MiB on master node at 10s interval; CPU varies significantly with interval
- Logs: 70 MiB memory for 110 pods; CPU overhead 90ms for 50 pods, 130ms for 110 pods
- Traces: 6.5 MiB memory for 50 pods, 10 MiB for 110 pods; CPU overhead up to 1.3ms for 110 pods
- Overall average: ~2.5% of total available hardware resources (CPU and memory combined)

## Constraints discussed by authors
- Measurement interval selection is critical: authors recommend 1s for time-sensitive applications vs. 10s Kubernetes default
- Master node requires less aggressive measurement intervals (e.g., 10s) for high-cardinality Kubernetes resource metrics to avoid errors
- Trace sampling strategy must be carefully determined to ensure sustainable load for tracing backend services
- Framework deployment requires two dedicated namespaces with limited resource allocations to isolate from actual workloads

## Fit or break under constrained CI/CD
- DaemonSet deployment pattern ensures persistent execution on all nodes but requires Kubernetes orchestration (may not fit non-Kubernetes CI/CD environments)
- Framework components deployed in dedicated namespaces with resource limits help prevent interference with workloads, suitable for multi-tenant CI/CD
- Apache Kafka dependency adds infrastructure complexity and resource requirements that may exceed lightweight CI/CD constraints
- Requires multiple backend storage systems (Prometheus, Loki, Elasticsearch) which significantly increases resource footprint beyond typical CI/CD runner capacity
