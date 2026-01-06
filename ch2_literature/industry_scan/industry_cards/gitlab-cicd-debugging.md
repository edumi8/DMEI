# GitLab CI/CD Pipeline Debugging

## Source
**SHORT_KEY:** gitlab-cicd-debugging  
**TITLE:** GitLab CI/CD Debugging CI/CD Pipelines  
**LINK:** https://docs.gitlab.com/ee/ci/debugging.html  
**DATE_ACCESSED:** 2026-01-06

## What observability signals are used?
- **Logs:** Job logs as primary debugging signal; "using workflow run logs" mentioned first
- **CI/CD variables:** Export full list of variables to verify presence and values
- **Job output:** Verbose output (`--verbose` flag) for detailed troubleshooting
- **Artifacts:** Save output and reports as artifacts for later analysis
- **Pipeline editor:** Visual CI/CD configuration visualization
- **Root Cause Analysis:** GitLab Duo AI for troubleshooting failed jobs

## What deployment assumptions/constraints are revealed?
- **Container-based execution:** "Run the job's commands locally" using Rancher Desktop or similar
- **Syntax validation:** CI Lint tool for verifying `.gitlab-ci.yml` syntax
- **Configuration immutability:** Configuration only fetched when pipeline created (not on retry)
- **rules/only/except behavior:** Different behaviors cause unexpected pipeline execution
- **Byte Order Mark (BOM) issues:** UTF-8 BOM in `.gitlab-ci.yml` causes parsing failures

## How are CI/CD metrics correlated across services?
- **Pipeline names:** `workflow:name` keyword for identifying pipeline types
- **Job statuses:** canceled, canceling, created, failed, manual, pending, preparing, running, scheduled, skipped, success, waiting_for_callback, waiting_for_resource
- **Job sources:** api, chat, container_registry_push, duo_workflow, external, merge_request_event, ondemand_dast_scan, parent_pipeline, pipeline, push, schedule, trigger, web, webide
- **CI/CD variables:** Predefined variables like `CI_PIPELINE_SOURCE`, `CI_MERGE_REQUEST_ID` for correlation
- **No distributed tracing mentioned:** Correlation via job metadata and variables only

## What pain points or challenges are mentioned?
- **rules/only/except confusion:** "behavior of `only/except` and `rules` is different and can cause unexpected behavior when migrating"
- **changes keyword issues:** "always evaluates to true in certain cases" (scheduled pipelines, tags)
- **Duplicate pipelines:** Two pipelines run at same time when pushing to branch with open MR
- **Configuration not updating:** "configuration for a pipeline is only fetched when the pipeline is created" (rerun uses old config)
- **BOM character problems:** "can lead to incorrect pipeline behavior...jobs might be missing, and variables could have the wrong values"
- **Silent failures:** Using `--silent` "can make it difficult to identify what went wrong"

## What observability approaches are avoided or not mentioned?
- **Distributed tracing:** No mention of traces for pipeline debugging
- **Metrics for debugging:** Metrics not mentioned as debugging signal (only for explaining slowness)
- **Real-time monitoring:** Focus on post-failure analysis via logs and artifacts
- **Automated correlation:** Manual inspection of logs and variables emphasized

## Technical specifics
- **Debugging workflow:**
  1. Verify syntax (pipeline editor, CI Lint tool, schemastore validation)
  2. Export and verify CI/CD variables
  3. Check job output (make verbose, save artifacts)
  4. Run commands locally in container
  5. Use GitLab Duo Root Cause Analysis
- **Variable debugging:** "Export the full list of variables available in each problematic job"
- **Dependency pinning:** Pin versions to avoid surprise changes (`ALPINE_VERSION: '3.18.6'`)
- **rules debugging:** Check predefined variables (`CI_PIPELINE_SOURCE`, `CI_MERGE_REQUEST_ID`)
- **Manual debugging variables:** Define `DEBUG_VARS` variable to add flags during manual runs

## Platform/environment
- **GitLab versions:** GitLab.com, Self-Managed, Dedicated
- **Container environments:** Rancher Desktop or similar for local testing
- **Editors:** Pipeline editor (recommended), Web IDE, local editors with schemastore support
- **CI Lint tool:** For syntax verification and pipeline simulation

## Security considerations
- **Artifact security:** "Do not save tokens, passwords, or other sensitive information in artifacts"
- **Job token permissions:** Different permissions for different users running jobs
- **Protected environments:** Access control for manual jobs

---

## Pipeline failure modes discussed
- **Syntax errors:** YAML invalid badge, byte order mark issues
- **Configuration issues:** rules/only/except misconfiguration, BOM character problems
- **Dependency failures:** Incorrect versions, breaking changes in updates
- **Job not running:** rules/only/except blocking jobs, workflow:rules blocking pipeline
- **Duplicate execution:** Two pipelines running simultaneously
- **Silent failures:** `--silent` flag hiding error details

## Signals used during incident resolution
- **Logs primary:** Job logs first debugging step
- **Variable inspection:** Export full variable list to verify values
- **Manual testing:** Run job commands locally in container
- **Artifact analysis:** Save and inspect output files
- **AI assistance:** GitLab Duo Root Cause Analysis for failed jobs
- **UI-based:** Pipeline editor visualization, job detail page failure reasons