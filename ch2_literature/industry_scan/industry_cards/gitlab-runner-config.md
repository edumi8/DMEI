# gitlab-runner-config

## Source

Documentation

## Link

https://docs.gitlab.com/ee/ci/runners/configure_runners.html

## Platform / Context

GitLab CI/CD runners; supports multiple executors (Docker, Kubernetes, Shell, Docker Machine); on-prem, cloud, GitLab.com

## Observability Signals Used

- Job timeout configuration
- Runner authentication token rotation
- CI/CD variables for configuration
- Artifact and cache compression metrics
- Transfer rate meters for uploads/downloads

## Deployment Assumptions

Not stated

## Correlation Approach

- Job correlation via `CI_CONCURRENT_ID` and `CI_CONCURRENT_PROJECT_ID`
- Artifact provenance metadata includes job ID, runner details, timestamps
- SLSA provenance format with build metadata
- Runner identification via runner details page URI

## Pain Points Explicitly Mentioned

- "If you use a depth of 1 and have a queue of jobs or retry jobs, jobs may fail" (shallow cloning)
- "Jobs that rely on git describe may not work correctly when GIT_DEPTH is set"
- Unresolved reference errors when GIT_DEPTH is too small
- Security risks with instance runners: "users with access to the runner host environment can view the code that runner executed"
- Token cloning attack vector: "users with access to the runner authentication token can clone a runner and submit false jobs"

## What is Explicitly Avoided

Not stated

## Notes for Later (No Conclusions)

Configuration focuses on job execution control, timeout management, and artifact/cache handling. Security concerns around token exposure and host access are explicitly documented.
