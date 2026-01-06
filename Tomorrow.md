# Industry Scan Setup (Tomorrow Plan)

## Goal

Get a **bounded starter set** of industry (non-academic) articles about **CI/CD observability** so I can extract "industry cards" and have momentum tomorrow.

**Stop condition:** stop after **10 industry cards** (even if more exist).

---

## Folder Setup (Repo)

Create:

- `ch2_literature/industry_scan/`
- `ch2_literature/industry_scan/industry_cards/`
- `ch2_literature/industry_scan/progress.md`
- `ch2_literature/industry_scan/sources.md`
- `ch2_literature/industry_scan/notes.md`

---

## Industry Card Template (Copy Per Article)

Save each card as:  
`ch2_literature/industry_scan/industry_cards/<SHORT_KEY>.md`

```md
# <SHORT_KEY>

## Source

(blog / documentation / postmortem / talk transcript)

## Link

(URL)

## Platform / Context

(GitLab, Jenkins, generic CI/CD; on-prem, cloud, mixed)

## Observability Signals Used

(logs / metrics / traces / platform APIs)

## Deployment Assumptions

(non-privileged containers? agents? host access? unclear?)

## Correlation Approach

(trace IDs, job IDs, timestamps, metadata, none)

## Pain Points Explicitly Mentioned

(verbatim or near-verbatim)

## What is Explicitly Avoided

(tracing, agents, host tools, kernel access, etc.)

## Notes for Later (No Conclusions)

(1–2 factual sentences max)

**Rule:** If something isn't explicitly stated, write "Not stated".
```

---

## Search Plan (Bounded)

### Queries (Google)

Run these queries and open only the **first 5 results** for each query, then stop.  
If a result is marketing-only, skip it and open the next result.

#### GitLab

- `site:docs.gitlab.com observability CI`
- `site:gitlab.com/blog observability CI pipeline`
- `site:gitlab.com/blog runner monitoring`

#### Jenkins

- `site:jenkins.io monitoring`
- `site:jenkins.io blog pipeline troubleshooting`
- `site:plugins.jenkins.io monitoring`

#### Grafana / Logs

- `site:grafana.com/blog CI observability`
- `site:grafana.com/blog Loki CI`

#### OpenTelemetry

- `site:opentelemetry.io collector deployment`
- `site:opentelemetry.io docs collector kubernetes`

#### Elastic

- `site:elastic.co observability CI CD`

**Rule:** do not go beyond page 1 of results.

---

## Extraction Workflow (Per Article)

1. Open the article
2. Create a new industry card file using the template
3. Extract only factual statements
4. Add the article link
5. Save the card
6. Update trackers:
   - Add the article title + link to `sources.md`
   - Mark progress in `progress.md`

---

## `progress.md` Format

```md
## Queue

- [ ] <TITLE> — <LINK>
- [ ] <TITLE> — <LINK>

## Completed

- [x] <SHORT_KEY> — <TITLE> — <LINK>
```

---

## `notes.md` (Private Synthesis, Not Thesis Text)

After every 5 cards, add a short list:

- Signals used most (logs/metrics/traces)
- Common constraints mentioned
- Correlation patterns (job IDs, pipeline IDs, timestamps, etc.)
- Recurring pain points
- What is commonly avoided

**No recommendations. No "best tool" conclusions.**

---

## Copilot Prompt (Use Per Opened Article)

```
Extract factual information only from this article and fill the industry card sections:
- Platform / Context
- Observability signals used
- Deployment assumptions
- Correlation approach
- Pain points explicitly mentioned
- What is explicitly avoided
- Relevant quotes (verbatim)

Do not infer beyond what is written.
If something is not stated, write "Not stated".
Do not recommend tools or compare vendors.
```

---

## Tomorrow's Minimum Success

- Find 6–10 articles
- Create at least 3 industry cards before doing anything else
- Stop once 10 cards exist
