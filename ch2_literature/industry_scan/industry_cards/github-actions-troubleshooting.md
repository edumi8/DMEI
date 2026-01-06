# GitHub Actions Workflow Troubleshooting

## Source
**SHORT_KEY:** github-actions-troubleshooting  
**TITLE:** GitHub Actions Troubleshooting Workflows  
**LINK:** https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/troubleshooting-workflows  
**DATE_ACCESSED:** 2026-01-06

## What observability signals are used?
- **Workflow run logs:** "Each workflow run generates activity logs that you can view, search, and download"
- **Debug logging:** Additional debug logging can be enabled for detailed output
- **GitHub Copilot:** AI-driven "Explain error" for failed workflow runs
- **Workflow visualization:** Visual graph showing workflow structure and job statuses
- **Metrics:** GitHub Actions metrics for analyzing efficiency and reliability
- **Billing/usage data:** Actions usage includes runner minutes and storage for artifacts

## What deployment assumptions/constraints are revealed?
- **Event-based triggers:** Some events only run from default branch (`issues`, `schedule`)
- **Scheduled workflow delays:** "can be delayed during periods of high loads...start of every hour"
- **Path filtering limits:** "limited to the first 300 files" for diff evaluation
- **Runner label matching:** "no guarantee on which matching runner option the job will run on" if labels overlap
- **always() function issue:** "returns `true`, even on cancellation" causing workflows not to cancel

## How are CI/CD metrics correlated across services?
- **Workflow run ID:** Primary correlation identifier
- **Job execution visualization:** Visual graph showing dependencies and execution flow
- **Commit association:** Workflows linked to specific commits and branches
- **Artifact storage:** Artifacts associated with workflow runs
- **No distributed tracing mentioned:** Correlation via workflow/job IDs and UI visualization

## What pain points or challenges are mentioned?
- **Trigger confusion:** "Triggering event conditions" - some events only from default branch
- **Scheduled delays:** "delayed during periods of high loads of GitHub Actions workflow runs"
- **Filtering limitations:** Path filtering limited to first 300 files in diff
- **Runner assignment issues:** Label conflicts can cause unpredictable runner selection
- **Cancellation problems:** `always()` function prevents proper workflow cancellation
- **Network issues:** DNS, firewalls, proxies, certificates, IP lists, subnets can block activities
- **Billing errors:** Workflows fail due to billing or storage errors

## What observability approaches are avoided or not mentioned?
- **Distributed tracing:** No mention of traces for workflow debugging
- **Metrics during debugging:** Metrics mentioned for analysis but not as primary debugging signal
- **Automated correlation:** Manual inspection via logs and UI emphasized
- **Proactive monitoring:** Focus on reactive troubleshooting after workflow failures

## Technical specifics
- **Debug logging flags:**
  - Tool-specific: `npm install --verbose`, `GIT_TRACE=1 GIT_CURL_VERBOSE=1 git ...`
  - GitHub Actions: Enable debug logging via repository settings
- **Cancellation workarounds:**
  - Use `${{ !cancelled() }}` instead of `always()`
  - Force cancel via API if standard cancellation doesn't work
- **Path filtering:** First 300 files evaluated; workflows won't run if relevant files beyond limit
- **Scheduled workflow optimization:** Schedule at different times to avoid high-load periods (start of hour)
- **Network troubleshooting:** DNS, firewalls, proxies, certificates, subnets, IP lists

## Platform/environment
- **GitHub-hosted runners:** Preset labels maintained through actions/runner-images repository
- **Self-hosted runners:** Activity monitoring and diagnostics available
- **Larger runners:** Static IP addresses available
- **Azure VNET integration:** Troubleshooting for Azure Virtual Networks configurations
- **Network dependencies:** DNS, firewalls, proxies, certificates affect workflow execution

## Security considerations
- **Runner label uniqueness:** "unique label names for larger and self-hosted runners" to avoid assignment issues
- **IP allow/deny lists:** Can disrupt expected communications
- **Certificate validation:** Self-signed or custom certificate chains can cause issues
- **Private networking:** Azure VNET configurations require specific troubleshooting

---

## Pipeline failure modes discussed
- **Trigger issues:** Events not triggering workflows (wrong branch, skip annotations, merge conflicts)
- **Scheduled delays:** High load causing job queue drops
- **Path filtering:** Workflows skipped due to 300-file diff limit
- **Cancellation failures:** `always()` function preventing proper cancellation
- **Network failures:** DNS, firewall, proxy, certificate, subnet issues
- **Billing errors:** Workflows blocked due to budget or storage limits

## Signals used during incident resolution
- **Logs primary:** Workflow run logs first debugging step ("using workflow run logs")
- **GitHub Copilot:** AI "Explain error" button for failed checks
- **Debug logging:** Enable additional logging for detailed output
- **Visual inspection:** Workflow visualization graph for understanding execution flow
- **Metrics review:** Analyze efficiency and reliability using metrics
- **Manual testing:** Run workflows manually with modified inputs for debugging