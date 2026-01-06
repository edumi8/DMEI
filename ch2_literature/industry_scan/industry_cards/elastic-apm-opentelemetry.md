# Elastic APM with OpenTelemetry Integration

## Source
**SHORT_KEY:** elastic-apm-otel  
**TITLE:** Elastic Application Performance Monitoring with OpenTelemetry  
**LINK:** https://www.elastic.co/observability/application-performance-monitoring  
**DATE_ACCESSED:** 2026-01-05

## What observability signals are used?
- **Traces:** Distributed traces for request flows across services
- **Metrics:** Application metrics, service metrics, transaction metrics
- **Logs:** Correlated with traces for unified debugging
- **Profiling:** Continuous profiling data (via Elastic Universal Profiling)
- **Error tracking:** Exception and error capture with stack traces

## What deployment assumptions/constraints are revealed?
- **OpenTelemetry-first:** "Production-grade pure OTel"; "stream native OTel without proprietary agents"
- **Agent deployment:** Language-specific APM agents (Java, .NET, Node.js, Python, Ruby, Go, PHP) or OpenTelemetry SDKs
- **Serverless support:** APM agents for AWS Lambda (via extension) and other serverless platforms
- **Mobile support:** iOS and Android APM agents for mobile observability
- **Browser support:** Real User Monitoring (RUM) JavaScript agent for frontend observability
- **Sampling:** Configurable sampling for traces to manage data volume

## How are CI/CD metrics correlated across services?
- **Trace context propagation:** W3C Trace Context standard for correlation across services and languages
- **Service maps:** Automatic service topology visualization based on traces
- **Transaction correlation:** Transactions linked across services via trace IDs
- **Log-trace correlation:** Logs enriched with trace IDs for unified troubleshooting
- **Metrics from traces:** Derived metrics (latency, throughput, error rate) calculated from traces

## What pain points or challenges are mentioned?
- **Observability complexity:** "Broad language support" needed due to polyglot microservices
- **Agent overhead:** Emphasis on "sampling" to reduce data volume and agent overhead
- **Vendor lock-in:** Addressed by "pure OTel" approach allowing vendor-agnostic instrumentation
- **Data correlation:** Implicit pain point addressed by unified platform (logs + traces + metrics)

## What observability approaches are avoided or not mentioned?
- **Proprietary instrumentation:** Explicitly avoided in favor of OpenTelemetry
- **Full trace collection:** Sampling required for high-throughput services
- **Agent-less APM:** Assumes agent-based instrumentation (OTel SDK or Elastic APM agent)

## Technical specifics
- **APM agents (Elastic-native):**
  - Java, .NET, Node.js, Python, Ruby, Go, PHP (server-side)
  - iOS (Swift), Android (Java/Kotlin) (mobile)
  - RUM JavaScript (browser)
- **OpenTelemetry support:**
  - OTLP (OpenTelemetry Protocol) ingestion
  - OTel SDKs for auto-instrumentation
  - OTel Collector for data aggregation and routing
- **Data model:**
  - Spans: Individual operations within a trace
  - Transactions: Top-level spans (e.g., HTTP requests, background jobs)
  - Errors: Exceptions and error details
  - Metrics: Aggregated from spans (e.g., latency percentiles)
- **Sampling strategies:**
  - Head-based sampling (decision at trace start)
  - Tail-based sampling (decision after trace completion, via OTel Collector)
  - Adaptive sampling (dynamic adjustment based on traffic)

## Platform/environment
- **Languages:** Java, .NET, Node.js, Python, Ruby, Go, PHP, Swift, Kotlin, JavaScript
- **Frameworks:** Spring Boot, Django, Flask, Express.js, Rails, Gin, Symfony, Laravel, etc. (via auto-instrumentation)
- **Serverless:** AWS Lambda (via APM Lambda extension), Azure Functions, Google Cloud Functions
- **Containers:** Docker, Kubernetes (via OTel Operator or Elastic APM agents)
- **Mobile:** iOS (Swift), Android (Java/Kotlin)

## Security considerations
- **Sensitive data filtering:** APM agents support filtering sensitive data from spans and logs
- **TLS/HTTPS:** Encrypted communication between agents and Elastic APM Server
- **Authentication:** API keys or secret tokens for agent authentication
- **Multi-tenancy:** Tenant isolation in Elastic Cloud for APM data