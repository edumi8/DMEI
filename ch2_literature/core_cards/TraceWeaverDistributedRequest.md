# TraceWeaverDistributedRequest

## Problem addressed
Monitoring and debugging modern cloud-based microservices is challenging since even a single API call can involve many interdependent distributed services. Traditional distributed tracing frameworks require instrumenting every component to add and propagate tracing headers, which has slowed adoption.

## Observability mechanism
- Non-intrusive request tracing without application instrumentation (no context propagation)
- Spans obtained via eBPF hooks or service mesh sidecars (request-response pairs with timestamps, caller, callee, API endpoint)
- Call graphs inferred from test environments or production data
- Trace reconstruction algorithm using timing analysis and statistical heuristics

## Privilege assumptions
Host-based or privileged container access required to use eBPF hooks or service mesh sidecars for intercepting network traffic and obtaining span metadata (caller, callee, timestamps, endpoints).

## Application code modification
No. TraceWeaver explicitly avoids any application code modification. It treats the application as unmodifiable and leverages external observability mechanisms (eBPF, sidecars) to collect span data.

## Telemetry signals
Traces (reconstructed from spans). Spans include: request-response pairs, timestamps (start/end), caller/callee identifiers, API endpoints. Call graphs (service-to-service dependencies and order).

## Collection pattern
External/host-based collection using eBPF or service mesh sidecars. Span metadata captured at network layer without application cooperation. Test environments used for call graph inference.

## Evaluation performed
Evaluated on DeathStarBench microservices applications and Alibaba production dataset. Measured trace reconstruction accuracy (90-99% under variable high loads). Demonstrated two use cases: identifying slow backend services and detecting performance changes during A/B testing.

## Overhead reported
Not stated. Focus is on accuracy of trace reconstruction, not performance overhead of the observability mechanism itself.

## Constraints discussed by authors
Requires ability to intercept network traffic (via eBPF or sidecars) which may need host/kernel-level access. Assumes call graphs can be inferred from test environments or production observation. Accuracy degrades with highly dynamic call graphs or extreme concurrency. Imperfect accuracy (90-99%) means some traces reconstructed incorrectly.

## Fit or break under constrained CI/CD
- Requires eBPF or service mesh sidecars for span capture, which may be blocked in restricted CI/CD environments without kernel/host access or privileged container permissions.
- Call graph inference requires either test environments (additional infrastructure) or production observation (may not exist in ephemeral CI/CD pipelines).
- No application code modification required, making it compatible with fast-moving CI/CD workflows and legacy/proprietary components.
- External collection pattern avoids export stage overhead but depends on network visibility, which may be restricted in isolated CI/CD networks or sandboxed containers.
