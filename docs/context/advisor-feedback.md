# Advisor feedback (informal meeting — capture only)

**Purpose:** Store what was said so Cursor / future you can use it as **context**.  
These are **not** automatically applied to the LaTeX; merge into the thesis only when you decide.

---

## Snippets to include in the thesis (when you write those sections)

- **Docker** — short, **anonymized** CLI examples (e.g. `compose up`, `ps`, `logs`, `stats`).  
- **Docker Compose** — anonymized service names, ports, volumes; no real hostnames.  
- **Reverse proxy** — e.g. Nginx (or Traefik) in front of Grafana: **TLS**, `proxy_pass`, headers; use fake internal names (`obs-stg-01.internal`, etc.).

**Rule:** anything that goes into Git or the PDF must be **redacted** or **staging-only**.

---

## Deadline

- **Thesis submission:** **20 September 2026** (`20 de setembro de 2026`).  
- Planning text (Gantt, milestones, chapter intro dates) should eventually align to **Jan → 20 Sep 2026**, not an old June-only window—**when you choose to edit** `ch3_planning/chapter3.tex`.

---

## Evaluation / evidence

- Expectation: a **large volume of data** for analysis (not single-run anecdotes).  
- Think in terms of: **sustained collection windows**, **repeated scenarios** ($n$ runs), **exports with provenance** (what config, which scenario, which time range), then **aggregate** MTTD/MTTR proxies, overhead, and maybe correlation success.  
- Document **retention limits** and **anonymization** in the protocol so it stays defensible.

---

## Optional next steps (for you, not for the agent unless asked)

1. Drop real (redacted) snippets into an appendix or Chapter 4/5 when the stack exists.  
2. Update the Gantt and milestone table once dates are firm with the institution.  
3. Add a one-page “data collection plan” outline before running the campaign.
