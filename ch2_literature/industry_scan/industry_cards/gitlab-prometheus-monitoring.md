# GitLab Prometheus Monitoring Configuration

**Type:** Platform Documentation  
**Source:** GitLab Official Documentation  
**URL:** https://docs.gitlab.com/ee/administration/monitoring/prometheus/  
**Access Date:** January 6, 2026  
**Relevance:** Metrics endpoints, Prometheus exporters, observability architecture

---

## Summary

Official GitLab documentation for monitoring GitLab instances using Prometheus. Describes bundled exporters (node, Redis, PostgreSQL, PgBouncer, Registry, GitLab exporter), metrics endpoints, scrape configurations, and external Prometheus server integration.

---

## Key Concepts

### Bundled Exporters
- **Node exporter**: Machine resources (CPU, memory, disk, network)
- **Redis exporter**: Redis metrics
- **PostgreSQL exporter**: Database metrics
- **PgBouncer exporter**: Connection pooler metrics
- **Registry exporter**: Container registry metrics
- **GitLab exporter**: GitLab-specific metrics (from Redis and database)
- **Web exporter**: Dedicated metrics server (split user and monitoring traffic)

### Metrics Endpoint
- **GitLab metrics endpoint**: `/-/metrics` (requires authentication, same URL/port as user traffic)
- **Exporter endpoints**: Listen on dedicated ports (configurable)
- **Default Prometheus port**: 9090 (bundled Prometheus server)

### Configuration Patterns
- **Bundled Prometheus**: Enabled by default, listens on localhost:9090
- **External Prometheus**: Requires disabling bundled Prometheus, configuring exporter addresses to listen on network interfaces (0.0.0.0)
- **Standalone monitoring node**: Using Consul service discovery for multi-node GitLab deployments

### Security Considerations
- **No authentication on exporters**: "Prometheus and its exporters don't authenticate users, and are available to anyone who can access them"
- **Recommendation**: Use firewall rules to restrict access, do not expose publicly
- **HSTS conflicts**: SSL-enabled GitLab may prevent accessing Prometheus on same FQDN due to HTTP Strict Transport Security

---

## Observability Technologies Mentioned

### Metrics Collection
- **Prometheus format**: All exporters use Prometheus exposition format
- **Scrape configurations**: Static configs, custom scrape targets, Consul service discovery
- **Storage retention**: Configurable via `storage.tsdb.retention.time` (default 15 days), `storage.tsdb.retention.size` (experimental, default disabled)

### Query and Visualization
- **Prometheus console**: Direct access to Prometheus query interface at http://localhost:9090
- **Grafana integration**: Prometheus as Grafana data source for dashboards
- **Sample queries provided**: CPU utilization, memory availability, network I/O, disk IOPS, RPS via GitLab transaction count

### Tracing and Logs
- **Not mentioned**: No distributed tracing or log aggregation discussed in this document (focused on metrics)

---

## CI/CD Relevance

### Runner Metrics (cross-reference with gitlab-runner-monitoring)
- This document focuses on **GitLab instance monitoring** (server-side components)
- **GitLab Runner metrics**: Separate documentation (see gitlab-runner-monitoring.md)
- **Integration point**: External Prometheus can scrape both GitLab instance and GitLab Runner metrics endpoints

### Deployment Patterns
- **Bundled by default**: GitLab includes Prometheus and exporters in Linux packages
- **External Prometheus option**: For organizations with existing Prometheus infrastructure
- **Multi-node support**: Standalone monitoring node with Consul service discovery (reference architectures)

### Operational Constraints
- **Disk space management**: `/var/opt/gitlab/prometheus` can consume excessive disk space; documented cleanup procedures
- **Network exposure**: Changing listen addresses requires firewall configuration and nginx access control lists
- **Service discovery**: Consul-based discovery for dynamic environments (avoid static IP configurations)

---

## Key Findings for Thesis

### 1. Separation of User and Monitoring Traffic
- GitLab metrics endpoint (`/-/metrics`) on same port as user traffic **requires authentication**
- Exporters on dedicated ports **do not authenticate** (security trade-off for simplicity)
- **Web exporter**: Dedicated metrics server to split traffic (performance and availability improvement)

### 2. Prometheus as Standard
- Prometheus format universally adopted across all GitLab components
- No mention of alternative metrics formats (e.g., StatsD, OpenTelemetry Metrics)
- **Implication**: Prometheus dominance in GitLab ecosystem

### 3. Configuration Complexity vs. Security
- **Simple setup**: Bundled Prometheus works out-of-the-box on localhost
- **Production deployment**: Requires multiple configuration steps (disable bundled Prometheus, configure exporter listen addresses, set up firewalls, configure allowlists, restart services)
- **Trade-off**: Ease of use vs. security (default insecure for network access)

### 4. No Mention of OpenTelemetry
- Document dated 2026, but no OpenTelemetry integration mentioned
- **Contrast with Jenkins**: Jenkins has OpenTelemetry plugin for distributed tracing (see jenkins-opentelemetry.md)
- **Gap**: GitLab monitoring remains Prometheus-centric, no unified observability (traces/metrics/logs)

### 5. Metrics-Only Observability
- This document exclusively covers **metrics**
- **Logs**: Separate GitLab logging documentation (not referenced here)
- **Traces**: No distributed tracing mentioned (though GitLab has experimental Jaeger integration documented elsewhere)
- **Implication**: Siloed observability signals in GitLab documentation

---

## Quotes for Citation

> "Prometheus and its exporters don't authenticate users, and are available to anyone who can access them."

> "The metrics server exports data about the internal state of the GitLab Runner process and should not be publicly available!"

> "Prometheus works by periodically connecting to data sources and collecting their performance metrics through the various exporters."

> "The performance data collected by Prometheus can be viewed directly in the Prometheus console, or through a compatible dashboard tool. [...] For a more fully featured dashboard, Grafana can be used and has official support for Prometheus."

---

## Gaps Identified

1. **No CI/CD pipeline-specific metrics**: Document covers GitLab instance metrics, not job/pipeline execution metrics
2. **No correlation guidance**: How to correlate GitLab instance metrics with pipeline failures or performance issues
3. **No sampling strategies**: Prometheus default scrape interval (typically 10-30s), no discussion of high-cardinality metrics or sampling
4. **No cost considerations**: Disk space mentioned as operational issue, but no guidance on metrics volume or retention trade-offs
5. **No observability maturity model**: Documentation assumes users know what metrics to monitor and how to set up dashboards

---

## Related Sources
- [gitlab-runner-monitoring.md](gitlab-runner-monitoring.md): GitLab Runner Prometheus metrics endpoint (port 9252)
- [jenkins-prometheus-integration.md](jenkins-prometheus-integration.md): Comparison with Jenkins Prometheus plugin
- [grafana-prometheus-integration.md](grafana-prometheus-integration.md): Prometheus as Grafana data source
- [jenkins-opentelemetry.md](jenkins-opentelemetry.md): Contrast with unified observability approach

---

## Evidence Extraction Notes
- **Comprehensive configuration guide**: Covers default setup, external Prometheus, standalone monitoring node, storage retention
- **Security warnings repeated**: Multiple sections emphasize lack of authentication on exporters
- **Grafana integration**: Explicit mention of Prometheus as Grafana data source (official support)
- **No OpenTelemetry**: Despite 2026 date, document remains Prometheus-exclusive
- **Sample queries provided**: Concrete examples of useful Prometheus queries for GitLab monitoring
