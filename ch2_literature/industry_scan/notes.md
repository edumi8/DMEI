# Industry Scan Notes

Private synthesis notes (not for thesis text).

## Comprehensive Synthesis (All 10 Cards)

### Observability Signals Used

#### Metrics (Universal)
- **Prometheus format:** GitLab Runner (port 9252), Jenkins Prometheus Plugin, Grafana/Prometheus integration
- **Application metrics:** Response times, throughput, error rates (Jenkins JavaMelody, Elastic APM)
- **Infrastructure metrics:** CPU, memory, disk, network (all platforms)
- **Time-series storage:** RRD files (Jenkins), TSDB (Elastic, Prometheus), Mimir (Grafana)
- **Custom metrics:** Build queue length (Jenkins), concurrent jobs (GitLab), transaction latency (APM)

#### Logs (Universal, different strategies)
- **Label-only indexing:** Grafana Loki (explicit anti-pattern: no full-text indexing)
- **Full-text search:** Elastic ELK Stack (Elasticsearch-based)
- **AI-driven processing:** Elastic Streams (automatic parsing, partitioning, field extraction)
- **Structured logs:** Correlation via trace IDs, job IDs, timestamps

#### Traces (APM-focused)
- **OpenTelemetry standard:** Elastic APM, OpenTelemetry Collector, Grafana Tempo
- **W3C Trace Context:** For cross-service correlation (Elastic APM)
- **Distributed tracing:** Request flows across microservices
- **OTLP protocol:** Vendor-agnostic telemetry exchange

#### Profiling (Less common)
- **CPU profiling:** pprof endpoints (GitLab Runner), sampling (Jenkins JavaMelody)
- **Memory profiling:** Heap dumps (Jenkins), heap histograms (Jenkins)
- **Continuous profiling:** Elastic Universal Profiling

### Deployment Constraints/Assumptions

#### Container/Kubernetes Dominance
- **Kubernetes-native:** GitLab Runner (PodMonitor), OpenTelemetry Operator, Elastic Cloud on Kubernetes, Grafana Loki
- **Docker support:** All platforms support containerized deployments
- **Cloud platforms:** AWS, GCP, Azure mentioned across all Elastic and Grafana solutions

#### Agent Deployment Patterns
- **Local agent:** OpenTelemetry Collector (agent mode), Beats (per-host), Elastic Agent, Prometheus scraping
- **Gateway/centralized:** OpenTelemetry Collector (gateway mode), Logstash (centralized processing)
- **No agent:** Direct export to backends (OpenTelemetry, Jenkins Prometheus scraping)
- **Unified agent trend:** Elastic Agent replacing multiple Beats; OpenTelemetry replacing proprietary agents

#### Authentication & Access Control
- **Security warnings:** GitLab Runner metrics "should not be publicly available"
- **Authentication bypass:** Jenkins JavaMelody `-Djavamelody.plugin-authentication-disabled=true` (pain point for Prometheus scraping)
- **RBAC:** Grafana Enterprise, Elastic Cloud multi-tenancy
- **API keys/tokens:** Elastic APM, GitLab CI variables

#### Storage Assumptions
- **Object storage:** Grafana Loki (S3, GCS), Elastic (searchable snapshots on S3/GCS/Azure Blob)
- **Centralized storage:** Elasticsearch for ELK Stack, Prometheus TSDB
- **Tiered storage:** Hot/warm/cold/frozen (Elastic), cost optimization via compression
- **Petabyte scale:** Elastic emphasizes massive data volumes

### Correlation Patterns

#### Label-Based Correlation (Prometheus Style)
- **GitLab Runner:** `runner_name`, `job`, `stage` labels
- **Prometheus:** PromQL queries with label selectors
- **Grafana Loki:** LogQL with label-only indexing (similar to Prometheus)
- **OpenTelemetry:** Resource attributes and span attributes

#### Trace ID Propagation
- **W3C Trace Context:** Standard for cross-service correlation (Elastic APM)
- **OTLP:** OpenTelemetry Protocol for trace/metric/log correlation
- **Log-trace correlation:** Logs enriched with trace IDs (Elastic APM, OpenTelemetry)

#### Job/Build Metadata
- **GitLab:** `CI_CONCURRENT_ID`, job metadata, SLSA invocationID
- **Jenkins:** Build queue metadata, job names, build numbers

#### Unified Storage Correlation
- **Elastic Stack:** All data (logs, metrics, traces) in Elasticsearch; correlation via ES|QL queries
- **Grafana LGTM+:** Loki (logs), Grafana (viz), Tempo (traces), Mimir (metrics) with label-based correlation
- **OpenTelemetry Collector:** Multi-signal pipeline (receivers → processors → exporters) with connectors

#### Timestamp-Based Correlation
- **Time-series alignment:** Common across all platforms for correlating events
- **Retention policies:** Time-based data lifecycle (hot → warm → cold → frozen)

### Recurring Pain Points

#### Scaling Complexity
- **Prometheus/Grafana:** "DIY style of scaling...complex and requires a lot of effort to maintain throughout different teams"
- **Grafana Loki:** "Scaling and securing your logs" (webinar topic)
- **Elastic:** Petabyte scale requires tiered storage, cost management

#### Configuration Overhead
- **Logstash pipelines:** Require expertise for complex transformations
- **Jenkins JavaMelody:** RRD file proliferation, disk space exhaustion alerts
- **GitLab Runner:** Shallow cloning failures, git describe issues, token cloning attacks
- **OpenTelemetry Collector:** "Reasonable default configuration" and "security best practices" emphasized

#### Cost Management
- **Data volume:** Elastic logsdb (65% data reduction), Grafana searchable snapshots
- **Retention policies:** Balance between cost and data availability
- **Storage optimization:** Compression (Grafana Loki), object storage (S3/GCS)

#### Security & Access Control
- **GitLab Runner:** Metrics endpoints security warnings, token rotation
- **Jenkins:** XXE vulnerability (CVE-2018-15531), XSS, authentication bypass conflicts
- **Access control:** Prometheus "all-or-nothing access to metrics" in DIY setup

#### Agent Management
- **Multiple agents:** OpenTelemetry Collector addresses "need to run, operate, and maintain multiple agents/collectors"
- **Elastic Agent:** Unified agent to replace multiple Beats
- **Configuration drift:** Managing agent configurations across distributed environments

#### Observability Overhead
- **Sampling required:** Elastic APM, OpenTelemetry (to manage data volume and agent overhead)
- **Retry and batching:** Services need to "offload data quickly" (OpenTelemetry Collector)
- **Performance impact:** Jenkins cloud storage scanning warning

### What is Commonly Avoided

#### Full-Text Indexing (Selective)
- **Grafana Loki:** "Unlike other logging systems, Loki is built around the idea of only indexing metadata about your logs' labels" (explicit anti-pattern)
- **Elastic ELK:** Full-text indexing is core feature (opposite approach)

#### Proprietary Instrumentation
- **OpenTelemetry adoption:** Elastic APM "production-grade pure OTel", OpenTelemetry Collector "vendor-agnostic"
- **Unified agents:** Elastic Agent, OpenTelemetry replacing proprietary agents

#### Push-Based Collection (Limited)
- **Prometheus/Jenkins:** Pull-based scraping model only; no push to Pushgateway mentioned
- **OpenTelemetry Collector:** Receiver-based (supports both pull and push)

#### Embedded Agents
- **External deployment:** Beats, Elastic Agent, OpenTelemetry Collector deployed separately
- **Exception:** GitLab Runner metrics via embedded HTTP server

#### Sampling for Logs (Controversial)
- **Grafana Loki:** No log sampling; full retention with label-only indexing
- **Elastic ELK:** No log sampling; full retention with cost optimization via tiered storage
- **Elastic APM:** Sampling for traces (high volume) but not logs

#### Real-Time Streaming (De-emphasized)
- **Elastic ELK:** Focus on batch ingestion via Beats/Logstash; real-time streaming less emphasized
- **Focus on search:** Emphasis on searchable historical data over real-time streaming

---

## Key Themes Across All 10 Cards

1. **OpenTelemetry Standardization:** Strong industry trend toward OTel for vendor-agnostic observability (Elastic, OpenTelemetry Collector, Grafana Tempo)

2. **Unified Platforms:** Move from point solutions to unified platforms (Elastic Observability, Grafana LGTM+, OpenTelemetry Collector)

3. **Kubernetes-Native:** All platforms assume Kubernetes deployments with operators, Helm charts, PodMonitors

4. **Label/Metadata-Based Correlation:** Prometheus-style labels, W3C Trace Context, OTLP as universal correlation strategies

5. **Scaling Pain Points:** DIY scaling complexity, cost management, configuration overhead are universal challenges

6. **Agent Consolidation:** Industry moving from multiple proprietary agents to unified OpenTelemetry agents

7. **Storage Tiering:** Object storage (S3/GCS) for cost-effective long-term retention (Grafana Loki, Elastic searchable snapshots)

8. **AI-Driven Observability:** Emerging trend (Elastic Streams, AI Assistant, anomaly detection)

9. **Security Trade-offs:** Tension between open metrics access and authentication requirements (Jenkins, GitLab, Prometheus)

10. **Sampling Necessity:** High-volume environments require sampling for traces but avoid it for logs

---

## CI/CD-Specific Observations (Round 2: 5 Cards)

**Primary Finding: Logs dominate pipeline debugging; distributed tracing absent from CI/CD troubleshooting.**

1. **Logs as Primary Signal (5/5 cards):** Every CI/CD debugging source mentions logs first and most frequently. GitLab emphasizes "job logs" in job detail pages; GitHub Actions explicitly states "using workflow run logs" as first troubleshooting step; Jenkins focuses on console logs. Logs are not one signal among many—they are THE signal for CI/CD debugging.

2. **Job-Centric Correlation (5/5 cards):** CI/CD observability correlates via job/pipeline metadata (job ID, status, pipeline graph position) rather than distributed tracing. Job boundaries define observability scope. No trace IDs mentioned across any CI/CD debugging documentation.

3. **Distributed Tracing Absent (5/5 cards):** Not a single card mentions distributed tracing, span IDs, or trace propagation in CI/CD debugging context. This contrasts sharply with infrastructure observability (Round 1) where tracing was prominent (Elastic APM, OpenTelemetry, Grafana Tempo).

4. **Incident-Driven Observability (5/5 cards):** All sources emphasize reactive troubleshooting after failures (job failed, pipeline stuck, unexpected execution). No proactive monitoring or continuous profiling mentioned. Retry/rerun mechanisms serve as debugging tools (GitLab retry creates new job ID, GitHub Actions re-run failed jobs).

5. **Platform UI as Primary Interface (5/5 cards):** Job detail pages, pipeline graphs, and visual inspection are emphasized over programmatic access. GitLab pipeline graph shows job dependencies with hover-over status; GitHub Actions workflow visualization; Jenkins build history review. Debugging happens in web UI, not via APIs or CLI tools.

6. **Metrics Only for Slowness (confirmed):** Metrics appear only for performance analysis (long-running stages, build queue times), not for debugging failures. GitLab Duo Root Cause Analysis mentions "job duration" but not as primary signal. Metrics are supplementary, not central.

7. **Humans as Correlation Engines (5/5 cards):** Manual inspection emphasized across all cards. GitLab troubleshooting requires visual inspection of job logs and manual testing; GitHub Actions debugging relies on human review of workflow run logs; Jenkins best practices emphasize manual build history analysis. Automated correlation tools absent.

8. **AI-Driven Troubleshooting (emerging, 4/5 cards):** GitLab Duo Root Cause Analysis (mentioned in 3 cards) and GitHub Copilot "Explain error" (1 card) represent emerging AI-driven debugging. GitLab Duo analyzes job logs and pipeline configuration to suggest fixes. This is distinct from infrastructure AI (Elastic anomaly detection) which focuses on metrics/traces.

9. **Ephemeral Job Visibility Pain (5/5 cards):** Consistent pain points around ephemeral nature of CI/CD: GitLab job cancellation delays, GitHub Actions scheduled delays (high load at hour start), Jenkins workspace conflicts, job naming restrictions. Observability challenges stem from short-lived job lifecycles (seconds to minutes).

10. **Configuration-as-Observability (5/5 cards):** CI/CD configuration files (.gitlab-ci.yml, GitHub Actions workflow YAML, Jenkinsfile) serve as observability artifacts. Debugging involves inspecting configuration syntax, variable expressions, and pipeline structure. Configuration is both code and telemetry source.
