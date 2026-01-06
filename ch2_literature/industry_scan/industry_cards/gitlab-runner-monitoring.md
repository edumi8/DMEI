# gitlab-runner-monitoring

## Source

Documentation

## Link

https://docs.gitlab.com/runner/monitoring/

## Platform / Context

GitLab Runner (generic CI/CD platform); on-prem, cloud, or mixed deployments

## Observability Signals Used

Metrics (Prometheus format), pprof endpoints for profiling

## Deployment Assumptions

- HTTP server embedded in GitLab Runner process
- Listens on configurable address (default port 9252)
- Metrics endpoint `/metrics` exposed
- For Kubernetes executor: metrics port can be configured via PodSpec patch
- For Operator-managed runners: pre-configured with `listenAddr` set to `[::]:9252`
- Requires Prometheus or compatible scraper for collection

## Correlation Approach

- Runner identification via external labels in Prometheus config (e.g., `runner_name`)
- For Kubernetes: relabeling using pod metadata (`app.kubernetes.io/name` label)
- Metrics include runner-specific context (runner name, executor type, architecture)
- Job-level correlation via `invocationID` (job ID)

## Pain Points Explicitly Mentioned

- "The metrics server exports data about the internal state of the GitLab Runner process and should not be publicly available!"
- Security concern: metrics endpoint has no authorization
- Requires firewall or HTTP proxy for access control
- Port below 1024 requires root/administrator privileges
- For Operator-managed runners: NetworkPolicies needed to restrict access

## What is Explicitly Avoided

Not stated

## Notes for Later (No Conclusions)

GitLab Runner provides embedded Prometheus metrics covering business logic (jobs running), Go-specific metrics (GC stats), and general process metrics (CPU, memory). Metrics include runner metadata for correlation.
