# Working assumptions (context for writing)

Use this file so **chapter text** and **what you actually did** stay aligned without pretending history was different.

## Access / environment

- **Past:** Operations did **not** have Unix `docker` group membership on Linux hosts; practical use of the Docker API for diagnostics and co-located tooling was limited.  
- **Current:** **`docker` group** access on Linux hosts **relaxes** several constraints; it does **not** remove heterogeneity (Linux + Windows), on-prem limits, or the need for an **integrated** observability plane (still mostly ad hoc logs/metrics without a full stack until built).

When you touch the introduction, current state, or methodology, prefer wording that reflects this **evolution** if it still matches reality.

## Evaluation object (master’s thesis)

- The **graded artifact** is largely the **document** + traceable evidence (figures, tables, protocol, dataset description).  
- The **prototype** exists to **produce** that evidence, not as an end in itself.

## Research questions (official set)

The three numbered questions live in **`ch1/chapter1.tex`** with labels `rq:design-tradeoffs`, `rq:correlation-maintainability`, `rq:mttd-mtt-baseline`. The literature chapter’s RQ mapping sections should stay tied to **those** questions (already patched once—verify if you revert files).

## Repo hygiene

- Do **not** commit real hostnames, TLS private keys, or production URLs into Git or thesis snippets—use placeholders consistent with `advisor-feedback.md`.
