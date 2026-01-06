# correiaMonintainerOrchestrationindependentExtensible2023

## Problem addressed
Container-based systems present new monitoring challenges due to their automated flexibility, ephemerality, and increasing number of containers. Existing tools target specific orchestration platforms and lack comprehensive coverage of machine, container, and application metrics without requiring multiple distinct tools.

## Observability mechanism
- Multi-layer monitoring: node (physical/virtual), container, and application/service levels
- Hierarchical data collection using node monitors, core services (cAdvisor, Powerjoular), and container agents
- Metrics include CPU, memory, disk, network, energy consumption (via RAPL), and application-specific metrics (web servers, databases, IoT brokers)
- REST API for configuration management and metric exposure in Prometheus format

## Privilege assumptions
Host-based access required to deploy node monitors on each physical/virtual node. Access to cgroups for container-level metrics. RAPL requires privileged access for energy consumption measurements at CPU level.

## Application code modification
Yes. Container agents must be deployed inside containers to monitor applications. Agents may be wrappers for application logs or programs intercepting application traffic/data. One agent per application required if multiple applications run in a single container.

## Telemetry signals
Metrics (time-series data). Infrastructure metrics: CPU, memory, disk, GPU usage/temperature, energy consumption, up-time, container/process counts. Container metrics: resource usage, limits, network packets, threads/processes. Application metrics: connections, requests, response times, query counts (databases), messages/topics (IoT brokers).

## Collection pattern
Hybrid push model. Container agents push data to node monitors. Node monitors aggregate data from core services (pull) and container agents (push), then push aggregated data to integration layer (REST API) for storage. Exposes metrics in Prometheus format for external visualization tools.

## Evaluation performed
Compared Monintainer to Docker-stats, cAdvisor, Prometheus, ConMon, Sysdig, Instana, Datadog, Dynatrace, Sensu. Highlighted that commercial tools (Sysdig, Instana, Datadog, Dynatrace, Sensu) offer automatic service discovery but are not testable. Monintainer designed for orchestration-independence (Kubernetes, Docker Swarm, Apache Mesos, Docker) and extensibility via custom metrics.

## Overhead reported
Casalicchio et al. stated overhead of cAdvisor, Prometheus, Grafana is negligible in terms of CPU utilization. Monintainer overhead not explicitly quantified, but core services like cAdvisor and Powerjoular have known low footprints. Focus on scalability through horizontal scaling and modular components.

## Constraints discussed by authors
Requires node-level deployment and host access for comprehensive monitoring. Container agents must be embedded in containers, adding deployment complexity. RAPL-based energy measurement limited to Intel CPUs. Assumes one agent per application, which may increase container image sizes. External hardware devices (e.g., Yocto-Watt) for energy measurement are accurate but cannot isolate container-level consumption.

## Fit or break under constrained CI/CD
- Requires host-level access and privileged operations (cgroups, RAPL) likely unavailable in restricted CI/CD environments.
- Container agents must be embedded in application containers, requiring image modification and increasing build complexity in CI/CD pipelines.
- Modular architecture supports horizontal scaling but adds infrastructure overhead (REST API, distributed database, load balancers) impractical for ephemeral CI/CD workloads.
- Orchestration-independence is beneficial for diverse CI/CD platforms, but deployment complexity (node monitors, core services, agents per container) may exceed CI/CD resource budgets.
