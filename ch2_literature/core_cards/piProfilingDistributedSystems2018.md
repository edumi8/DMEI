# Evidence Card: Profiling Distributed Systems in Lightweight Virtualized Environments

**Citation Key:** piProfilingDistributedSystems2018

**Authors:** Aidi Pi, Wei Chen, Xiaobo Zhou, Mike Ji

**Year:** 2018

**Title:** Profiling distributed systems in lightweight virtualized environments with logs and resource metrics

**Source:** HPDC '18: The 27th International Symposium on High-Performance Parallel and Distributed Computing, June 11-15, 2018, Tempe, AZ, USA

**DOI:** https://doi.org/10.1145/3208040.3208044

---

## Research Context

### Problem Domain
- Troubleshooting distributed systems in cloud environments is difficult
- Single user request distributed across multiple nodes/components
- Root causes are diverse: software bugs, interference, misconfigurations, data skews
- Multi-tenancy interference complicates performance diagnosis

### Research Gap
- **Log analysis alone:** Trade-off between effectiveness and overhead; lacks resource context
- **Intrusive tracing:** Requires deep system knowledge; modifications become invalid after updates
- **Resource metrics:** Collected at machine-level granularity, inaccurate for per-process troubleshooting
- **Challenge:** Obtaining per-process I/O metrics is difficult in traditional environments

---

## Proposed Solution

### Core Approach
**LRTrace:** Non-intrusive tracing and feedback control tool for distributed applications in lightweight virtualized environments (Docker/LXC)

**Key Innovation:** Correlates log messages with fine-grained resource metrics enabled by container-based virtualization

### Technical Implementation

**Architecture:**
- **Tracing Worker:** Runs on every node
  - Collects logs and resource metrics from containers
  - Sends data to information collection component (Kafka)
  - Sampling frequency: 1Hz (long jobs), 5Hz (short jobs)
  
- **Tracing Master:** Central analysis component
  - Pulls data from Kafka
  - Transforms raw logs to keyed messages
  - Correlates logs with resource metrics
  - Stores in OpenTSDB time-series database
  - Executes user-defined feedback control plugins

**Keyed Message Structure:**
- **key:** High-level object/event name
- **identifiers:** Unique object/event identifier
- **value:** Numeric value (if applicable)
- **type:** Instant event or period object
- **is-finish:** Flag indicating end of period object
- **timestamp:** When message was written

**Log Transformation:**
- Uses regular expressions to extract log messages
- 12 rules for Spark, 4 rules for MapReduce, 5 rules for Yarn
- Configuration via XML/JSON format
- Supports operations: Groupby, Count, Sum, Average, downsampling

**Resource Monitoring:**
- CPU, memory, disk I/O, network I/O
- Per-container granularity via Docker/LXC APIs
- Container IDs used to correlate logs with metrics

**Technology Stack:**
- **Cluster Manager:** Apache Yarn
- **Containers:** Docker (LXC-based)
- **Message Queue:** Kafka 0.10.2.1
- **Database:** OpenTSDB 2.3.0 (time-series)
- **Applications:** Spark 2.1.0, Hadoop 2.7.3 MapReduce
- **Visualization:** OpenTSDB GUI web server

---

## Evaluation

### Experimental Setup
- **Testbed:** 9-node cluster (1 master, 8 slaves)
- **Hardware:** Intel i7-2600 CPU, 8GB RAM, 512GB HDD (7200 rpm), 1Gbps Ethernet
- **OS:** Ubuntu 16.04 LTS 64-bit
- **Benchmarks:** HiBench-6.0, TPC-H

### Case Studies

#### 1. Spark Workflow Reconstruction
**Workload:** Pagerank (500MB data, 3 iterations, 8 executors)

**Findings:**
- Memory drops caused by JVM full garbage collection (not spilling operations)
- Spilling events followed by GC with delay (GC releases memory, not spilling)
- Synchronous stage boundaries: all containers start shuffling simultaneously
- Validated: Spark uses synchronizing mechanism between stages

**Example:** Container_03 spilled 602.9MB but memory drop occurred seconds later due to GC

#### 2. MapReduce Workflow Reconstruction
**Workload:** Wordcount (3GB data)

**Map Task:** 5 consecutive spills → 12 merge operations (6KB each)
**Reduce Task:** 3 fetchers → 2 merge operations (30KB each)

**Anomaly Detected:** One map task started late, stayed alive 27s after application finished → Bug identified

#### 3. Bug #1 - SPARK-19371: Uneven Task Assignment
**Scenario:** Spark TPC-H Query 08 (30GB) with MapReduce interference

**Symptoms:**
- Uneven memory consumption (1.4GB vs 500MB)
- Containers finishing initialization early receive most tasks
- Data locality preference causes task clustering
- Issue prevalent in sub-second tasks (Wordcount, TPC-H Q8/Q12, KMeans pt1)

**Root Cause:** Spark scheduler cannot make appropriate decisions for sub-second tasks
- Scheduler prefers containers that finish initialization early
- Interference aggravates imbalance by causing late container starts
- Overhead memory (~250MB per container) wasted on idle containers

**Impact:** Memory usage inefficiency, wasted resources on idle containers with overhead

#### 4. Bug #2 - YARN-6976: Container Not Released
**Scenario:** Detected during experiments

**Finding:** Yarn ResourceManager fails to release containers in certain conditions
- Reported by authors to Apache Yarn project
- Demonstrates LRTrace's capability to discover previously unknown bugs

### Feedback Control Examples
**Plugin 1:** Blacklist bottlenecked nodes
- Prevents task assignment to slow nodes
- Improves application execution time and cluster throughput

**Plugin 2:** Retry stuck/failed applications
- Automatically retries applications that fail
- Increases application success rate

---

## Key Findings

### Strengths
1. **Non-intrusive:** No source code modification required
2. **Fine-grained visibility:** Container-level resource metrics (CPU, memory, disk I/O, network I/O)
3. **Log-resource correlation:** Matches events with resource consumption via container IDs
4. **Flexible querying:** Keyed message enables SQL-like operations (Groupby, Count, Sum)
5. **Pluggable architecture:** User-defined feedback control plugins
6. **Low overhead:** 1Hz-5Hz sampling frequency
7. **Bug discovery:** Found 2 bugs (SPARK-19371, YARN-6976)
8. **Practical insights:** Revealed JVM GC behavior, Spark stage synchronization

### Limitations
1. **Container-dependency:** Requires Docker/LXC for fine-grained metrics
2. **Regex-based extraction:** Ad-hoc approach (12 Spark + 4 MapReduce + 5 Yarn rules)
3. **Limited scope:** Focused on Spark/MapReduce data-parallel frameworks
4. **Sampling trade-off:** Higher frequency = more overhead vs. accuracy
5. **Short-lived objects:** Risk of missing objects with very short lifespans
6. **Manual rule definition:** Users must define extraction rules for new systems

---

## Relevance to Research

### Connection to Container Monitoring
- **Core contribution:** Demonstrates how container-based virtualization enables fine-grained monitoring
- Per-container resource metrics (CPU, memory, disk, network) critical for multi-tenant environments
- Container IDs provide correlation keys between logs and resource consumption
- Shows importance of combining application-level telemetry (logs) with infrastructure metrics (resources)

### Applicability to Thesis
- **Keyed Message Pattern:** Structured log transformation approach applicable to CI/CD pipeline logs
- **Correlation Technique:** Using container IDs to correlate logs + metrics directly applicable to Docker-based CI/CD
- **Sampling Strategy:** 1Hz (long jobs) vs 5Hz (short jobs) relevant for CI/CD tasks with varying durations
- **Technology Stack:** Kafka (collection) → Processing → OpenTSDB (storage) = scalable observability pipeline
- **Non-intrusive approach:** No modification to application code = suitable for CI/CD without altering build scripts

### Research Questions Addressed
- **RQ: How to correlate logs with resource metrics?** → Use container IDs as correlation keys
- **RQ: What granularity for resource sampling?** → 1-5Hz depending on workload duration
- **RQ: How to structure log data for analysis?** → Keyed message with key/identifier/value/type/timestamp
- **RQ: How to handle distributed logs?** → Centralized collection (Kafka) + transformation + time-series storage

### Differences from Thesis Context
| Aspect | Pi et al. 2018 | Thesis Focus |
|--------|---------------|--------------|
| Application type | Data-parallel (Spark/MapReduce) | CI/CD pipelines |
| Workload duration | Minutes to hours | Seconds to minutes |
| Cluster manager | Yarn | Docker Compose/Kubernetes |
| Primary goal | Bug diagnosis | Continuous monitoring |
| Feedback control | Semi-automatic plugins | Real-time alerting |

---

## Critical Assessment

### Methodological Quality
- ✅ Comprehensive evaluation with multiple case studies
- ✅ Real bugs discovered and reported (SPARK-19371, YARN-6976)
- ✅ Performance overhead analysis included
- ✅ Multiple workloads tested (HiBench, TPC-H)
- ⚠️ Limited to 9-node cluster (scalability unclear)
- ⚠️ No comparison with alternative troubleshooting tools

### Practical Implications
- Demonstrates value of combining logs + resource metrics
- Keyed message provides structured approach to log analysis
- Regex-based extraction requires maintenance as systems evolve
- Feedback control plugins enable custom automation

### Technical Insights
1. **JVM GC vs Spilling:** Memory drops caused by GC, not by spilling operations
2. **Spark Stage Synchronization:** All containers wait for slowest task before stage transition
3. **Container Initialization Matters:** Early initialization = more task assignments (Spark bug)
4. **Overhead Memory:** ~250MB per container even when idle

---

## Extraction Notes
- **Pages Extracted:** 13 (complete paper)
- **Extraction Date:** 2026-01-06
- **Extraction Quality:** High - full text with methodology, architecture, evaluation results
- **Missing Content:** None (complete paper, missing only final pages with references)
