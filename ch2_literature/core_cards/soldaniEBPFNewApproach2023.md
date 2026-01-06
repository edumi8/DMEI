# soldaniEBPFNewApproach2023

## Problem addressed
Modern mobile communication networks and cloud-native applications on Kubernetes require efficient observability, networking, and security mechanisms that do not introduce excessive overhead or require kernel recompilation for Telco cloud environments.

## Observability mechanism
- eBPF programs loaded into Linux kernel attached to XDP hooks, traffic control (TC) ingress/egress, socket operations, system calls, and kernel tracepoints
- Telemetry collector, event handler and tracer modules
- eBPF Maps for data sharing between kernel space probes and user space agents
- Hash tables map Service (Cluster) IP to Endpoint (Pod) IP addresses

## Privilege assumptions
Kernel eBPF: eBPF programs run in kernel space (ring-0) and must be loaded by privileged users, requiring access to bpf system calls and kernel hooks

## Application code modification
No: eBPF programs do not require application code changes, pod restarts, or kernel module installation; programs attach to kernel events transparently

## Telemetry signals
- Metrics: CPU cycles, CPU time, CPU instructions, cache misses, process id, cgroup id, energy consumption
- Logs: Network events, system call traces
- Traces: Distributed tracing, Open Telemetry integration

## Collection pattern
Host-based with per-node daemonset: Node Agent (daemonset) deployed on each K8s node loads eBPF programs into kernel; Controller manages Node Agents across cluster; push model via eBPF Maps

## Evaluation performed
- Experimental validation on Sauron platform with eBPF modules for Transport, Observability, Energy, and Security
- Use cases: energy consumption estimation of cloud-native functions, transport network latency measurements, 5G network performance counters
- Hardware: DELL R740 servers, Huawei CloudEngine switch
- Software: Ubuntu 18.04, kernel 5.4.0, Kubernetes v1.25.0

## Overhead reported
Not stated: Paper describes eBPF as "low overhead" and ideal for production environments but does not provide quantitative overhead measurements

## Constraints discussed by authors
- eBPF features tightly coupled to specific kernel version; advanced features only in recent kernels
- eBPF verifier complexity generates false positives; requires "hacks" to avoid valid program rejection
- Kprobe interface requires profound Linux kernel knowledge to choose correct hook points
- User space monitoring (uprobes) less efficient than kernel probes, introduces non-negligible overhead
- Complex control plane required to manage program loading, unloading, attaching, detaching, and configuration
- Kernel portability difficult; requires BCC compilation suite or BTF support (CO-RE)
- Programmability restricted due to kernel safety; some problems require development approach rethinking

## Fit or break under constrained CI/CD
- Fits: No sidecar containers eliminates per-pod memory and CPU quotas; single kernel instance serves all pods reducing resource waste
- Fits: No pod configuration modifications or restarts required for instrumentation; eBPF programs automatically execute on kernel events
- Fits: Replaces iptables with eBPF maps for faster service load balancing; bypasses kernel networking stack reducing latency
- Breaks: Requires privileged access to load eBPF programs into kernel; incompatible with non-root container runtime policies
