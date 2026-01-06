# taylorOpenFormatScalable2020

## Problem addressed
Existing system telemetry approaches generate massive amounts of data by exposing low-level system call information, making it impractical and prohibitively expensive to store, process, and analyze at scale for security analytics and forensics.

## Observability mechanism
- SysFlow data format lifts system call events into flow-centric, object-relational mapping
- Collection probe monitors system calls and groups sequences of events sharing same properties into flows
- Flow abstraction aggregates related system calls into time-bound compact summarizations
- Entity-relationship model connects processes to network endpoints, file accesses, and container workloads

## Privilege assumptions
Not stated: Paper does not explicitly describe privilege requirements for the SysFlow collection probe implementation

## Application code modification
No: Collection probe does not require program instrumentation or system call interposition; has negligible impact on monitored workloads

## Telemetry signals
- Metrics: Volumetric flow counters (number of operations, bytes read/written, network sends/receives)
- Logs: Process events (clone, exec, exit, setuid), file events (mkdir, unlink, chmod), network events (bind, listen)
- Traces: Process control flow graphs, data provenance tracking through object IDs

## Collection pattern
Host-based collection probe: Operates at transport layer monitoring network-related system calls (accept, connect, send, recv); exports to S3-compliant object stores feeding Apache Spark analytics

## Evaluation performed
- Evaluation on enterprise-grade benchmarks and container applications
- Comparison with Linux Audit and Sysdig system call monitors
- Capability analysis against MITRE ATT&CK framework for expressing attack tactics and techniques
- Test profiles: targeted attack scenario with node.js server exploitation and data exfiltration

## Overhead reported
Minimal performance overheads: Collection probe optimized to incur minimal impact; validated under multiple stress test profiles; no quantitative measurements provided

## Constraints discussed by authors
- Network flows operate at transport layer; do not record certain remote traffic patterns like scanning activity
- Network flows do not have concept of packets or TCP Flags unlike Cisco NetFlow
- Format reduces data by orders of magnitude compared to raw system calls but evaluation shows Linux Audit loses events under load
- Existing telemetry systems (Audit, Sysdig) yield significant data footprints making storage intractable

## Fit or break under constrained CI/CD
- Fits: Yields traces orders of magnitude smaller than current system telemetry enabling long-term archival with reduced storage requirements
- Fits: Open serialization format and libraries enable integration with open-source data science frameworks and custom analytics
- Fits: Does not require program instrumentation or system call interposition; minimal overhead on monitored workloads
- Unclear: Paper does not explicitly address container privilege models or compatibility with rootless container runtimes in CI/CD pipelines
