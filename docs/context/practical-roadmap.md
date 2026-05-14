# Practical roadmap (no writing) — connectivity, correlation, views, alerts

Order is intentional: **ingest and reach services first**, then **tie signals together**, then **make them explorable**, then **alert on what you trust**.

---

## 1. System connection (beyond Jenkins)

**Goal:** Same observability stack sees **at least one non-Jenkins** path (GitLab runner, GitHub Actions self-hosted, or another tool from your inventory).

- [ ] **Pick one second platform** for the first slice (e.g. GitLab CI on a runner you control, or a second orchestration path you can instrument without policy drama).
- [ ] **Network reachability:** from collectors / Prometheus scrape targets / OTel receivers to that platform’s metrics and logs (firewall, DNS, TLS if any).
- [ ] **Metrics:** expose or scrape something useful (runner/agent metrics, application `/metrics`, or Node Exporter on the runner host if allowed).
- [ ] **Logs:** ship runner/job logs to Loki (agent or Docker logging driver / Promtail or OTLP logs—whatever matches your design).
- [ ] **Traces (optional first pass):** OTLP from one instrumented job or side service into the Collector → Tempo.
- [ ] **Document in runbook:** hostnames (redacted), ports, compose service names, **who to call** if the path breaks.

*Done when:* you can prove in Grafana that a job/run from **non-Jenkins** produced metrics and/or logs in the same stack as Jenkins.

---

## 2. Correlation

**Goal:** Move from three silos to **one diagnosis habit** (time + service + run identity).

- [ ] **Stable labels:** agree a minimal set (`service`, `environment`, `job` / `pipeline`, `instance` or runner id, `build_id` / `pipeline_id` where available).
- [ ] **Same IDs everywhere:** inject the same correlation id into logs and trace attributes (CI env vars → log format → OTel resource attributes).
- [ ] **Grafana data sources:** Prometheus, Loki, Tempo linked; Tempo **trace to logs** / **trace to metrics** (or Explore workflows you actually use).
- [ ] **Time alignment:** single timezone / clock sync awareness; note scrape interval vs log batch delay in the runbook.
- [ ] **Two scripted drills:** e.g. “find this failed run” starting from (a) a metric spike, (b) a log line—each should reach the other signal in **N steps** (define N yourself).

*Done when:* one drill works for **Jenkins** and one for the **second platform** (or two different non-Jenkins paths if Jenkins is deferred).

---

## 3. Views (dashboards / Explore)

**Goal:** **Operator-usable** screens, not demo panels.

- [ ] **Folder + naming** in Grafana (`CI/CD`, `Runners`, `Infra`) so dashboards do not sprawl.
- [ ] **Golden signals per tier:** runner health, queue/backlog, job duration, error rate, resource saturation (pick what matches your environment).
- [ ] **Saved Explore queries** (or dashboard links) for the two correlation drills above.
- [ ] **Variables** (dropdown) for `environment`, `service`, `runner`/`job` where it saves time.
- [ ] **Screenshot / short Loom** for future-you (optional): how to open the view in 30 seconds.

*Done when:* someone other than you can open Grafana and answer “is the pipeline sick?” without SSH.

---

## 4. Alerts

**Goal:** **Few, loud, actionable** rules—noise kills trust.

- [ ] **Inventory noise:** run current metrics/logs for a week (or shorter if rushed) **without** paging anyone; tune baselines.
- [ ] **Start with SLO-shaped alerts:** job failures, runner offline, disk pressure, scrape failures, collector backlog (pick **≤ 5** to begin).
- [ ] **Routing:** who gets notified (mail/Slack/Teams); **runbook link** in the annotation (even a one-paragraph doc).
- [ ] **Test each alert:** fire intentionally in staging; confirm notification + dashboard jump works.
- [ ] **Freeze v1:** tag compose + configs in git when alert set is “good enough for evaluation.”

*Done when:* every firing alert has a **documented first action** and a **dashboard** that explains it.

---

## Dependencies (quick)

| Step | Depends on |
|------|------------|
| 2 Correlation | 1 at least partially (you need data from two origins) |
| 3 Views | 1 + 2 (views are useless if correlation ids are missing) |
| 4 Alerts | 3 (alert on what you can see and explain) |

---

## After this block (still “practical”)

- [ ] **Evaluation dataset:** run repeated scenarios and export (feeds the thesis results chapter later).
- [ ] **Config freeze + tag** before any formal measurement window.
