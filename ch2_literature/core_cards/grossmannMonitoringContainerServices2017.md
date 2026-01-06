# grossmannMonitoringContainerServices2017

## Problem addressed
Spreading containers at small scale (single board computers/SBCs) needs proper allocation of resources. Existing container monitoring solutions like Google's cAdvisor and Prometheus utilize too many resources to be feasible for SBC monitoring at network edge.

## Observability mechanism
- PyMon: lightweight multi-architecture monitoring framework for SBCs
- Monit extended with API to inspect Docker containers via Docker socket
- Collects container statistics (CPU usage, memory) and host metrics (CPU, memory, network traffic)
- Django application aggregates data from monitored hosts
- Web interface with graphs and tabular overviews

## Privilege assumptions
Privileged container required. Monit must run as privileged container to access Docker socket for inspecting running containers on host system.

## Application code modification
No. PyMon wraps monit (host-based monitoring tool) with Docker container inspection capabilities. No application instrumentation needed; monitoring operates externally via Docker socket.

## Telemetry signals
Metrics collected via Docker streaming API: CPU usage (percentage calculated from active CPU time), memory usage (bytes), container state/status. Host metrics: CPU, memory, network traffic. Data stored in Postgres DB for 7 days. Reports in monit XML format pushed to Caddy HTTP server.

## Collection pattern
Push-based model. Monit instances on each monitored host use threads to process container statistic streams in parallel. Monit pushes XML reports to Caddy HTTP server, which forwards to PyMon Django application. PyMon stores data in Postgres database.

## Evaluation performed
Compared resource usage of Kubernetes vs Docker Swarm on Raspberry Pi cluster (4 RPi nodes: 3 workers + 1 master). Measured idle state CPU and memory consumption. Hardware: RPi with 16GB SD cards, 1Gbit/s network. PyMon deployed on Pine64+ AARCH64 SBC. Focus on lightweight monitoring footprint for edge/fog clusters.

## Overhead reported
PyMon designed for small footprint on SBCs; no specific overhead numbers reported. Evaluation shows: Docker Swarm uses less CPU/memory than Kubernetes. Kubernetes idle: ~30% CPU at master, ~10% at workers. Docker Swarm lower in both cases. Memory: Kubernetes requires more than Docker Swarm.

## Constraints discussed by authors
Designed for SBC/ARM platforms with limited resources; full-featured tools (cAdvisor + Prometheus) too resource-intensive. Requires privileged container for Docker socket access. Data retention limited to 7 days due to storage constraints. Kubernetes more feature-rich but higher resource footprint than Docker Swarm, limiting feasibility for edge clusters.

## Fit or break under constrained CI/CD
- Privileged container requirement for Docker socket access likely blocked in restricted CI/CD security policies.
- Designed for persistent edge monitoring (7-day data retention), not ephemeral CI/CD workloads that start/stop frequently.
- Push-based architecture with centralized Postgres DB and Django server adds infrastructure overhead impractical for lightweight CI/CD pipelines.
- SBC/ARM focus makes it unsuitable for typical x86_64 CI/CD runners, though multi-architecture support (x86_64, ARM, AARCH64) provides flexibility.
