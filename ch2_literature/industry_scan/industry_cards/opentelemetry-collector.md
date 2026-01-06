# OpenTelemetry Collector Deployment

## Source
**SHORT_KEY:** otel-collector  
**TITLE:** OpenTelemetry Collector for Telemetry Collection  
**LINK:** https://opentelemetry.io/docs/collector/  
**DATE_ACCESSED:** 2026-01-05

## What observability signals are used?
- **Metrics:** Time-series metrics from applications and infrastructure
- **Logs:** Application logs and system logs
- **Traces:** Distributed traces for request flows
- **Multi-signal:** Unified support for traces, metrics, and logs in single codebase

## What deployment assumptions/constraints are revealed?
- **Deployment patterns:** No collector (direct export), agent (local collector), or gateway (centralized collector)
- **Default assumptions:** OTLP exporters in languages assume local collector endpoint; collector "will automatically start receiving telemetry"
- **Deployment flexibility:** Single binary deployable as agent or collector
- **Scalability:** Supports batch processing, retries, encryption, data filtering
- **Kubernetes focus:** Kubernetes-specific deployment via Operator and Helm charts
- **Performance:** "Highly stable and performant under varying loads and configurations"

## How are CI/CD metrics correlated across services?
- **Vendor-agnostic formats:** Supports "open source observability data formats (e.g., Jaeger, Prometheus, Fluent Bit, etc.)"
- **Multi-backend:** Can send to "one or more open source or commercial backends"
- **Component pipeline:** Receivers → Processors → Exporters → Connectors architecture for data transformation and routing
- **OpenTelemetry Protocol (OTLP):** Standard protocol for telemetry data exchange across services

## What pain points or challenges are mentioned?
- **Multiple agents problem:** Collector "removes the need to run, operate, and maintain multiple agents/collectors"
- **Retry and batching:** Services need to "offload data quickly" while collector handles "retries, batching, encryption or even sensitive data filtering"
- **Mixed stability:** Components have "mixed stability levels"; each component stability documented separately in registry
- **Configuration complexity:** Emphasized need for "reasonable default configuration" and "security best practices" for hosting and configuration

## What observability approaches are avoided or not mentioned?
- **Push-based collection:** Focus on receiver-based (pull/push) ingest; no discussion of agent-less collection
- **Automatic instrumentation:** Zero-code instrumentation mentioned for platforms but not as core collector feature
- **Built-in storage:** No mention of embedded storage; assumes backends for persistence

## Technical specifics
- **Architecture:**
  - Receivers: Ingest telemetry data
  - Processors: Transform, filter, enrich data
  - Exporters: Send data to backends
  - Connectors: Link pipelines
  - Extensions: Optional capabilities (e.g., health check)
- **Supported formats:** Jaeger, Prometheus, Fluent Bit, Zipkin, OpenCensus
- **Configuration:** YAML-based configuration files
- **Observability of collector itself:** "Internal telemetry" for monitoring collector health
- **Component ecosystem:** 150+ integrations available via registry

## Platform/environment
- **Kubernetes:** OpenTelemetry Operator for auto-instrumentation and collector management; Helm charts for deployment
- **Cloud-native:** Part of CNCF (Cloud Native Computing Foundation)
- **Deployment modes:** Agent (per-node sidecar), Gateway (cluster-level aggregation), or No Collector (direct export)
- **Platform support:** Linux, Windows, macOS; container and VM deployments

## Security considerations
- **Hosting best practices:** Dedicated documentation for secure hosting
- **Configuration best practices:** Dedicated documentation for secure configuration
- **Data filtering:** Supports "sensitive data filtering" in processing pipeline
- **Encryption:** Supports encryption for data in transit