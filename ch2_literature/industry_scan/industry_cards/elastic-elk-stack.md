# Elastic Stack (ELK) for Observability

## Source
**SHORT_KEY:** elastic-elk  
**TITLE:** Elastic Stack (Elasticsearch, Logstash, Kibana, Beats)  
**LINK:** https://www.elastic.co/what-is/elk-stack  
**DATE_ACCESSED:** 2026-01-05

## What observability signals are used?
- **Logs:** Application logs, system logs, security logs via Logstash and Beats
- **Metrics:** Infrastructure metrics, application metrics via Metricbeat and APM
- **Traces:** Distributed traces via APM Server and Elastic APM agents
- **Uptime:** Synthetic monitoring and uptime checks via Heartbeat
- **Network data:** Network packet analysis via Packetbeat
- **File system data:** File integrity monitoring via Auditbeat

## What deployment assumptions/constraints are revealed?
- **Centralized storage:** Elasticsearch as central datastore for all telemetry
- **Ingestion pipeline:** Data flows through Beats/Logstash → Elasticsearch → Kibana (ELK pipeline)
- **Beats as lightweight shippers:** "Lightweight data shippers" deployed on monitored hosts
- **Logstash for transformation:** Heavy-weight data processing, enrichment, and transformation
- **Kibana as UI:** Single UI for visualization, exploration, and management
- **Elastic Agent:** Unified agent replacing individual Beats for simplified deployment
- **Integrations:** 200+ pre-built integrations for rapid setup

## How are CI/CD metrics correlated across services?
- **Common data model:** All data indexed in Elasticsearch with shared schema
- **Correlation via fields:** Correlation by common fields (host, service, trace ID, etc.)
- **Cross-solution correlation:** Logs, metrics, traces, and uptime data queryable together in Kibana
- **Kibana dashboards:** Pre-built and custom dashboards for multi-signal correlation
- **Machine learning:** Auto-correlation of anomalies across signals

## What pain points or challenges are mentioned?
- **Data volume:** "Petabytes of data" requires scalable storage and search
- **Configuration complexity:** Logstash pipelines require expertise for complex transformations
- **Agent management:** Multiple Beats required different management; Elastic Agent simplifies
- **Storage cost:** Addressed via tiered storage (hot, warm, cold, frozen) and searchable snapshots

## What observability approaches are avoided or not mentioned?
- **Real-time streaming:** Focus on batch ingestion via Beats/Logstash; real-time streaming less emphasized
- **Push-based metrics:** Primarily pull-based (Metricbeat scraping); Prometheus remote write supported
- **Embedded agents:** Agents deployed externally, not embedded in applications

## Technical specifics
- **Core components:**
  - **Elasticsearch:** Distributed search and analytics engine (Apache Lucene-based)
  - **Kibana:** Visualization and exploration UI
  - **Logstash:** Data processing pipeline (input → filter → output)
  - **Beats:** Lightweight data shippers (Filebeat, Metricbeat, Packetbeat, Auditbeat, Heartbeat, Winlogbeat, Functionbeat)
  - **Elastic Agent:** Unified agent for logs, metrics, and security data
- **Data ingestion:**
  - Beats: Lightweight agents for specific data types
  - Logstash: Heavy-weight processing for complex transformations
  - Elastic Agent: Unified agent with policy-based configuration
  - APIs: Direct ingestion via REST API
  - Web crawler: For public content sources
- **Storage tiers:**
  - Hot tier: SSD/NVMe for recent, frequently accessed data
  - Warm tier: Slower disks for less frequently accessed data
  - Cold tier: Object storage (S3, GCS, Azure Blob) for archival
  - Frozen tier: Searchable snapshots on object storage
- **Visualization:**
  - Discover: Ad hoc log exploration
  - Dashboards: Pre-built and custom visualizations
  - Canvas: Infographic-style dashboards
  - Maps: Geospatial visualization

## Platform/environment
- **Deployment models:**
  - Elastic Cloud Serverless: Fully managed, autoscaling
  - Elastic Cloud Hosted: Managed on AWS, GCP, Azure
  - Self-managed: On-premises or self-hosted cloud
- **Supported OSes:** Linux, Windows, macOS
- **Containers:** Docker, Kubernetes (via Helm charts and Elastic Cloud on Kubernetes operator)
- **Cloud providers:** AWS, Google Cloud, Microsoft Azure

## Security considerations
- **SIEM:** Elastic Security for threat detection, SIEM, and endpoint security
- **Encryption:** TLS/HTTPS for data in transit; encryption at rest for Elasticsearch indices
- **Access control:** Role-based access control (RBAC) for users and API keys
- **Audit logging:** Audit logs for compliance and forensics
- **Data anonymization:** Field-level security and data masking