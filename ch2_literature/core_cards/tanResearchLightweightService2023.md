# tanResearchLightweightService2023

## Problem addressed
Traditional service mesh architectures using sidecar proxies consume excessive resources (memory, CPU) when deployed at scale and increase network latency due to multiple packet traversals through kernel stacks between proxies.

## Observability mechanism
- eBPF programs hook bind system call to hijack and forward traffic to kernel-state processing
- Trace collection module deployed at different network kernel stack layers, triggered by kernel function calls for packet operations
- Records IP quintet, layer name, timestamp, process name, thread name, CPU processing information
- Data processing module draws traffic topology based on collected information

## Privilege assumptions
Kernel eBPF: eBPF programs run in kernel state (ring-0) and attach to system-wide hook points; requires privileged access to load and attach programs

## Application code modification
No: Solution maintains non-intrusive approach to applications, free from language and technical constraints; replaces sidecar proxies with kernel-based eBPF programs

## Telemetry signals
- Metrics: Connection performance metrics, network packet information
- Traces: Event tracing for problematic links, packet behavior at different kernel stack layers

## Collection pattern
Host-based kernel implementation: eBPF programs execute in kernel state eliminating sidecar proxy containers; uses cookie_map to store netns cookies for traffic hijacking decisions

## Evaluation performed
- Environment: 3 DELL R740 servers (2x Intel Xeon Silver 4214R 2.4GHz, 256GB RAM, 2x 10Gbps NIC)
- Network: Huawei CloudEngine S5731-H switch (758Gbps/7.58Tbps switching capacity, 282/480Mpps forwarding rate)
- Software: Ubuntu 18.04, kernel 5.4.0-65-generic, Kubernetes v1.25.0, Harbor v2.6.0, MongoDB v4.4
- Comparison: Two service mesh deployments (conventional vs. eBPF-optimized)

## Overhead reported
Not stated: Paper states kernel implementation reduces overhead and resource consumption compared to sidecar model but provides no quantitative measurements

## Constraints discussed by authors
- Further deployment and verification needed for network security and reliability aspects
- eBPF program attaches to system-wide hook points; affects all namespaces requiring netns cookie filtering
- Hijacked traffic forwarding through eBPF bypasses tcp/ip layer and lower protocol processing steps

## Fit or break under constrained CI/CD
- Fits: Eliminates sidecar proxy containers freeing memory and CPU resources consumed by large numbers of agents
- Fits: Shortens packet path through kernel protocol stack by bypassing tcp/ip layer reducing processing time
- Fits: Makes service mesh deployment feasible in edge clouds or nodes with fewer computational resources
- Breaks: Requires kernel version 5.4.0 or later for eBPF support; incompatible with older kernel versions in legacy CI/CD environments
