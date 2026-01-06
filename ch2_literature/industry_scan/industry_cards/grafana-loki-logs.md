# Grafana Loki for Log Aggregation

## Source
**SHORT_KEY:** grafana-loki  
**TITLE:** Grafana Loki Log Aggregation System  
**LINK:** https://grafana.com/docs/loki/  
**DATE_ACCESSED:** 2026-01-05

## What observability signals are used?
- **Logs:** Primary signal; unstructured and structured log data
- **Labels:** Metadata indexed for log streams (similar to Prometheus label model)
- **Metrics from logs:** Can generate metrics from log content (mentioned in webinars: "create metrics from logs")
- **Alerting:** Prometheus-style alerting rules can be applied to log data

## What deployment assumptions/constraints are revealed?
- **Storage backend:** Logs stored in object storage (Amazon S3, Google Cloud Storage) or local filesystem
- **Compression:** Log data compressed before storage in chunks
- **Index strategy:** "Unlike other logging systems, Loki is built around the idea of only indexing metadata about your logs' labels" (not full-text indexing)
- **Agent deployment:** Promtail agent (and others) collect logs and send to Loki
- **Kubernetes integration:** Docker/Kubernetes environment assumed based on deployment examples

## How are CI/CD metrics correlated across services?
- **Label-based correlation:** Uses label model for log stream organization (job, instance, container, etc.)
- **LogQL queries:** Query language inspired by PromQL allows filtering logs by labels and content
- **Grafana integration:** Logs visualized in Grafana alongside metrics and traces for unified observability
- **Correlation with metrics:** Demo mentioned "create metrics from logs" for correlation with Prometheus metrics

## What pain points or challenges are mentioned?
- **Scaling logs:** Webinar topic "scaling and securing your logs" suggests challenges at scale
- **Cost management:** "Cost-effectively" scaling mentioned; implies cost is a pain point with other solutions
- **Configuration complexity:** Webinar on "Essential Loki configuration settings" suggests non-trivial setup (agents, server, storage backends)

## What observability approaches are avoided or not mentioned?
- **Full-text indexing:** Explicitly avoids indexing full log content (only labels indexed)
- **Push-based collection:** Assumes agent-based log shipping (Promtail, etc.); no syslog push receiver mentioned
- **Log parsing at ingestion:** No mention of automatic log parsing; LogQL handles queries at read time
- **Embedded agents:** Agents like Promtail deployed separately, not embedded in applications

## Technical specifics
- **Components:**
  - Loki server (log aggregation and storage)
  - Promtail agent (log collection and shipping)
  - Grafana Alloy (mentioned as alternative collection agent)
  - Docker driver (for container log collection)
- **Storage model:**
  - Labels indexed (metadata)
  - Log chunks compressed and stored in object storage or filesystem
  - Time-based chunk organization
- **Query language:** LogQL (Prometheus-inspired syntax for log queries)
- **Multi-tenancy:** Supports multi-tenant architecture

## Platform/environment
- **Target environments:** Kubernetes, Docker, Linux/Windows hosts
- **Cloud-native:** Part of Grafana LGTM+ stack (Loki, Grafana, Tempo, Mimir)
- **Storage backends:** Amazon S3, Google Cloud Storage, local filesystem
- **Deployment modes:** Self-managed (open source) or Grafana Cloud Logs (managed)

## Security considerations
- **Access control:** Centralized authentication and multi-tenant isolation in Grafana Cloud Logs
- **Data governance:** Tenant-level data isolation
- **Secure transport:** HTTPS/TLS for log shipping (implied but not explicitly detailed in source)