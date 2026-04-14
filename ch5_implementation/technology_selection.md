# Technology Selection Working Draft

## Scope

This draft evaluates observability technologies for the implementation phase in an on-premise, containerized CI/CD environment with mixed Linux/Windows workers and limited privileges.

## Weighted Criteria

| Criterion | Description                          | Weight |
| --------- | ------------------------------------ | -----: |
| C1        | Environment compatibility            |    30% |
| C2        | Integration fit                      |    20% |
| C3        | Cross-signal correlation support     |    20% |
| C4        | Operational complexity               |    15% |
| C5        | Cost and licensing                   |    10% |
| C6        | Community/documentation maturity     |     5% |

## Areas

There are three core areas to evaluate: metrics, logs, and tracing. Each area will be assessed against the weighted criteria to determine the most suitable technology for the implementation phase. A visualization tool will also be selected.

## Research Questions

1. Which metrics stack best fits the constraints of an on-premise CI/CD environment with mixed Linux/Windows workers?
2. Which logging stack provides the best balance between operational effort and troubleshooting effectiveness?
3. Which tracing stack offers the best interoperability with the selected instrumentation approach?
4. Which visualization platform provides the strongest cross-signal correlation for operations and incident analysis?

## Initial Candidate Set (To Validate)

- Metrics/alerting: Prometheus + Alertmanager
- Logs: Loki, ELK Stack
- Tracing: Tempo, Jaeger
- Visualization: Grafana, Kibana
- Instrumentation/collection baseline: OpenTelemetry SDK/Collector

## Evaluation Method

1. Define one evaluation sheet per area (metrics, logs, tracing, visualization).
2. Score each candidate on C1..C6 using a 1-5 scale.
3. Compute weighted score:

   $$
   S = \sum_{i=1}^{6} w_i \cdot s_i
   $$

   where $w_i$ is the criterion weight and $s_i$ is the candidate score.

4. Record evidence for each score (documentation link, experiment note, or deployment observation).
5. Rank candidates by weighted score and document trade-offs.

## Scoring Rubric (1-5)

- 1: Poor fit
- 2: Weak fit
- 3: Acceptable fit
- 4: Strong fit
- 5: Excellent fit

## Evidence Log Template

| Area | Candidate | Criterion | Score | Evidence source | Notes |
| ---- | --------- | --------- | ----: | --------------- | ----- |
| Logs | Loki      | C4        |       |                 |       |

## First Week Plan

1. Finalize candidate list per area.
2. Create one test scenario for each area:
   - Metrics: scrape + alert test
   - Logs: centralized collection + query test
   - Tracing: end-to-end request trace test
   - Visualization: dashboard + correlation test
3. Run minimal proof-of-concept deployments.
4. Fill evidence log entries from observed results.
5. Produce first scoring pass (draft, not final).

## Deliverables for Phase 1

- Completed evaluation sheets for each area.
- Evidence log with references.
- Draft ranking table with explicit assumptions.
- Decision note identifying uncertainties and next validation steps.
