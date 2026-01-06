# dingaEmpiricalEvaluationEnergy2023

## Problem addressed
This study identifies, synthesizes, and empirically evaluates the energy and performance overhead of monitoring tools employed in the microservices and DevOps context. Continuous monitoring tools running alongside microservices contribute to overall energy consumed by Docker-based systems.

## Observability mechanism
- Four monitoring tools evaluated: ELK Stack (Metricbeat), Netdata, Prometheus (cAdvisor), Zipkin (distributed tracing with Java Sleuth)
- Metric collection at container level via cgroups (no code instrumentation)
- Frequency/sampling intervals: high (1s/100%), medium (5s/50%), low (10s/25%)
- Metrics: CPU, RAM, network traffic, execution time

## Privilege assumptions
Host-based access required. Metricbeat, Netdata, and cAdvisor deployed on host and discover/monitor all Docker containers via cgroups. Zipkin requires application-level integration (Java Sleuth library) but no manual instrumentation.

## Application code modification
No for metric-based tools (ELK/Metricbeat, Netdata, Prometheus/cAdvisor). Yes for Zipkin: requires integration with Java Sleuth library and probabilistic sampling configuration at application level, though described as avoiding code instrumentation.

## Telemetry signals
Metrics (ELK Stack, Netdata, Prometheus): CPU usage, memory, network I/O, execution time collected via cgroups at 1/5/10s intervals. Traces (Zipkin): distributed tracing with probabilistic sampling (25%/50%/100%). Energy measured at machine level via Watts Up Pro power meter.

## Collection pattern
Host-based collection. Metricbeat, Netdata agent, and cAdvisor deployed on host, monitor containers via cgroups, push/expose metrics to centralized DBs (Elasticsearch, Prometheus TSDB). Zipkin: traces pushed from application to Zipkin server. SAR utility used for performance metrics at 1s intervals.

## Evaluation performed
Controlled experiment on TrainTicket benchmark (41 microservices, 24 business logic). Full factorial design: 5 tools (4 + baseline) × 3 frequencies × 3 workloads = 39 trials × 10 runs = 390 runs over 7 days. Workloads: 10/20/40 virtual users. Machine-level energy measured with Watts Up Pro. Statistical analysis: Kruskal-Wallis, Wilcoxon, Dunn tests.

## Overhead reported
Energy: Baseline 53,755J, Netdata 54,543J (+1.5%), Prometheus 55,046J (+2.4%), ELK 56,760J (+5.6%), Zipkin 60,668J (+12.9%). RAM: ELK 99.2% (very high footprint), Baseline 65.1%. CPU: Zipkin highest at 57.6% vs baseline. Significant differences under 6 of 9 frequency/workload conditions. Large effect size (η²) for high workload scenarios.

## Constraints discussed by authors
Study limited to Docker containers to separate platform effects from tool effects. Requires physical power meter (Watts Up Pro) for accurate energy measurement at machine level. Cannot isolate container-level energy consumption. Tools compete for same hardware resources as monitored microservices. High workload exacerbates differences between tools.

## Fit or break under constrained CI/CD
- Host-based deployment requires privileged access to cgroups and Docker daemon, likely unavailable in restricted CI/CD environments.
- ELK Stack's 99.2% RAM usage would exhaust memory in resource-constrained CI/CD containers, causing failures.
- High energy overhead (up to 12.9% for Zipkin) and performance impact unacceptable for ephemeral CI/CD workloads optimizing for speed.
- Physical power meter setup impractical for CI/CD; software-based energy estimation (RAPL) would be needed but less accurate.
