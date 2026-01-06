# buildkite-pipelines

## Source

Documentation / Getting Started Guide

## Link

https://buildkite.com/docs/tutorials/getting-started

## Platform / Context

Hybrid architecture: hosted (managed) and self-hosted agents; supports macOS, Windows, Linux, Docker; cluster-based agent organization

## Observability Signals Used

- **Logs**: Job output logs, build logs, log archives downloadable
- **Metrics**: Job execution minutes (billable), build performance
- **Traces**: Not stated
- **Artifacts**: Build artifacts with artifacts browser
- **Job environment variables**: Exposed in job execution for inspection

## Deployment Assumptions

- **Agent-based**: Buildkite agents poll for work and run jobs
- **Cluster model**: Agents organized into clusters and queues
- **Hosted agents**: "Buildkite hosted agent... provides the quickest method to get up and running with Pipelines"
- **Self-hosted agents**: Can run on local machines, cloud servers, or remote machines
- **Agent tokens**: Required for self-hosted agents (not for hosted agents)
- **Queue assignment**: Jobs dispatched to specific agent queues

## Correlation Approach

- **Cluster and queue metadata**: Agents associated with clusters and queues
- **Job metadata**: Job ID, pipeline ID for correlation
- **Artifacts browser**: Centralized artifact access per build
- **Pipeline configuration**: YAML files (`.buildkite/pipeline.yml`) in repository
- **No distributed tracing mentioned**: Not stated

## Pain Points Explicitly Mentioned

- **Agent setup complexity**: Wizard for choosing between hosted vs. self-hosted agents
- **Initial setup friction**: "Skip agent setup" option in starter flow suggests recognition of setup complexity
- **No pain points explicitly stated**: Documentation is introductory/tutorial style

## What is Explicitly Avoided

- Not stated

## Notes for Later (No Conclusions)

- Buildkite separates control plane (hosted) from execution plane (agents can be self-hosted)
- "Hybrid architecture" model provides flexibility for security-sensitive workloads
- Logs are primary signal (search, download, delete operations all log-focused)
- Artifacts are separate from logs and require explicit configuration
- GitHub CLI integration for log viewing and filtering
- Agent polling model (pull-based) rather than push-based job dispatch
- Free trial for hosted agents (2 weeks), then usage-based pricing
