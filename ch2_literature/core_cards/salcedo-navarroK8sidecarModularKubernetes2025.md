# Evidence Card: K8sidecar: A Modular Kubernetes Chain of Sidecar Proxies

**Citation Key:** salcedo-navarroK8sidecarModularKubernetes2025  
**Authors:** Andoni Salcedo-Navarro, Miguel Garcia-Pineda, Juan Gutiérrez-Aguado  
**Year:** 2025  
**Journal:** Software: Practice and Experience  
**Type:** Research Article

---

## Research Focus

**Problem Addressed:**
- Existing proxy sidecar implementations (e.g., Envoy) cannot compose filter chains at deployment time
- Filters/logic must be integrated during development phase, reducing deployment flexibility
- No dynamic method for chaining sidecars in Kubernetes or serverless architectures
- Need to externalize operational features (logging, monitoring, security) from application logic

**Proposed Solution:**
K8Sidecar - leverages Kubernetes operator pattern to **dynamically inject and chain** proxy sidecar containers at deployment time.

---

## Technical Architecture

### Core Components

#### 1. Operator Pattern Implementation
**Custom Resource Definition (CRD):**
- **Type:** Filter
- **Defines:** Array of proxy sidecars with properties:
  - `name`: Unique identifier
  - `image`: Container image
  - `priority`: Sorting order (0-255, default 0 = highest)
  - `env`: Environment variables
  - `vol`: Volume specifications

**Controller:**
- Language: Golang
- Function: Creates Mutating Admission Controller + webhook per Filter
- Trigger: Watches Filter resource creation/deletion

#### 2. Dynamic Injection Mechanism
**Webhook Algorithm:**
1. Check if resource has label matching Filter name
2. Extract port and mount directory from annotations
3. Set application container to max priority
4. Sort containers (sidecars + app) by priority
5. Generate JSONPatch to:
   - Delete original container list
   - Add emptyDir volume (for data sharing)
   - Re-add containers in priority order
   - Assign sequential ports (port, port+1, port+2, ...)
   - Mount shared volume at specified directory

**Chain Architecture:**
```
Request → Sidecar₁ (port) → Sidecar₂ (port+1) → ... → App (port+n)
          ↓ Shared Volume (/shared or custom mount dir) ↓
```

### 3. Developer Libraries

#### Golang Library
- Uses standard `net/http` package
- Interfaces:
  - `TriFunction`: `func(req *http.Request, res http.ResponseWriter, chain *FilterChain)`
  - `QuaFunction`: For CloudEvents support

#### Java Library
- Based on Servlet specification + Jetty HTTP server
- Functional interfaces:
  - `TriFunction<T, U, V>`: 3-argument (request, response, chain)
  - `QuaFunction<T, U, V, R>`: 4-argument (adds CloudEvent)
- Class: `SidecarFilter` with `accept` method

**Language-Agnostic Design:**
- Libraries not mandatory
- Only requirement: Listen on `PPORT`, forward to `PPORT + 1`
- Allows use of any HTTP-capable language

---

## Key Features

### 1. On-the-Fly Configuration
- Add/remove/update sidecars without rebuilding application
- Reduces deployment downtime
- Supports rapid iteration cycles

### 2. Label-Based Injection Control
```yaml
labels:
  <filtername>: "sidecar"  # Enables injection
```

### 3. Priority-Based Ordering
- Determines execution sequence
- Ensures security/logging processed in correct order
- Handles dependencies between sidecars

### 4. Environment Variable Injection
- Adapt sidecars to deployment environments
- No core logic modification needed

### 5. Volume Sharing
- emptyDir volume mounted across all containers
- Use cases:
  - Download data for application
  - Upload application-generated data
  - Share temporary processing results

### 6. Platform Support
- **Kubernetes:** Standard Deployments
- **Knative:** Serverless functions (FaaS)
- **CloudEvents:** Event-driven architectures

---

## Evaluation Results

### Test Setup
- **Platform:** Kubernetes cluster
- **Comparison:** K8Sidecar (Go and Java libraries) vs. Envoy
- **Metrics:** Cold start time, request latency
- **Sidecar Count:** 1 to 5 sidecars

### Performance Results

**Cold Start Time:**
- **1 sidecar:** All implementations ~comparable
- **5 sidecars:**
  - K8Sidecar (Go): Closest to Envoy
  - K8Sidecar (Java): Higher overhead (JVM initialization)
  - Envoy: Best performance (native C++ implementation)

**Request Latency:**
- **1-5 sidecars:** K8Sidecar (Go) remains reasonably close to Envoy
- **Envoy advantage:** Single-process filter chain (in-memory function calls)
- **K8Sidecar overhead:** Inter-container HTTP communication

**Key Finding:** For ≤5 sidecars, chain-of-sidecars approach (especially Go) remains practical vs. Envoy.

### Trade-offs

| Aspect | K8Sidecar | Envoy |
|--------|-----------|-------|
| **Flexibility** | High (deploy-time composition) | Low (dev-time only) |
| **Modularity** | High (independent containers) | Medium (filter chaining) |
| **Performance** | Moderate (HTTP overhead) | High (in-memory) |
| **Testability** | High (test sidecars in isolation) | Medium (integrated testing) |
| **Cold Start** | Moderate (Go), Higher (Java) | Best |
| **Latency** | Acceptable (≤5 sidecars) | Optimal |

---

## Use Cases

### Illustrated Examples

#### 1. Logging Sidecar
- Intercepts requests/responses
- Extracts metadata (headers, timing)
- Writes to centralized logging system

#### 2. Authentication Sidecar
- Validates tokens before application access
- Blocks unauthorized requests
- Injects user context for downstream

#### 3. Monitoring Sidecar
- Collects metrics (latency, throughput)
- Exports to Prometheus/Grafana
- Traces distributed requests

#### 4. Data Adapter Sidecar
- Transforms request/response formats
- Protocol translation (REST ↔ gRPC)
- Data enrichment from external sources

---

## Relevance to DMEI Research

### Direct Contributions
1. **Modular Observability:** Sidecars can be tested and optimized independently
2. **Deploy-Time Flexibility:** Adapt monitoring to environment without code changes
3. **Container-Level Monitoring:** Each sidecar monitors specific aspect (logging, metrics, tracing)
4. **CI/CD Integration:** Different sidecar chains for dev/staging/production

### Observability Patterns
- **Separation of Concerns:** Monitoring logic external to application
- **Composability:** Combine multiple monitoring aspects (logs + metrics + traces)
- **Priority Control:** Ensure monitoring executes before/after specific operations
- **Volume Sharing:** Collect data from application container without intrusion

### Alignment with DMEI Objectives
- **Limited Access Rights:** Sidecars don't modify application containers
- **Cross-Platform:** Kubernetes + Knative support covers containerized environments
- **Language-Agnostic:** Can develop sidecars in any HTTP-capable language
- **Dynamic Configuration:** Adapt monitoring to changing requirements

### Advantages Over Envoy for DMEI
1. **Deploy-Time Composition:** Change monitoring without rebuilding
2. **Independent Testing:** Validate each monitoring component separately
3. **Incremental Adoption:** Add monitoring capabilities one sidecar at a time
4. **Clear Overhead Measurement:** Isolate performance cost per sidecar

### Limitations for DMEI Context
1. **Performance Overhead:** HTTP inter-container communication slower than in-memory
2. **Cold Start Impact:** Each sidecar adds startup time (especially Java)
3. **Scalability:** Performance degrades with >5 sidecars
4. **Network Dependency:** Requires reliable pod networking
5. **Kubernetes-Only:** No support for non-orchestrated containers

---

## Technical Implementation Details

### Annotations
```yaml
annotations:
  k8sidecar.port.env-name: "APP_PORT"  # Default: PORT
  k8sidecar.volume.mount-dir: "/shared-data"  # Default: /shared
```

### Filter Definition Example
```yaml
kind: Filter
metadata:
  name: observability-stack
spec:
  sidecars:
    - name: auth
      image: auth-sidecar:v1
      priority: 1
    - name: logging
      image: logging-sidecar:v2
      priority: 2
    - name: metrics
      image: metrics-sidecar:v1
      priority: 3
```

### Execution Flow
1. Request arrives at lowest-priority sidecar (auth)
2. Auth validates and forwards to next port
3. Logging records request and forwards
4. Metrics measures and forwards
5. Application processes at final port
6. Response flows back through chain (metrics → logging → auth → client)

---

## Comparison with Related Work

### Service Mesh Solutions
- **Istio/Envoy:** Comprehensive but inflexible filter composition
- **Linkerd:** Focus on networking, less extensible
- **Cilium:** eBPF-based, specialized for networking/security

**K8Sidecar Advantage:** Deploy-time composition, independent testing

### Kubernetes Patterns
- **Init Containers:** Run before application (not during requests)
- **Sidecar Containers:** Co-located but typically single-purpose
- **Admission Controllers:** Used by K8Sidecar for injection mechanism

**K8Sidecar Innovation:** Chaining multiple sidecars with priority ordering

---

## Future Research Directions

### Identified by Authors
1. Optimize inter-container communication (reduce HTTP overhead)
2. Support more languages (Python, Rust, etc.)
3. Advanced routing strategies (conditional sidecar execution)
4. Integration with service mesh control planes

### Potential DMEI Extensions
1. **Observability-Specific Filters:**
   - Pre-built monitoring sidecars (Prometheus exporter, Jaeger agent)
   - Standard observability chains for CI/CD
2. **Performance Optimization:**
   - Shared memory IPC instead of HTTP
   - Compiled Go sidecars for faster cold start
3. **Multi-Cluster Support:**
   - Sync Filters across clusters
   - Consistent observability in multi-region deployments
4. **Serverless Optimization:**
   - Minimize cold start for ephemeral functions
   - Selective sidecar injection based on function type

---

## Keywords
Kubernetes, Microservices, Sidecar Pattern, Operator Pattern, Dynamic Injection, Proxy Chaining, Serverless Computing, Knative, CloudEvents, Modular Architecture, Service Mesh

---

## Notes
- **Novel Contribution:** First system to enable deploy-time sidecar chain composition in Kubernetes
- **Practical Tool:** Provides working implementation with libraries (not just concept)
- **Performance Trade-off:** Flexibility costs ~acceptable overhead for ≤5 sidecars
- **Developer-Friendly:** Libraries abstract complexity, lambda functions supported
- **Production-Ready:** Published in SPE journal (peer-reviewed), includes real evaluation
- **Open Questions:** Scalability beyond 5 sidecars, security isolation between chained sidecars
