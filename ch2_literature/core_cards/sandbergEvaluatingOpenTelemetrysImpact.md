# sandbergEvaluatingOpenTelemetrysImpact

## Problem addressed
Evaluating the performance impact of implementing OpenTelemetry in microservice-based systems, as performance overhead is a key concern for organizations considering observability tools. The thesis investigates how OpenTelemetry affects CPU, memory, latency, and network usage compared to alternative tools.

## Observability mechanism
- Automatic instrumentation using OpenTelemetry Java agent for traces and metrics
- Manual instrumentation using OpenTelemetry API and SDK
- Distributed tracing with span generation (123 spans per request)
- Metrics collection (49 metrics via OTel agent)
- Comparison with Zipkin for tracing and Prometheus for metrics

## Privilege assumptions
Not stated

## Application code modification
- Manual tracing: Yes (source code modified to create spans, inject/extract context from HTTP headers)
- Automatic tracing: No (Java agent added to JVM startup arguments without source code changes)
- Automatic metrics: No (Java agent deployment only)

## Telemetry signals
- Traces: Distributed traces with spans containing trace ID, span ID, parent ID, timestamps, tags
- Metrics: Time series metrics including JVM metrics, CPU, memory, thread counts (49 metrics via OTel, 97 via Prometheus)
- Logs: Not evaluated in this study

## Collection pattern
In-container agent (OpenTelemetry Java agent attached to application JVM); push model with OTLP exporter sending data over gRPC/HTTP to Jaeger backend; Prometheus scrapes metrics via HTTP endpoint every 15 seconds

## Evaluation performed
- Setup: 5-service Spring-based microservice system (API gateway pattern) on Docker containers, 2-machine testbed (AMD Ryzen 7 5800X 16 cores/32GB RAM, Intel i7-8565U 8 cores/16GB RAM)
- Load: 200-400 simulated users generating 150-300 requests/second using Locust
- Scale: Small-scale single-cluster deployment
- Metrics: CPU usage, memory usage, 95th percentile latency, network traffic (data transmitted/received per request)

## Overhead reported
- Manual tracing: 18-26% CPU, 8% memory, 9-12% latency overhead
- Automatic tracing: 42% CPU (under certain conditions), 22% memory, 24% latency, 30% network overhead
- Automatic metrics: Lower overhead than tracing but slightly higher than Prometheus
- With batching (default 512 batch size) and sampling (3% rate): CPU overhead reduced to 3.6%, latency overhead to 3.4%

## Constraints discussed by authors
- Only one test system evaluated (Java-based Spring applications)
- Observability data stored in memory rather than persistent databases (production systems would use databases)
- Different programming languages have different SDKs/agents that may perform differently
- Architecture or hardware constraints may produce different results
- Automatic instrumentation cannot generate system-specific telemetry or custom application-level metrics

## Fit or break under constrained CI/CD
- Breaks: Automatic instrumentation incurs roughly 2x CPU overhead compared to manual (42% vs 18-26%), problematic for resource-constrained CI/CD pipelines
- Breaks: Default configuration without batching/sampling causes 18-42% CPU overhead and 9-24% latency increase, unacceptable for performance-sensitive CI environments
- Fits: With optimized configuration (batching + 3% sampling rate), overhead becomes negligible (3.6% CPU, 3.4% latency), acceptable for many CI/CD scenarios
- Breaks: Requires JVM-based applications and sufficient memory to run agent alongside application containers, limiting use in minimal container images
