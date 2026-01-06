# CI/CD-Specific Industry Scan (Round 2)

## Problem Statement

**Current coverage:** Observability OF infrastructure used BY CI/CD (runners, agents, platforms)

**Missing coverage:** Observability FOR debugging pipelines themselves (failures, flaky jobs, performance)

## Key Distinction

Current articles answer: *"How do we monitor GitLab Runner health?"*

Need articles that answer: *"Why did this pipeline fail and how do I debug it?"*

## Target: 5-7 CI/CD-Specific Articles

### GitLab CI/CD (3 articles — highest priority)

**Sources:**
- GitLab Engineering Blog (gitlab.com/blog)
- GitLab Docs Troubleshooting sections
- GitLab incident postmortems

**Search queries:**
```
site:gitlab.com/blog CI pipeline failure
site:gitlab.com/blog CI runner scaling
site:gitlab.com/blog flaky pipeline
site:gitlab.com/blog pipeline performance
site:docs.gitlab.com runner troubleshooting
site:docs.gitlab.com ci debugging
```

**Expected findings:**
- Logs as primary signal
- Runner metrics (but job-centric)
- Job metadata correlation
- Explicit limits of tracing

### Jenkins CI/CD (2 articles — classic pain points)

**Sources:**
- Jenkins blog (jenkins.io)
- Jenkins plugin docs
- Jenkins community posts

**Search queries:**
```
site:jenkins.io blog pipeline debugging
site:jenkins.io blog flaky build
site:jenkins.io monitoring pipeline performance
site:plugins.jenkins.io pipeline monitoring
```

**Expected findings:**
- Build queue metrics
- Log-centric debugging
- Plugin sprawl problems
- Storage and performance issues

### GitHub Actions + DevOps Blogs (1-2 articles)

**Search queries:**
```
github actions self-hosted runner monitoring
github actions debugging workflow failures
self-hosted runner observability
debugging CI pipeline failures blog
why CI pipelines fail observability
flaky CI jobs root cause
ci pipeline performance bottlenecks
```

**Filter for:**
- Engineering blogs (not marketing)
- DevOps writeups
- Articles with screenshots, shell output, failure timelines

## Modified Card Template (CI/CD-Specific)

Add two extra sections to the standard 9-section template:

```markdown
## Pipeline failure modes discussed
- Timeout failures
- Flaky tests
- Resource exhaustion
- Dependency failures
- Infrastructure issues

## Signals used during incident resolution
- Logs only?
- Metrics used?
- Manual inspection?
- Retry patterns?
- UI-based debugging?
```

## Expected Patterns (Stop When You See 3-4x)

1. **Logs dominate absolutely**
2. **Metrics used only to explain why job was slow**
3. **Traces almost never mentioned**
4. **Retry and rerun as "observability"**
5. **Humans as correlation engines**
6. **Platform UI as primary interface**

## Why This Matters for Thesis

This gap highlights:

- **Theoretical observability ≠ CI/CD observability**
- **CI/CD observability is job-centric, not service-centric**
- **Metadata and logs outperform tracing in constrained CI/CD environments**

## Execution Plan

1. Run 6 focused searches (max 5 results each)
2. Create 5-7 industry cards with modified template
3. Add `## CI/CD-specific observations` section to notes.md (10 bullet points max)
4. Update progress.md and sources.md

## Success Criteria

Stop when you have confirmed:
- ✅ Logs as primary debugging signal (repeated 3+ times)
- ✅ Job metadata > distributed tracing (repeated 3+ times)
- ✅ Incident-driven (not continuous exploration) (repeated 3+ times)
- ✅ Platform UI as primary interface (repeated 3+ times)
