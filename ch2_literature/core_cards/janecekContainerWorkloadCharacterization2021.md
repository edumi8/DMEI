# janecekContainerWorkloadCharacterization2021

## Problem addressed
Containers share host resources, leading to risk of resource contention, latencies, and performance problems as concurrent containers increase. Existing methods use coarse-grained metrics (CPU, memory) from internal agents, which are often unavailable in commercial clouds due to security/privacy policies and are challenging to maintain at cloud scale.

## Observability mechanism
- Host system tracing using LTTng (Linux Trace Toolkit next generation) without internal container access
- Kernel-level event tracing captures thread execution states: user mode, system call mode, preempted, interrupted, blocked, waiting
- Eclipse Trace Compass for data extraction and JavaScript-based analysis
- PageRank-based algorithm identifies most significant threads per container
- Extracts metrics: execution state durations, frequencies, privilege levels (D_priv, D_non, W_unknown, W_irq, W_res, W_cpu, F_priv, F_non, F_disk, F_irq, F_prempt, F_inactive)

## Privilege assumptions
Host-based kernel tracing access required. LTTng collects kernel events system-wide, requiring elevated privileges to instrument kernel tracepoints. Namespace ID (pid_ns) context used to filter/group container threads. No privileged access inside containers needed.

## Application code modification
No. Unified tracing method operates at kernel level, independent of container applications. Non-intrusive approach requires no internal agents or application instrumentation. Works across different container engines (Docker, RKT, CRI-O, LXD) and container types.

## Telemetry signals
Metrics derived from kernel execution traces: thread state sequences (user mode, system call mode, preempted, interrupted, blocked, waiting), inter-thread interactions (sched_wakeup, sched_waking, sched_switch, irq events), state durations and frequencies. Time-series event data at kernel level with hundreds of thousands of events per second.

## Collection pattern
Host-based collection. LTTng kernel tracer captures system-wide events, filters by namespace ID (pid_ns context) to isolate container threads. Trace events stored in files. Post-processing extracts state metrics per container using Eclipse Trace Compass scripting.

## Evaluation performed
Ubuntu 20.04.1, Linux kernel 5.8.0, Docker 20.10.4. Various workloads using ApacheBench and Sysbench: CPU intensive, network intensive, disk I/O intensive, idle containers. Two-stage K-Means clustering with silhouette score for optimal k selection. First stage: k=2,3; second stage: k=2-10. Evaluated 5 distinct workload groups.

## Overhead reported
Minimal tracing overhead: only required kernel tracepoints enabled (sched_waking, sched_wakeup, irq_softirq_entry, irq_softirq_exit, sched_switch events). Tracing imposes "very little overhead" per literature cited. Full tracing worst-case included for comparison but unnecessary. Clustering overhead not quantified but K-Means described as "highly efficient, even with large dataset."

## Constraints discussed by authors
Requires LTTng and kernel tracing capabilities. Namespace ID (pid_ns) context necessary to identify container threads. Relies on kernel event instrumentation which may vary across kernel versions. Two-stage clustering limited to k=2,3 at first stage for manageability. Idle/inactive threads filtered via PageRank to avoid noise. Post-processing required for data extraction.

## Fit or break under constrained CI/CD
- Requires host kernel tracing access (LTTng, elevated privileges), likely unavailable in restricted CI/CD containers without host-level control.
- Non-intrusive method beneficial for ephemeral CI/CD workloads as no internal agents or application modification needed.
- Post-processing overhead (Eclipse Trace Compass scripting, PageRank, K-Means clustering) adds latency unsuitable for real-time CI/CD monitoring.
- Trace data storage and processing at scale may exceed resource budgets for lightweight CI/CD pipelines with many concurrent containers.
