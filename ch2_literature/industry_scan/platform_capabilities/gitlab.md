# GitLab SCM

## Native observability signals
- Metrics: GitLab exposes Prometheus metrics through multiple exporters for its components. The main GitLab Rails application exposes metrics at the `/-/metrics` endpoint which requires authentication. GitLab includes bundled exporters: node_exporter (machine resources), Redis exporter, PostgreSQL exporter, PgBouncer exporter, Registry exporter, GitLab exporter (GitLab-specific metrics from Redis and database), and web exporter (dedicated metrics server for splitting traffic).
- Logs: GitLab components generate logs accessible through standard logging mechanisms. Log output includes correlation IDs for distributed request tracking across GitLab subsystems (Rails, Workhorse, Gitaly, Sidekiq).
- Traces: GitLab supports distributed tracing through Jaeger using correlation IDs. Tracing is configured via the `GITLAB_TRACING` environment variable with format `opentracing://jaeger?<params>`. GitLab provides pre-implemented instrumentations for common operations. GitLab distributed tracing is described as "currently considered experimental, as it has not yet been tested at scale on GitLab.com."

## Export mechanisms
- Metrics export: Prometheus metrics are exposed on HTTP endpoints. Each exporter listens on a specific port (e.g., node_exporter on 9100, Rails metrics on /-/metrics, gitlab_exporter on 9168, Redis exporter on 9121, PostgreSQL exporter on 9187, Gitaly on 9236). GitLab supports both bundled Prometheus server and external Prometheus server configurations. Metrics endpoints can be configured to listen on specific network addresses.
- Logs access: Logs available through standard filesystem and process output. Correlation IDs included in log output for cross-component tracing.
- Traces export: Distributed tracing configured via `GITLAB_TRACING` environment variable. Traces sent to Jaeger backend using HTTP endpoint (default: http://localhost:14268/api/traces) or UDP endpoint (localhost:6831 using compact thrift protocol, though documented as having "some issues with the Jaeger Client for Ruby").

## OpenTelemetry support
Not stated

## Deployment assumptions
- Linux package (omnibus) installation model with bundled Prometheus and exporters
- Components run as separate processes: Rails (Puma), Sidekiq, Workhorse, Gitaly, PostgreSQL, Redis, Registry
- Expects ability to configure process-level environment variables (`GITLAB_TRACING`)
- Configuration via `/etc/gitlab/gitlab.rb` followed by `gitlab-ctl reconfigure`
- Network-accessible ports for metrics exporters
- GitLab Runner: Embedded Prometheus metrics server preconfigured on port 9252, supports Kubernetes and non-Kubernetes deployments

## Configuration surface
- Environment variables: `GITLAB_TRACING`, `GITLAB_TRACING_TRACK_CACHES`, `GITLAB_TRACING_TRACK_REDIS`
- Configuration files: `/etc/gitlab/gitlab.rb` for omnibus installations
- Prometheus configuration: `prometheus['listen_address']`, `prometheus['scrape_configs']`, `prometheus['flags']` (storage retention)
- Exporter listen addresses configurable per component (node_exporter, gitlab_workhorse, gitlab_exporter, redis_exporter, postgres_exporter, etc.)
- GitLab Runner: `listen_address` configuration option in `config.toml` or `--listen-address` command line flag

## Security considerations
- Warning: "Prometheus and its exporters don't authenticate users, and are available to anyone who can access them."
- Warning: "Prometheus and most exporters don't support authentication. We don't recommend exposing them outside the local network."
- Metrics endpoints require firewall configuration or IP allowlist (`gitlab_rails['monitoring_whitelist']`) when using external Prometheus
- Rails `/-/metrics` endpoint requires authentication
- GitLab Runner metrics: "The metrics server exports data about the internal state of the GitLab Runner process and should not be publicly available!"
- Documentation recommends using NetworkPolicies in Kubernetes and considering mutual TLS for production environments

## Explicit limitations stated
- "Distributed tracing is currently considered experimental, as it has not yet been tested at scale on GitLab.com."
- "Distributed tracing adds minimal overhead when disabled, but imposes only small overhead when enabled"
- "At this time, this functionality is experimental, and not supported in production environments at present. In this first release, it is intended to be used for debugging in development environments only."
- Correlation IDs: "Some user facing systems don't generate correlation IDs in response to user requests (for example, Git pushes over SSH)."
- UDP endpoint for Jaeger: "We've experienced some issues with the Jaeger Client for Ruby when using this protocol."

## Notes (factual only)
- GitLab uses correlation IDs for distributed request tracking across components
- Correlation IDs are "always optional" and "always free text"
- The LabKit library provides standardized interface for working with correlation IDs in Go
- Prometheus services are "on by default" in GitLab installations
- Default Prometheus port is 9090; Runner metrics default to 9252
- GitLab provides sample Prometheus queries for CPU utilization, memory, disk I/O, and RPS
- Jaeger can be integrated with GitLab Development Kit
- GitLab supports Grafana integration for Prometheus data visualization
- GitLab Runner supports both Kubernetes operator deployment and standalone deployment models

## Sources

- GitLab Documentation - Monitoring GitLab with Prometheus: <https://docs.gitlab.com/ee/administration/monitoring/prometheus/>
- GitLab Documentation - GitLab Runner Monitoring: <https://docs.gitlab.com/runner/monitoring/>
- GitLab Documentation - Operations (Monitoring): <https://docs.gitlab.com/ee/operations/>
- GitLab Documentation - Distributed Tracing Development Guidelines: <https://docs.gitlab.com/ee/development/distributed_tracing/>
