# Evidence Card: FUSE: Fault Diagnosis and Suppression with eBPF for Microservices

**Citation Key:** ramachandranFUSEFaultDiagnosis2023  
**Authors:** Gowri Sankar Ramachandran, Lewyn McDonald, Raja Jurdak  
**Year:** 2023  
**Type:** Conference Paper (ICSOC 2023)

---

## Research Focus

**Problem Addressed:**
- Service owners cannot reliably diagnose runtime faults in microservices deployed on third-party cloud infrastructure
- Generic and coarse-grained logs offered by cloud providers are insufficient for deep introspection
- Single faulty service can disrupt interconnected services through cascading failures
- Need for runtime fault detection and suppression in microservice architectures

**Proposed Solution:**
FUSE (Fault diagnosis and sUppression with eBPF for microservices) - an eBPF-based framework that enables deep introspection of microservices' runtime behaviour at the kernel level.

---

## Technical Approach

### Core Mechanism
1. **Runtime Observation:** Monitors system calls, function invocations, and disk accesses (including memory allocations)
2. **Signature Generation:** Creates unique hash-based digest (SHA-256) from traces for each microservice invocation
3. **Idempotency Classification:** Categories microservices as strictly or partially idempotent based on trace consistency
4. **Fault Detection:** Validates runtime correctness by comparing digests against expected signatures
5. **Fault Suppression:** Blocks outgoing requests to dependent microservices upon fault detection to prevent cascading failures

### Key Components
- **Syscall Monitor:** Tracks system calls and their counts
- **Functions Tracer:** Traces functions and libraries invoked
- **Disk Read/Write Tracker:** Monitors file operations and memory allocations
- **Digest Generator:** Creates cryptographic hash from combined traces
- **Idempotency Validator:** Determines service consistency patterns
- **Digest Database:** Stores known valid signatures
- **Fault Detector:** Real-time comparison of digests
- **Circuit Breaker Integration:** Suppresses cascading failures

### eBPF Utilization
- Kernel-level probes (kprobe, uprobe, tracepoint, socket)
- No application modification required
- Deep visibility into execution behaviour without user-space overhead

---

## Key Concepts

### Idempotency Definitions
1. **Strictly Idempotent:** Service produces identical trace (L=1) for all invocations
2. **Partially Idempotent:** Service produces finite set of known traces (1 < L ≤ τ)
3. **Faulty Service:** Service breaks idempotency with unexpected traces

### Stability Score
```
smx = (1 - (1 ÷ Lx)) * 100
```
- 0% = strictly idempotent (high stability)
- Higher percentage = less deterministic (lower stability)
- Helps quantify runtime consistency

---

## Evaluation Results

### Implementation
- Platform: AWS EC2 instances (Ubuntu)
- Language: Python Flask microservices
- Hash: SHA-256 (64 characters)
- Database: MySQL for data persistence

### Test Services (E > 1000 invocations each)
| Service | Description | L | Stability Score | Type |
|---------|-------------|---|-----------------|------|
| S1 | User registration (POST) | 2 | 50% | Partially Idempotent |
| S2 | Users data retriever (GET) | 4 | 75% | Partially Idempotent |
| S3 | Password strength checker | 3 | 66.6% | Partially Idempotent |
| S4 | Addition service | 10 | 90% | Partially Idempotent |

### Fault Detection Performance
- **Faults Detected:** 84 runtime faults across S1 and S2
- **Root Cause:** MySQL database crashes due to out-of-memory (OOM killer)
- **Detection Mechanism:** Early signs through additional system calls in traces
- **Zero faults** detected for S3 and S4 (no database dependencies)

### Overhead Analysis

**Storage Overhead (per execution):**
| Service | Syscall Trace | Function Trace | Disk I/O Trace | Total |
|---------|---------------|----------------|----------------|-------|
| S1 | 751 B | 1710 B | 16380 B | ~18.8 KB |
| S2 | 751 B | 1710 B | 16379 B | ~18.8 KB |
| S3 | 751 B | 1647 B | 16380 B | ~18.8 KB |
| S4 | 1039 B | 1647 B | 16385 B | ~19.1 KB |

**Latency Overhead:**
| Service | Without FUSE | With FUSE | Overhead |
|---------|--------------|-----------|----------|
| S1 | 13 ms | 235 ms | +1708% |
| S2 | 14 ms | 204 ms | +1357% |
| S3 | 5 ms | 168 ms | +3260% |
| S4 | 6 ms | 276 ms | +4500% |

**Note:** High latency overhead identified as area for optimization in future work.

---

## Relevance to DMEI Research

### Direct Contributions
1. **Container-Level Observability:** eBPF-based kernel introspection without application modification
2. **Fault Detection:** Real-time identification of runtime anomalies through trace consistency
3. **Cascading Failure Prevention:** Circuit breaker integration for fault suppression
4. **Determinism Quantification:** Stability score mechanism for service reliability assessment

### Observability Patterns
- System call tracing for behavioural fingerprinting
- Function-level monitoring for execution analysis
- Disk I/O tracking for resource usage patterns
- Hash-based signature for change detection

### Alignment with DMEI Objectives
- **Limited Access Rights:** Kernel-level monitoring without container intrusion
- **Cross-Platform:** eBPF works across Linux-based container environments
- **CI/CD Integration:** Idempotency validation mode for pre-production testing
- **Resilience:** Fault suppression prevents cascading failures in microservice chains

### Limitations for DMEI Context
1. **Latency Overhead:** 13-45× increase may be unacceptable for production CI/CD pipelines
2. **Linux Dependency:** eBPF requires Linux kernel 4.x+, limiting Windows container support
3. **Determinism Assumption:** Assumes microservices should be idempotent (not always true)
4. **Storage Accumulation:** Trace files (~19 KB per invocation) require cleanup strategy
5. **Database Requirement:** Needs external digest storage, adding complexity

---

## Related Technologies

**eBPF Tools Mentioned:**
- tcpdump (network monitoring)
- Filetop (file I/O tracking)
- Opensnoop (file access monitoring)
- syscount (system call counting)

**Comparison with Other Works:**
- **MAGNet:** Application-focused eBPF tracing for workload identity (no fault detection)
- **BROFY:** Integrity validation for bitflip errors
- **Existing Service Meshes:** Focus on network-level resilience, not execution-level faults

---

## Future Research Directions

### Identified by Authors
1. Optimize digest generation and notification to reduce latency overhead
2. Support for machine learning-based trace analysis
3. Extended evaluation on larger-scale deployments
4. Integration with existing service mesh platforms

### Potential DMEI Extensions
1. Lightweight digest generation for reduced overhead
2. Sampling strategies for high-throughput environments
3. Cross-platform eBPF alternatives (e.g., Windows eBPF, Falco)
4. Integration with distributed tracing systems
5. Automated stability score thresholds for CI/CD gates

---

## Keywords
eBPF, Fault Detection, Microservices, Resilience, Idempotency, System Call Tracing, Runtime Monitoring, Circuit Breaker, Container Observability, Kernel-Level Introspection

---

## Notes
- First work to use eBPF for runtime fault detection through trace consistency
- Stability score provides novel metric for service reliability assessment
- High latency overhead (13-45×) requires optimization before production use
- Successfully demonstrated early fault detection (OOM) before service failure
- Proxy-based fault suppression prevents cascading failures effectively
