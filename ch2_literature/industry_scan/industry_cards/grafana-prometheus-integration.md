# Grafana with Prometheus Integration

## Source
**SHORT_KEY:** grafana-prometheus  
**TITLE:** Grafana and Prometheus for Observability  
**LINK:** https://grafana.com/oss/prometheus/  
**DATE_ACCESSED:** 2026-01-05

## What observability signals are used?
- **Metrics:** Prometheus time-series metrics (primary signal)
- **Logs:** Grafana Loki integration for log aggregation (LGTM+ stack: Loki, Grafana, Tempo, Mimir)
- **Traces:** Grafana Tempo for distributed tracing
- **Profiles:** Grafana Pyroscope for continuous profiling
- **Dashboards:** Grafana for visualization and alerting

## What deployment assumptions/constraints are revealed?
- **Data source integration:** Grafana acts as visualization layer; Prometheus acts as metrics storage backend
- **Deployment models:**
  - DIY self-hosted Prometheus (limited to single machine scale)
  - Grafana Cloud Metrics (managed Prometheus-as-a-Service)
  - Grafana Enterprise Metrics (self-managed, horizontally scalable)
- **Architecture patterns:** Centralized, horizontally scalable, replicated architecture for large deployments
- **Access control:** Centralized authentication and access control (vs. all-or-nothing in traditional Prometheus)

## How are CI/CD metrics correlated across services?
- **Label-based correlation:** Prometheus uses labels (similar to Kubernetes labels) for grouping and filtering metrics
- **Multi-tenant architecture:** Grafana Cloud Metrics supports multiple tenants with isolated data
- **Dashboarding:** Grafana dashboards aggregate metrics across services; supports template variables for dynamic correlation
- **Query language:** PromQL (Prometheus Query Language) for filtering, aggregation, and correlation

## What pain points or challenges are mentioned?
- **DIY scaling complexity:** Traditional Prometheus "DIY style of scaling...is complex and requires a lot of effort to maintain throughout different teams"
- **Single-machine limits:** Self-hosted Prometheus scale "limited to a single machine"
- **Data governance:** Lacks data governance in traditional setup, resulting in "all-or-nothing access to metrics"
- **Operational overhead:** Requires "a lot of effort to deploy and maintain" for DIY setups
- **High cardinality challenges:** Grafana Cloud Adaptive Metrics addresses "Prometheus high cardinality metrics" cost/performance issues

## What observability approaches are avoided or not mentioned?
- **Push-based metrics:** Prometheus pull model emphasized; no discussion of Pushgateway for batch jobs
- **Agent-based collection:** Focus on Prometheus scraping; limited discussion of Grafana Alloy (OpenTelemetry Collector)
- **Embedded instrumentation:** Assumes applications export Prometheus metrics; no auto-instrumentation discussion

## Technical specifics
- **Prometheus components:**
  - Metrics scraping via HTTP endpoints
  - Embedded time series database (TSDB)
  - PromQL query language
  - 150+ third-party integrations
- **Grafana integrations:**
  - Prometheus data source plugin
  - Supports templated dashboards (10k+ community dashboards available)
  - Alerting triggered from Prometheus queries
- **LGTM+ Stack:**
  - Loki (logs)
  - Grafana (visualization)
  - Tempo (traces)
  - Mimir (metrics backend, Prometheus-compatible)

## Platform/environment
- **Kubernetes focus:** Prometheus described as "accepted standard in the Kubernetes world"
- **Cloud-native:** Part of CNCF (Cloud Native Computing Foundation); graduated project
- **Multi-cloud:** Grafana Cloud Metrics works across AWS, GCP, Azure
- **Export formats:** Prometheus text format, JSON, XML, TXT (via External API)

## Security considerations
- **Multi-tenancy:** Grafana Cloud Metrics provides tenant isolation and centralized access control
- **Authentication:** Enterprise and Cloud versions include robust authentication/authorization
- **Data governance:** Grafana approach provides "robust data-access policies enable administrators to secure and govern your metrics data"