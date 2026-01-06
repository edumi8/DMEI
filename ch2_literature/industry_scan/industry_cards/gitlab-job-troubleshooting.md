# GitLab CI/CD Job Troubleshooting

## Source
**SHORT_KEY:** gitlab-job-troubleshooting  
**TITLE:** GitLab CI/CD Jobs Troubleshooting  
**LINK:** https://docs.gitlab.com/ee/ci/jobs/job_troubleshooting.html  
**DATE_ACCESSED:** 2026-01-06

## What observability signals are used?
- **Job statuses:** canceled, failed, manual, pending, running, skipped, success (from job detail page)
- **Job logs:** Primary signal for viewing execution details
- **Retry functionality:** "Retry" button to re-execute failed jobs
- **Manual inspection:** UI-based job detail page showing failure reasons
- **Root Cause Analysis:** GitLab Duo for troubleshooting failed CI/CD jobs

## What deployment assumptions/constraints are revealed?
- **changes keyword limitations:** "always evaluates to true" in scheduled pipelines and pipelines for tags
- **Private project permissions:** Administrators must be direct members to clone private project code
- **Configuration immutability:** "configuration for a pipeline is only fetched when the pipeline is created" (rerun doesn't pick up new config)
- **Variable expression syntax:** Strict quoting rules (strings quoted, variables unquoted)
- **HTTP/2 issues:** Git fetch can fail with "RPC failed; curl 16 HTTP/2 send again with decreased length"

## How are CI/CD metrics correlated across services?
- **Job metadata:** Job ID, status, source (api, push, merge_request_event, schedule, web, trigger)
- **Pipeline association:** Jobs grouped by pipeline ID
- **Merge request correlation:** Jobs associated with MR via `CI_MERGE_REQUEST_ID`
- **Resource groups:** Jobs using `resource_group` for sequential execution
- **No distributed tracing:** Correlation via job/pipeline metadata only

## What pain points or challenges are mentioned?
- **Unexpected job execution:** "`changes` always evaluates to true in certain cases"
- **Duplicate pipelines:** "multiple pipelines may run" when pushing commit to branch with open MR
- **Configuration staleness:** "CI/CD job does not use newer configuration when run again"
- **Permission errors:** "You are not allowed to download code from this project" for admins in private projects
- **Variable expression errors:** "This GitLab CI configuration is invalid" due to incorrect quoting
- **HTTP/2 failures:** `get_sources` job section fails with cURL HTTP/2 errors
- **Resource group deadlock:** "Job using `resource_group` gets stuck"
- **Manual job authorization:** "You are not authorized to run this manual job" for protected environments

## What observability approaches are avoided or not mentioned?
- **Metrics for debugging:** Not mentioned as debugging signal
- **Distributed tracing:** No mention of traces for job correlation
- **Automated log analysis:** Manual inspection of logs emphasized
- **Proactive monitoring:** Focus on reactive troubleshooting after failures

## Technical specifics
- **Variable expression syntax:**
  - Valid: `$ENVIRONMENT == "production"` (variable unquoted, string quoted)
  - Invalid: `"$ENVIRONMENT" == "production"` (variable quoted)
  - Invalid: `$ENVIRONMENT == production` (string unquoted)
- **HTTP/2 workaround:** Configure Git to use HTTP/1.1 via `pre_get_sources_script` or runner config.toml
- **Resource group debugging:** Rails console commands to free up stuck resources
- **File path issues:** Trailing slash in CI/CD variables can cause invalid paths (`path/to/files//` with double slashes)
- **changes keyword behavior:** Uses `git diff HEAD~` for branches without MR association

## Platform/environment
- **GitLab tiers:** Free, Premium, Ultimate
- **Offering types:** GitLab.com, Self-Managed, Dedicated
- **Runner configuration:** config.toml with Git configuration environment variables
- **Rails console:** For administrative debugging of resource groups

## Security considerations
- **Protected environments:** Access control for manual job execution
- **Private project permissions:** Administrator impersonation or direct membership required
- **Job token permissions:** User permissions affect job execution capabilities

---

## Pipeline failure modes discussed
- **Configuration errors:** Invalid variable expressions, incorrect quoting syntax
- **Unexpected execution:** changes keyword always true, duplicate pipelines
- **Infrastructure failures:** HTTP/2 cURL errors, resource group deadlocks
- **Permission errors:** Admin access issues, protected environment restrictions
- **Staleness:** Configuration not updating on job retry

## Signals used during incident resolution
- **Job logs:** Primary debugging signal accessed via UI
- **Retry mechanism:** Re-execute failed jobs to confirm fixes
- **Root Cause Analysis:** GitLab Duo AI for analyzing failures
- **Rails console:** Administrative tool for resolving resource group deadlocks
- **Manual inspection:** UI-based review of job status and error messages
- **Git configuration:** Modify runner config or job hooks to work around HTTP/2 issues