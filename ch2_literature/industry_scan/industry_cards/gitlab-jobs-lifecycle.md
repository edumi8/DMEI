# GitLab CI/CD Jobs Lifecycle and Operations

## Source
**SHORT_KEY:** gitlab-jobs-lifecycle  
**TITLE:** GitLab CI/CD Jobs Documentation  
**LINK:** https://docs.gitlab.com/ee/ci/jobs/  
**DATE_ACCESSED:** 2026-01-06

## What observability signals are used?
- **Job statuses:** canceled, canceling, created, failed, manual, pending, preparing, running, scheduled, skipped, success, waiting_for_callback, waiting_for_resource
- **Job logs:** Full execution log for each job accessible via job detail page
- **Job sources:** api, chat, container_registry_push, duo_workflow, external, merge_request_event, ondemand_dast_scan, parent_pipeline, pipeline, push, schedule, trigger, web, webide
- **Root Cause Analysis:** GitLab Duo for troubleshooting failed jobs
- **Job failure reasons:** Hover over failed job in pipeline graph to see failure reason

## What deployment assumptions/constraints are revealed?
- **Runner execution:** "Jobs execute on a runner, for example in a Docker container"
- **Independent execution:** "Run independently from other jobs"
- **Stage-based grouping:** "jobs in a stage can run in parallel"
- **Job retry behavior:** "new job instance is created with a new job ID...runs with the same parameters and variables"
- **Downstream pipeline association:** "downstream pipeline also associates with the user who initiated the retry"
- **Cancellation behavior:** For GitLab Runner 16.10+, job marked as `canceling`, currently-running command completes, `after_script` runs, then marked `canceled`
- **Force cancel:** Immediately moves job from `canceling` to `canceled`, revoking job token

## How are CI/CD metrics correlated across services?
- **Job ID:** Unique identifier for each job instance
- **Pipeline association:** Jobs grouped by pipeline ID
- **Job metadata:** name, stage, status, source, duration
- **Deployment jobs:** Jobs using `environment` keyword with `action: start`
- **Job dependencies:** Via pipeline graph and stage ordering
- **No distributed tracing:** Correlation via job/pipeline IDs and stage grouping only

## What pain points or challenges are mentioned?
- **Job naming restrictions:** Can't use reserved keywords as job names (image, services, stages, before_script, after_script, variables, cache, include, pages:deploy)
- **Duplicate job names:** "only one is added to the pipeline, and it's difficult to predict which one is chosen"
- **Retry confusion:** "new job instance...new job ID" can cause confusion
- **Cancellation delay:** Must wait for currently-running command and `after_script` to complete
- **Force cancel requirements:** Maintainer role required; job must be in `canceling` state
- **Job token revocation:** Force cancel immediately revokes token, potentially breaking running job

## What observability approaches are avoided or not mentioned?
- **Distributed tracing:** Not mentioned for job correlation
- **Metrics for debugging:** Not discussed as primary debugging signal
- **Real-time monitoring:** Focus on post-failure analysis via logs
- **Automated log analysis:** Manual inspection via UI emphasized

## Technical specifics
- **Job definition:**
  - Must have unique job name
  - Requires `script` (commands) or `trigger` (downstream pipeline)
  - Defined at top-level of YAML configuration
- **Job retry:**
  - New job ID created
  - Same parameters and variables
  - Trigger jobs generate new downstream pipeline
  - User association changes to retry initiator
- **Job cancellation (Runner 16.10+/GitLab 17.0+):**
  1. Job marked `canceling`
  2. Currently-running command completes
  3. Remaining `before_script`/`script` commands skipped
  4. `after_script` always runs to completion
  5. Job marked `canceled`
- **Force cancel:**
  - Requires Maintainer role
  - Job must be in `canceling` state
  - Job token immediately revoked
  - Runner aborts job without waiting for `after_script`

## Platform/environment
- **GitLab tiers:** Free, Premium, Ultimate
- **Offering types:** GitLab.com, Self-Managed, Dedicated
- **Runner versions:** GitLab Runner 16.10+ required for `canceling` state
- **Execution environment:** Docker containers, VMs, bare metal (via runners)

## Security considerations
- **Job token:** Revoked immediately on force cancel
- **User permissions:** Retry changes user association, affecting permissions
- **Deployment jobs:** Subject to deployment safety settings (prevent outdated jobs, ensure single deployment)

---

## Pipeline failure modes discussed
- **Job naming conflicts:** Duplicate names cause unpredictable job selection
- **Cancellation delays:** Waiting for command and after_script completion
- **Job token issues:** Force cancel revokes token while job may still be running
- **Configuration errors:** Using reserved keywords as job names

## Signals used during incident resolution
- **Job logs:** Primary signal accessed via job detail page
- **Job status:** Visual indication in pipeline graph with hover-over failure reasons
- **Root Cause Analysis:** GitLab Duo AI for analyzing failed jobs
- **Retry mechanism:** Create new job instance to test fixes
- **Manual inspection:** UI-based review of job configuration and execution
- **Pipeline graph:** Visual representation of job dependencies and execution order