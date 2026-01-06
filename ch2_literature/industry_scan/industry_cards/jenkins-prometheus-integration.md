# Jenkins Prometheus Metrics Plugin

## Source
**SHORT_KEY:** jenkins-prometheus  
**TITLE:** Jenkins Prometheus Plugin for Metrics Export  
**LINK:** https://plugins.jenkins.io/prometheus/  
**DATE_ACCESSED:** 2026-01-05

## What observability signals are used?
- **Metrics:** Prometheus-compatible metrics exposed at `/prometheus/` endpoint (default); includes metrics from Metrics-plugin and Prometheus-plugin
- **Time-series data:** Scraped by Prometheus server at configurable intervals
- **System metrics:** CPU, memory, disk usage (configurable via `COLLECT_DISK_USAGE` env var)
- **CI/CD-specific:** Build metrics, job metrics, pipeline metrics (per plugin documentation reference)

## What deployment assumptions/constraints are revealed?
- **Endpoint requirements:** Metrics endpoint must end with trailing slash (`/prometheus/`) to avoid 302 redirects that some scraping tools cannot handle
- **Storage backend assumptions:** Plugin warns against enabling disk usage collection for cloud-based storage backends to avoid "scanning virtually unlimited storage"
- **Namespace configuration:** Metrics prefix configurable via `PROMETHEUS_NAMESPACE` env var (default: `default`)
- **Collection frequency:** Async task period configurable via `COLLECTING_METRICS_PERIOD_IN_SECONDS` (default: 120 seconds)

## How are CI/CD metrics correlated across services?
- **Metric naming:** Prometheus metrics follow naming conventions with namespace prefix (e.g., `default_<metric_name>`)
- **Label-based correlation:** Likely uses Prometheus labels for job names, build numbers, etc. (implied by Prometheus integration but specifics not detailed in source)
- **Endpoint aggregation:** Single `/prometheus/` endpoint exposes all metrics for scraping

## What pain points or challenges are mentioned?
- **Trailing slash requirement:** Scraping tools must handle trailing slash in endpoint URL or receive 302 redirect that "some tools cannot handle...well"
- **Cloud storage scanning:** Default disk usage collection can cause performance issues with cloud-based storage backends; must be explicitly disabled
- **Servlet API compatibility:** Issue 207 noted incompatibility with Servlet API 2.4 (Tomcat 5.5) in earlier version

## What observability approaches are avoided or not mentioned?
- **Push-based metrics:** No mention of pushing metrics to Prometheus Pushgateway; follows pull-based scraping model only
- **Distributed tracing:** No trace integration mentioned
- **Log aggregation:** No log export to Prometheus or Loki mentioned
- **Service discovery:** No discussion of Prometheus service discovery mechanisms for Jenkins nodes

## Technical specifics
- **Environment variables:**
  - `PROMETHEUS_NAMESPACE`: Metric prefix (default: `default`)
  - `PROMETHEUS_ENDPOINT`: REST endpoint path (default: `/prometheus/`)
  - `COLLECTING_METRICS_PERIOD_IN_SECONDS`: Async collection period (default: `120`)
  - `COLLECT_DISK_USAGE`: Enable/disable disk usage metrics (default: `true`)
- **Build/test:** Uses Maven (`mvn clean install`, `mvn hpi:hpi`)
- **Static analysis:** SpotBugs checks via `mvn spotbugs:check`
- **CI/CD integration:** Jenkins plugin hosted on CloudBees Jenkins CI with nightly builds

## Platform/environment
- **Target platform:** Jenkins (any version supporting plugins)
- **Metrics format:** Prometheus text-based exposition format
- **Scraping model:** Pull-based via Prometheus server scraping `/prometheus/` endpoint

## Security considerations
- **Authentication:** No explicit discussion of authentication for `/prometheus/` endpoint; likely inherits Jenkins security configuration
- **Access control:** No mention of IP whitelisting or endpoint-specific access controls (unlike Monitoring plugin)