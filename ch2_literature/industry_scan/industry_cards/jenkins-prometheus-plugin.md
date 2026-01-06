# Jenkins Prometheus Metrics Plugin

**Type:** Plugin Documentation  
**Source:** Jenkins Plugins Repository  
**URL:** https://plugins.jenkins.io/prometheus/  
**Access Date:** January 6, 2026  
**Relevance:** Metrics endpoint, Prometheus format, Jenkins monitoring

---

## Summary

Official Jenkins Prometheus plugin documentation describing metrics exposure at `/prometheus/` endpoint. Combines metrics from Metrics-plugin (JVM, system) and Prometheus-plugin-specific metrics (Jenkins jobs, builds, queues). Installed on 6.76% of Jenkins controllers. Scrape endpoint requires trailing slash for proper access.

---

## Key Concepts

### Metrics Exposed
- **Metrics-plugin metrics**: JVM metrics, system metrics (from separate Jenkins Metrics plugin)
- **Prometheus-plugin metrics**: Jenkins-specific metrics (jobs, builds, queues, nodes)
- **Endpoint**: `/prometheus/` (default, configurable)
- **Format**: Prometheus exposition format

### Configuration
- **Environment variables**:
  - `PROMETHEUS_NAMESPACE`: Metric prefix (default: `default`)
  - `PROMETHEUS_ENDPOINT`: REST endpoint (default: `/prometheus/`)
  - `COLLECTING_METRICS_PERIOD_IN_SECONDS`: Async task period (default: 120 seconds)
  - `COLLECT_DISK_USAGE`: Enable/disable disk usage collection (default: true; set false for cloud storage)
- **No authentication**: Endpoint accessible without authentication (security consideration)

### Scraping Considerations
- **Trailing slash required**: Endpoint must end with `/` (e.g., `http://jenkins:8080/prometheus/`), otherwise 302 redirect occurs
- **Scrape interval**: Recommended 30s-120s (align with `COLLECTING_METRICS_PERIOD_IN_SECONDS`)
- **Cloud storage warning**: Disable `COLLECT_DISK_USAGE` to avoid scanning unlimited cloud storage

---

## Observability Technologies Mentioned

### Metrics Only
- **Prometheus format**: All metrics exposed in Prometheus exposition format
- **No traces**: Plugin does not support distributed tracing
- **No logs**: Plugin does not aggregate logs

### Integration Points
- **Prometheus server**: Scrapes `/prometheus/` endpoint
- **Grafana**: Visualize metrics via Grafana dashboards (not documented in plugin page, but standard pattern)
- **Complementary to OpenTelemetry**: Can be used alongside Jenkins OpenTelemetry plugin (metrics + traces)

---

## CI/CD Relevance

### Jenkins-Specific Metrics
- **Jobs**: Job success/failure rates, job duration, job queue time
- **Builds**: Build counts, build duration, build success rates
- **Executors**: Executor usage, idle executors, busy executors
- **Queue**: Queue length, queue wait time
- **Nodes**: Node availability, node executor counts
- **Reference**: Full metrics list in [Prometheus-plugin GitHub docs](https://github.com/jenkinsci/prometheus-plugin/blob/master/docs/metrics/index.md)

### Operational Monitoring
- **Executor saturation**: Identify executor bottlenecks (all executors busy)
- **Queue buildup**: Detect queue congestion (jobs waiting for executors)
- **Job failure rates**: Track job reliability over time
- **Build duration trends**: Identify slow builds, performance regressions

---

## Key Findings for Thesis

### 1. Complementary to Distributed Tracing
- **Prometheus plugin**: Metrics for aggregated Jenkins health
- **OpenTelemetry plugin**: Distributed tracing for individual pipeline executions
- **Use together**: Metrics for trends, traces for debugging specific failures
- **Implication**: Unified observability in Jenkins requires both plugins (metrics + traces separate)

### 2. No Authentication on Metrics Endpoint
- **Security risk**: Metrics endpoint exposed without authentication by default
- **GitLab parallel**: GitLab exporters also lack authentication (see gitlab-prometheus-monitoring.md)
- **Industry pattern**: Metrics endpoints commonly unsecured (trade-off for simplicity)
- **Mitigation**: Firewall rules, network segmentation, reverse proxy with auth

### 3. Async Metrics Collection
- **Collection period**: 120 seconds default (2 minutes)
- **Scrape interval recommendation**: Align Prometheus scrape with collection period (avoid stale metrics)
- **Trade-off**: Lower collection frequency reduces overhead but increases staleness

### 4. Cloud Storage Consideration
- **Disk usage metrics**: Can cause performance issues on cloud-based storage (unlimited scanning)
- **Configuration flag**: `COLLECT_DISK_USAGE=false` disables disk metrics
- **Relevance to thesis**: CI/CD environments increasingly cloud-based, metrics collection must adapt to cloud storage semantics

### 5. Trailing Slash Requirement
- **Common misconfiguration**: Missing trailing slash causes 302 redirects
- **Scraper compatibility**: Some Prometheus scrapers cannot handle 302 redirects
- **Documentation emphasis**: Plugin documentation explicitly warns about trailing slash
- **Operational pain point**: Configuration foot-gun for operators

---

## Quotes for Citation

> "The endpoint you've configured or the default endpoint `/prometheus/` [...] needs to end with a trailing slash when you configure the endpoint in your scraping tool. If you miss adding the trailing slash you'll get a 302 response with a redirection to the endpoint ending with a slash. Some tools cannot handle this well."

> "Should the plugin collect disk usage information. Set this to false if you are running Jenkins against a cloud-based storage backend, in order to avoid scanning virtually unlimited storage." (COLLECT_DISK_USAGE environment variable)

> "2 types of metrics are exposed: Metrics from Metrics-plugin [and] Metrics from this plugin."

> "Jenkins Prometheus Plugin expose an endpoint (default `/prometheus/`) with metrics where a Prometheus Server can scrape."

---

## Metrics Examples (from GitHub docs reference)

### Build Metrics
- `default_jenkins_builds_last_build_result`: Last build result (0=success, 1=failure, etc.)
- `default_jenkins_builds_last_build_duration_milliseconds`: Last build duration
- `default_jenkins_builds_last_build_start_time_milliseconds`: Last build start timestamp

### Executor Metrics
- `default_jenkins_executor_count_total`: Total executor count
- `default_jenkins_executor_busy_total`: Busy executors
- `default_jenkins_executor_idle_total`: Idle executors

### Queue Metrics
- `default_jenkins_queue_size_total`: Queue length
- `default_jenkins_queue_waiting_time_milliseconds`: Time jobs spend in queue

### Node Metrics
- `default_jenkins_node_online_total`: Online nodes
- `default_jenkins_node_offline_total`: Offline nodes

---

## Gaps Identified

1. **No correlation with OpenTelemetry traces**: Metrics plugin and OpenTelemetry plugin operate independently (no unified trace-metric correlation)
2. **No job-level labeling**: Metrics aggregated by job name, but no pipeline stage/step granularity (unlike OpenTelemetry spans)
3. **Limited documentation on plugin page**: Full metrics list requires navigating to GitHub docs (not self-contained)
4. **No sampling strategies**: All metrics collected at fixed interval, no adaptive sampling or high-cardinality mitigation
5. **No cost/overhead quantification**: Plugin documentation does not report CPU/memory overhead of metrics collection

---

## Comparison with GitLab Runner Metrics

| Feature | Jenkins Prometheus Plugin | GitLab Runner Metrics |
|---------|--------------------------|----------------------|
| **Endpoint** | `/prometheus/` | Port 9252 |
| **Authentication** | ❌ None | ❌ None |
| **Trailing slash issue** | ✅ Documented | ❓ Not mentioned |
| **Cloud storage handling** | ✅ Configurable | ❓ Not mentioned |
| **Async collection** | ✅ 120s default | ❓ Real-time |
| **Job metrics** | ✅ Success/failure/duration | ✅ Success/failure/duration |
| **Executor metrics** | ✅ Executor usage | ✅ Concurrent job limits |
| **Queue metrics** | ✅ Queue length/wait time | ❓ Not mentioned |

---

## Related Sources
- [jenkins-opentelemetry-plugin.md](jenkins-opentelemetry-plugin.md): Distributed tracing for Jenkins (complementary)
- [gitlab-runner-monitoring.md](gitlab-runner-monitoring.md): GitLab Runner Prometheus metrics (comparison)
- [jenkins-monitoring-overview.md](jenkins-monitoring-overview.md): General Jenkins monitoring approaches
- [grafana-prometheus-integration.md](grafana-prometheus-integration.md): Visualizing Jenkins metrics in Grafana

---

## Evidence Extraction Notes
- **High adoption**: 6.76% of Jenkins controllers (substantial industry usage)
- **Metrics-centric**: Plugin exclusively provides metrics, no traces or logs
- **Operational foot-guns documented**: Trailing slash, cloud storage scanning (good documentation practice)
- **Complementary to OpenTelemetry**: Both plugins can coexist (metrics + traces)
- **No overhead data**: Plugin documentation silent on performance impact
- **GitHub docs reference**: Full metrics catalog requires external link (documentation fragmentation)
