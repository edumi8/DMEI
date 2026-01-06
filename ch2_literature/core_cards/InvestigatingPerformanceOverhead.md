# InvestigatingPerformanceOverhead

## Problem addressed
This thesis explores the performance impact of distributed tracing on microservices and serverless applications by measuring throughput and latency across different configurations. The study addresses the trade-off between system visibility and performance overhead, and the unclear sources of overhead in the distributed tracing process.

## Observability mechanism
- Distributed tracing implementation using OpenTelemetry and Elastic APM
- Automatic and manual instrumentation of microservices and serverless functions
- Trace data collection, export, and storage in external systems (Kibana)
- End-to-end request tracking across services with spans capturing operation metadata

## Privilege assumptions
Not stated

## Application code modification
Yes. Manual instrumentation required for serverless applications using OpenTelemetry SDK (configuration, span creation, context propagation, attribute setting). Automatic instrumentation used for microservices via agents.

## Telemetry signals
Traces (distributed tracing with spans). Metrics include throughput (requests per second), latency (request duration), and execution time for serverless workloads.

## Collection pattern
Export-based pattern. Instrumented applications export trace data to OpenTelemetry Collector, which forwards to Kibana for storage and analysis.

## Evaluation performed
Three experiments: (1) Request-based microservices on Python Flask, Java Spring, Go http, Node.js using TechEmpower benchmarks; (2) Serverless applications on OpenWhisk using SeBS benchmarks in Python and Node.js; (3) Profiling analysis to identify overhead sources. Throughput, latency (median, p99), and CPU profiling measured across instrumented vs non-instrumented configurations.

## Overhead reported
Request-based: 19-80% throughput decrease, 7-42% median latency increase. Serverless: 175% latency increase for short-duration apps, 6.7% for longer-duration apps. Main contributors: configuration and export stages (configuration significantly impacts serverless cold-start scenarios).

## Constraints discussed by authors
Performance trade-off between visibility and overhead. Excessive monitoring does not guarantee better visibility. Serverless applications particularly sensitive to tracing overhead due to low-latency operations. Configuration overhead significant in cold-start scenarios.

## Fit or break under constrained CI/CD
- Configuration overhead in cold-start scenarios (175% latency increase) problematic for ephemeral CI/CD workloads with frequent cold starts.
- Export stage contributes significantly to overhead; external network calls to collectors may be unreliable or blocked in restricted CI/CD networks.
- Automatic instrumentation reduces setup complexity but introduces 19-80% throughput degradation, potentially unacceptable for performance-critical CI pipelines.
- Manual instrumentation for serverless requires code modification, adding maintenance burden incompatible with fast-moving CI/CD environments.
