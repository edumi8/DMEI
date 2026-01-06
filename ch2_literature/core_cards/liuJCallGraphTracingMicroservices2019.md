# liuJCallGraphTracingMicroservices2019

## Problem addressed
Monitoring tens of thousands of microservices and debugging problems among massive microservices is extremely challenging. Tracing 34,000 microservices with 500,000 containers and 250 billion RPC calls per day at JD.com requires minimal overhead and zero application intrusion.

## Observability mechanism
- Distributed tracing via physical chains (actual request-response flow) and logical chains (business logic flow)
- Tracing primitives (startTrace, endTrace, clientSend, serverRecv, etc.) inserted into core middlewares (JSF, JMQ, JIMDB)
- Java bytecode instrumentation for multi-threaded asynchronous invocation context propagation
- k-Shape clustering for offline analysis of invocation patterns

## Privilege assumptions
None / not stated (middleware-level instrumentation; no kernel or privileged container access mentioned)

## Application code modification
No – zero intrusion to application code; tracing points placed only in underlying RPC middleware (JSF), messaging queue (JMQ), and in-memory database (JIMDB)

## Telemetry signals
Traces (spans with trace ID, span ID, parent span ID, timestamps, service IDs)

## Collection pattern
In-container agent (unlocked ring memory buffer per application); push via long-lived TCP to 16-node transfer cluster; real-time data in JIMDB (in-memory), offline data in Elasticsearch

## Evaluation performed
- Real production at JD.com: 8000+ applications, 34,000 microservices, 500,000 containers, 250 billion RPC calls/day
- Stress test: HP LoadGenerator on 4 clients + 1 server (Intel Xeon E5620 @ 2.4GHz, 32GB RAM, 1GB network); loads from 10K to 170K requests/sec
- Transfer layer test: 1 Docker container server (4 CPU, 8GB, 10G ethernet) + 50 client containers

## Overhead reported
- CPU: ~1% overhead at 20K requests/sec (typical production load); max 4.9% at 170K requests/sec
- Latency: 99th percentile latency almost identical with/without tracing
- Message size: 112 bytes per invocation context after compression (1/10 compression ratio by exploiting context similarity)
- Sampling: Low-rate sampling (e.g., 1:4000) dramatically reduces transfer traffic proportionally

## Constraints discussed by authors
- Short UUID (8 hex characters instead of 32) to reduce overhead while accepting 1-in-a-million collision probability
- All tracing operations in-memory; if ring buffer full, contexts are dropped (relies on retrying to reconstruct invocation graph)
- Network bandwidth consumption increases with message size and non-sampled traces
- High compression achieved because same invocation chain shares static context

## Fit or break under constrained CI/CD
- **Fits**: 1% CPU overhead at typical load is acceptable for resource-constrained CI/CD
- **Fits**: Zero application code modification aligns with no-code-change CI/CD requirement
- **Breaks**: Requires instrumentation of RPC middleware (JSF, JMQ, JIMDB), which may not be present or modifiable in standard CI/CD environments
- **Fits**: Low-rate sampling (1:4000) and context dropping under load provide graceful degradation under resource pressure
