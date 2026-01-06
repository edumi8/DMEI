# Jenkins Monitoring Plugin (JavaMelody)

## Source
**SHORT_KEY:** jenkins-javamelody  
**TITLE:** Jenkins Monitoring Plugin with JavaMelody  
**LINK:** https://plugins.jenkins.io/monitoring/  
**DATE_ACCESSED:** 2026-01-05

## What observability signals are used?
- **Metrics:** HTTP response times, CPU usage, memory (heap/non-heap), GC activity, thread count, system load average, disk space, open file descriptors, build queue length, running builds count
- **Logs:** Error logs, warning messages (e.g., "no space left on device" alerts)
- **Application-specific:** JMX MBeans values, heap histogram, process information
- **Performance profiling:** CPU hotspots via stack-trace sampling (optional), heap dumps

## What deployment assumptions/constraints are revealed?
- **Deployment context:** Jenkins master and Jenkins nodes (slaves)
- **Access assumptions:** Requires HTTP endpoint access at `/monitoring` (configurable via `monitoring-path` parameter)
- **Security model:** Authentication can be disabled via `-Djavamelody.plugin-authentication-disabled=true` to allow Prometheus scraping or centralized collection servers
- **Agent communication:** Periodic monitoring of slaves requires stable Jenkins remoting; can be disabled if communication is unstable via `-Djavamelody.nodes-monitoring-disabled=true`
- **Storage requirements:** Disk space monitoring needed; RRD files automatically deleted after 3 months to manage storage (configurable via `max-rrd-disk-usage-mb`, default 20MB limit)

## How are CI/CD metrics correlated across services?
- **Job-level correlation:** Build times tracked per job and per build step; statistics aggregated by day/week/month/year
- **Node-level correlation:** Aggregated charts for all nodes (memory, CPU, build times, thread count); individual node reports accessible via `/monitoring/nodes`
- **Time-based aggregation:** Metrics stored in RRD (Round-Robin Database) files with automatic time-series aggregation
- **Request aggregation:** HTTP requests aggregated via regex patterns (e.g., build numbers replaced with wildcards via `http-transform-pattern` parameter)

## What pain points or challenges are mentioned?
- **Disk space exhaustion:** Plugin displays alerts when exceptions occur during data collection (e.g., "No space left on device")
- **RRD file proliferation:** Obsolete RRD files can accumulate; automatic cleanup after 3 months introduced to prevent storage overload
- **Slave communication instability:** Unstable Jenkins remoting can cause monitoring failures; option to disable periodic slave monitoring provided
- **Authentication conflicts:** When Jenkins security enabled, authentication required for monitoring endpoint; conflicts with Prometheus scrapers requiring unauthenticated access
- **Performance overhead:** Real User Monitoring (RUM) adds HTTP call overhead per page; optional and disabled by default

## What observability approaches are avoided or not mentioned?
- **Distributed tracing:** No mention of trace IDs or distributed request tracing across Jenkins/agents
- **Structured logging:** No discussion of structured log formats (JSON, etc.)
- **Service mesh integration:** No Kubernetes service mesh or sidecar proxy patterns
- **OpenTelemetry:** No native OTel instrumentation mentioned (though Prometheus integration added in 1.70.0+)

## Technical specifics
- **Monitoring implementation:** Based on JavaMelody library; uses embedded monitoring filter in Jenkins
- **Metrics export formats:** HTML/PDF reports, Prometheus format (via `/monitoring?format=prometheus`), XML/JSON via External API
- **Storage backend:** RRD files (JRobin library v1.5.9+) for time-series data; serialized `.ser.gz` files auto-deleted after 1 year
- **Integrations:** Can publish metrics to Graphite, InfluxDB, StatsD, AWS CloudWatch, Datadog, Prometheus
- **Customization:** Supports JavaMelody parameters via system properties (e.g., `-Djavamelody.graphite-address=host:port`)
- **Desktop UI:** Optional JavaWebStart-based desktop application for advanced users; requires JRE 1.7+

## Platform/environment
- **Target platforms:** Jenkins (master and agents/slaves)
- **JVM requirements:** Java 1.6+ (Java 9+ support added in 1.73.0)
- **Application servers:** Tomcat-specific features (e.g., Tomcat thread metrics in "Other charts")
- **OS support:** Linux, Windows, Solaris, FreeBSD, AIX, macOS (process list may fail on some platforms)

## Security considerations
- **Authentication bypass:** Plugin provides `-Djavamelody.plugin-authentication-disabled=true` to disable authentication (use with caution)
- **CSRF protection:** Automatically enabled if Jenkins CSRF protection enabled (requires restart); can be explicitly enabled via `-Djavamelody.csrf-protection-enabled=true`
- **Access control:** Recommended to use `allowed-addr-pattern` parameter to restrict monitoring endpoint to specific IPs
- **Vulnerability history:** XXE vulnerability (CVE-2018-15531) fixed in 1.74.0; XSS vulnerabilities fixed in multiple releases (1.60.0, 1.61.0, 1.62.0)