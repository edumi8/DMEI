# Evidence Card: End-to-End Framework for Benchmarking Edge-Cloud Cluster Management

**Citation Key:** raithEndtoEndFrameworkBenchmarking2022

**Authors:** Philipp Raith, Thomas Rausch, Paul Prüller, Alireza Furutanpey, Schahram Dustdar

**Year:** 2022

**Title:** An End-to-End Framework for Benchmarking Edge-Cloud Cluster Management Techniques

**Source:** 2022 IEEE International Conference on Cloud Engineering (IC2E), pp. 22-28

**DOI:** 10.1109/IC2E55432.2022.00010

---

## Research Context

### Problem Domain
- Evaluating edge-cloud cluster management techniques requires tailored testbeds
- No generally accepted way to create testbeds or representative benchmark workloads
- Reproducible experiments are difficult: setup, workload generation, deployment, orchestration, monitoring, analysis
- Manual experiment execution is error-prone and impedes reproducibility

### Research Gap
- Lack of standardized benchmarking framework for edge-cloud clusters
- Hardware architecture agnostic, lightweight, non-intrusive monitoring tools needed
- Real-world trace data collection for trace-driven simulations
- Integration with modern container orchestration (Kubernetes)
- Performance degradation from co-located monitoring applications on resource-constrained devices

---

## Proposed Solution

### Core Approach
**Framework:** End-to-end experiment and analytics framework extending Galileo for edge-cloud benchmarking

**Key Components:**
1. Container orchestration integration (Kubernetes)
2. Distributed load testing
3. System monitoring and instrumentation
4. Experiment automation
5. Post-experiment analytics

### Technical Implementation

**Architecture:**
- **K3s Kubernetes:** Lightweight edge-oriented distribution
  - All nodes in single cluster (using labels to simulate multi-cluster)
  - Node types: controllers (load balancers), client nodes, workers
  
- **Networking:**
  - **WireGuard VPN:** Form homogeneous network
  - **tc (Linux traffic control):** Emulate network latency between clusters
  - L7 load balancing: Go-based weighted round-robin (or Traeﬁk)

- **Monitoring Stack:**
  - **telemd:** Lightweight push-based fine-grained monitoring agent
    - CPU, memory, disk I/O, network I/O
    - Node-level and container-level metrics
    - Supports Pressure Stall Information (PSI) for CPU, I/O, network
    - Configurable per-resource sampling interval
  - **telemd-kubernetes-adapter:** Watches Pod lifecycle events
  - **Resource usage:** Minimal overhead (see evaluation)

- **Data Storage:**
  - **InfluxDBv2:** Time-series database for fine-grained telemetry
  - **MariaDB (MySQL):** Experiment metadata (start, end, node info)
  - **Redis:** Message distribution for client coordination

- **Applications:**
  - OpenFaaS-based functions (multi-architecture: amd64, arm64v8, arm32v7)
  - AI inference functions: object detection, classification, pose estimation
  - HTTP endpoint requirement (any containerized app)

**Experiment Types:**
1. **Scenario experiments:** Complex resource management scenarios (multi-app, multi-node, scaling)
2. **Profiling experiments:** Single application on single node (performance + resource usage estimation)

**Workload Generation:**
- **Parameterized:** n requests, fixed inter-arrival time ia, number of clients
- **Profile-based:** Array of inter-arrival times per client (e.g., [0.5, 1, 0.5])

**Trace Data Collected:**
- t_start: Client sends request
- t_0: Load balancer forwards request
- t_1: Function receives request
- t_2: Function returns response
- t_end: Client receives response

**Derived Metrics:**
- Round-trip time (RTT): t_end - t_start
- Client-LB network latency: t_0 - t_1
- LB-App network latency: t_1 - t_0
- Execution time: t_2 - t_1 (includes queuing from Flask worker threads)

**Technology Stack:**
- **Languages:** Python (most components), Go (load balancer, K8s adapter, telemd)
- **Orchestration:** K3s Kubernetes
- **Message Queue:** Redis
- **Databases:** InﬂuxDBv2 (telemetry), MariaDB (metadata)
- **VPN:** WireGuard
- **Traffic shaping:** tc (Linux)
- **Analytics:** Jupyter Notebooks (galileo-jupyter)

---

## Evaluation

### Experimental Setup
- **Testbed:** 3 clusters (IoT Box, Cloudlet, Cloud)
  - **IoT Box:** 1x AsRock (8-core Ryzen), 1x RPi 4, 1x Nvidia Jetson NX/TX2/Nano
  - **Cloudlet:** 1x Xeon (4-core @ 4.6GHz, 16GB RAM)
  - **Cloud:** 4x VMs (4 vCPU @ 2GHz, 8GB RAM)
  - **Clients:** 2x Intel NUC (4-core i5, 16GB RAM)

### Case Study 1: Profiling Experiment
**Application:** MobileNet neural network (TFLite, CPU mode) - object classification

**Workload:** 1 client, 100 requests, 1-second inter-arrival time

**Results (across 4 devices):**
- **RTT:** Xeon (lowest), NX/TX2 (comparable), Nano (worst, outliers up to 6s)
- **CPU usage:** Nano (highest), Xeon/NX/TX2 (lower)
- **Memory usage:** Xeon (highest), Nano (lowest)

**Insights:** Performance varies significantly by hardware (heterogeneous edge)

### Case Study 2: Scenario Experiment
**Setup:**
- 3 clients: 2 in IoT-Box, 1 in Cloudlet
- 60 requests per client, 1-second inter-arrival time
- Random scaling: every 5s (10% no-op, 40% scale-up, 50% scale-down)
- Round-robin load balancing across clusters

**Results:**
- Framework successfully tracked replica counts across clusters over time
- Analyzed request generation location vs. processing location
- Demonstrated cross-cluster request routing

### Case Study 3: telemd Monitoring Overhead
**Setup:** 100-second experiment, 1Hz monitoring interval

**Results:**
- **CPU usage:** Low relative container CPU usage (< 10% on all devices)
- **Memory usage:** Low across all devices (RPi 4 to Xeon-based PC)
- **Conclusion:** Minimal resource overhead, suitable for edge devices

---

## Key Findings

### Strengths
1. **End-to-end automation:** Deployment → execution → analysis
2. **Multi-architecture support:** amd64, arm64v8, arm32v7 (edge heterogeneity)
3. **Lightweight monitoring:** telemd has minimal overhead on edge devices
4. **Flexible workloads:** Parameterized and profile-based
5. **Integration with K8s:** Automated deployment via orchestration
6. **Fine-grained telemetry:** Container-level + node-level metrics
7. **PSI metrics:** Novel Pressure Stall Information for CPU/I/O/network
8. **Open-source:** All components available on GitHub (Edge Run project)
9. **Reproducibility:** Declarative testbed configuration

### Limitations
1. **Manual network configuration:** tc-based latency emulation not automated
2. **Single-cluster simulation:** Uses labels to simulate multi-cluster (not true federation)
3. **Limited testbed scale:** 3 clusters, small node count
4. **Custom cluster management:** Users must implement own scheduling/scaling logic
5. **OpenFaaS-centric:** Primarily designed for FaaS functions (though supports any HTTP endpoint)
6. **Short paper:** Limited depth (7 pages)

---

## Relevance to Research

### Connection to Container Monitoring
- Demonstrates lightweight monitoring (telemd) suitable for resource-constrained edge devices
- Container-level and node-level resource metrics (CPU, memory, disk, network)
- Kubernetes integration for Pod lifecycle tracking
- Shows importance of minimal monitoring overhead (<10% CPU)

### Applicability to Thesis
- **Monitoring approach:** telemd = lightweight, push-based, fine-grained (similar to Monintainer)
- **K8s integration:** Framework designed for Kubernetes environments (CI/CD often uses K8s)
- **PSI metrics:** Pressure Stall Information = novel metric for resource contention detection
- **Trace collection:** Detailed request path tracing (client → LB → app → client)
- **InfluxDB storage:** Time-series database for high-volume telemetry data
- **Multi-architecture:** Supports x86/ARM (relevant for heterogeneous CI/CD runners)

### Research Questions Addressed
- **RQ: How to monitor resource-constrained devices?** → Lightweight agents (telemd) with configurable sampling
- **RQ: What metrics for edge-cloud systems?** → CPU, memory, disk, network, PSI (pressure stall)
- **RQ: How to trace requests across clusters?** → Timestamp collection at each hop (t_start, t_0, t_1, t_2, t_end)
- **RQ: How to automate experiments?** → Kubernetes orchestration + declarative configuration

### Differences from Thesis Context
| Aspect | Raith et al. 2022 | Thesis Focus |
|--------|-------------------|--------------|
| Domain | Edge-cloud cluster management | CI/CD pipelines |
| Workload | FaaS inference functions | Build/test/deploy tasks |
| Duration | Long-running experiments | Short-lived jobs |
| Primary goal | Benchmarking cluster management | Continuous observability |
| Testbed | Physical edge devices | Containerized CI/CD |

---

## Critical Assessment

### Methodological Quality
- ✅ Practical demonstration with real hardware testbed
- ✅ Multi-architecture evaluation (x86, ARM)
- ✅ Monitoring overhead measurement
- ⚠️ Limited scale (3 clusters, small node count)
- ⚠️ No comparison with alternative frameworks
- ⚠️ Short paper = limited depth (7 pages)

### Practical Implications
- Framework is production-ready (open-source, K8s integration)
- Demonstrates value of lightweight monitoring on edge devices
- Reproducibility enabled by declarative configuration
- Requires manual network configuration (tc) for latency emulation

### Technical Insights
1. **PSI metrics:** Pressure Stall Information provides novel insight into resource contention
2. **telemd overhead:** <10% CPU usage demonstrates feasibility of edge monitoring
3. **Multi-architecture:** Framework successfully runs on x86 and ARM devices
4. **Request tracing:** Fine-grained timestamp collection enables detailed performance analysis

---

## Future Work (from paper)
1. Extend Ether (topology synthesizer) for automated testbed configuration
2. Add power measurements and train models to predict energy consumption
3. Automate network latency configuration between clusters

---

## Extraction Notes
- **Pages Extracted:** 7 (complete paper)
- **Extraction Date:** 2026-01-06
- **Extraction Quality:** High - full text with architecture, implementation, evaluation
- **Missing Content:** References section only (7-page short paper)
- **Note:** Short paper = limited depth, but comprehensive system description
