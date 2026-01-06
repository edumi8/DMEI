# Elastic Observability for CI/CD

## Source
**SHORT_KEY:** elastic-observability  
**TITLE:** Elastic Observability for Full-Stack Monitoring  
**LINK:** https://www.elastic.co/observability  
**DATE_ACCESSED:** 2026-01-05

## What observability signals are used?
- **Logs:** Petabytes of logs with instant search; AI-driven log processing via Streams (automatic parsing, partitioning, field extraction)
- **Metrics:** Time-series metrics from infrastructure, applications, and cloud services
- **Traces:** Application performance monitoring (APM) with OpenTelemetry support
- **Synthetic monitoring:** Real user monitoring (RUM) and synthetic testing
- **Continuous profiling:** Profilng data for performance optimization
- **Multi-signal:** Unified platform for logs, metrics, traces, and profiles

## What deployment assumptions/constraints are revealed?
- **OpenTelemetry compliance:** "Fully OTel-compliant"; "pure OTel" without proprietary agents
- **Storage backend:** Elasticsearch as unified storage for all telemetry (structured, unstructured, time-series, vectors)
- **Deployment models:** Elastic Cloud (serverless or hosted), on-premises, or hybrid
- **Data retention:** "Petabytes of structured and unstructured data" with searchable snapshots; historical data "never goes dark"
- **Integrations:** 400+ out-of-the-box integrations for cloud, on-prem, Kubernetes, serverless, hosts
- **Cost optimization:** Data footprint reduction "by up to 65% using Elasticsearch logsdb index mode and TSDB"

## How are CI/CD metrics correlated across services?
- **Unified data model:** All telemetry stored in Elasticsearch; cross-signal correlation via unified search and ES|QL query language
- **AI-driven correlation:** Zero-config anomaly detection and correlation using machine learning
- **Streaming architecture:** Streams automatically organize data into logical streams for correlation
- **Significant Events:** "Automatically highlights 'features' to watch" for proactive monitoring
- **OpenTelemetry integration:** Native support for OTel traces, metrics, logs with "broad language support"

## What pain points or challenges are mentioned?
- **Incident resolution time:** Goal is "Fix problems in seconds, not hours"
- **Alert fatigue:** "Get answers, not just alerts" via AI-driven insights
- **Data volume:** Scaling "petabytes of logs" requires efficient storage and search
- **Cost management:** Emphasis on "store more, spend less" and cost-efficient retention
- **Observability vs. monitoring:** Traditional monitoring focuses on known problems; observability enables exploration of unknown issues

## What observability approaches are avoided or not mentioned?
- **Agent proliferation:** Replaced by unified OpenTelemetry agents and Elastic Agent
- **Sampling for logs:** Logs not sampled; full retention with cost optimization via compression and tiering
- **Proprietary protocols:** Emphasizes open standards (OpenTelemetry, Prometheus, etc.)

## Technical specifics
- **Storage tiers:**
  - Hot tier: Local disk for recent data
  - Frozen tier: Searchable snapshots on object storage (S3, GCS, Azure Blob)
- **Query languages:**
  - ES|QL: Elasticsearch Query Language for ad hoc analysis
  - Discover: Visual log exploration
  - KQL: Kibana Query Language for filtering
- **AI/ML features:**
  - AI Assistant for answering observability questions
  - Agentic AI workflows for root cause analysis
  - Always-on anomaly detection
  - Pattern analysis and categorization
- **APM specifics:**
  - Pure OpenTelemetry support (no proprietary agents)
  - Language-specific APM agents (Java, .NET, Node.js, Python, Ruby, Go, PHP, iOS, Android, RUM JavaScript)
  - Sampling for traces (configurable)
- **Streams (new feature):**
  - AI-driven log organization into logical streams
  - Automatic parsing, partitioning, field extraction
  - Lifecycle policies per stream
  - Significant Events for proactive detection

## Platform/environment
- **Cloud providers:** AWS, Google Cloud, Microsoft Azure (Elastic Cloud Hosted)
- **Kubernetes:** Native Kubernetes support; integrations for pods, nodes, clusters
- **Serverless:** Elastic Cloud Serverless for "hassle-free operations"
- **On-premises:** Download and self-host Elastic Stack
- **Hybrid:** Cross-cloud and hybrid deployments supported

## Security considerations
- **Multi-tenancy:** Tenant isolation in Elastic Cloud
- **Data governance:** Centralized access control and authentication
- **SIEM integration:** Elastic Security for threat detection and response
- **Compliance:** Mentioned in context of data retention policies and governance