# Chapter 2 Continuation: Logical Progression Summary

**Date:** January 6, 2026  
**Author:** GitHub Copilot  
**Task:** State of the Art continuation (Sections 2.3–2.7)

## Overview

This document outlines the logical progression of Chapter 2 from Section 2.3 onward, following the methodological foundation and preliminary synthesis established in Sections 2.1–2.2.

## Structural Rationale

The continuation of Chapter 2 systematically deepens the critical analysis of observability research, moving from surface-level literature categorization to structural critique that exposes the limitations of existing work when applied to constrained CI/CD environments. The progression follows a funnel structure:

1. **Section 2.3** — Examines **what** the literature assumes (deployment patterns, privilege requirements, instrumentation approaches)
2. **Section 2.4** — Analyzes **how** the literature evaluates systems (methodologies, metrics, reported overheads)
3. **Section 2.5** — Identifies **why** these assumptions fail in constrained contexts (environment mismatches, heterogeneity, correlation challenges)
4. **Section 2.6** — Broadens the lens to **practitioner perspectives** (industry practices, vendor documentation, logging-centric approaches)
5. **Section 2.7** — Synthesizes **gaps** and **implications** for the research agenda

## Section-by-Section Summary

### Section 2.3: Instrumentation and Deployment Assumptions in the Literature

**Purpose:** Establish that the majority of reviewed research presumes operational capabilities unavailable in privilege-restricted CI/CD deployments.

**Key Points:**
- Host-level administrative access (privileged containers, Docker socket access, cgroup interfaces)
- Kernel-level instrumentation (eBPF requiring CAP_BPF, kernel v5.15+, DaemonSet deployments)
- Sidecar patterns (orchestrator-managed injection, resource multipliers, microarchitectural contention)
- These patterns are effective in homogeneous cloud platforms but present barriers in heterogeneous or restricted environments

**Contribution:** Demonstrates that architectural feasibility and privilege requirements are distinct dimensions requiring independent assessment.

### Section 2.4: Performance Evaluation Practices and Reported Overheads

**Purpose:** Characterize the methodological heterogeneity and performance implications documented in the literature.

**Key Points:**
- Experimental design varies widely (synthetic benchmarks, production workloads, load generation techniques)
- Overhead metrics are reported inconsistently (CPU %, memory footprints, throughput degradation, latency percentiles)
- eBPF solutions demonstrate 21–214× lower CPU usage than alternatives
- Network flow monitoring via eBPF incurs ~10% throughput degradation
- Full-stack tracing with OpenTelemetry shows 19–80% throughput reduction and 7–175% latency increases
- Tail-based sampling amplifies collector CPU by 71% vs. head-based sampling

**Contribution:** Quantifies the performance tradeoffs inherent in different instrumentation techniques and highlights the absence of standardized benchmarking protocols.

### Section 2.5: Discrepancies Between Research Environments and Constrained CI/CD Contexts

**Purpose:** Surface the structural misalignment between research assumptions and operational realities of on-premise CI/CD systems.

**Key Points:**
- Orchestrator-mediated management (Kubernetes-centric assumptions) not applicable to unprivileged container executors
- Homogeneous execution environments (uniform kernel versions, consistent runtimes) vs. heterogeneous infrastructure
- Code modifiability assumptions (purpose-built microservices) vs. third-party packaged software
- Correlation mechanisms designed for long-lived services don't transfer to ephemeral task-based workloads
- Temporal and architectural characteristics of CI/CD (short-lived containers, stateless execution) differ from microservice patterns

**Contribution:** Establishes that the CI/CD observability problem requires adapted techniques rather than direct application of microservice-oriented research.

### Section 2.6: Practitioner-Oriented Approaches and Industry Practices

**Purpose:** Complement academic research with industry perspectives, operational pragmatism, and real-world deployment experiences.

**Key Points:**
- OpenTelemetry deployment patterns (agent-per-host, centralized gateways) address operational tradeoffs
- Prometheus pull-based metrics with service discovery for dynamic environments
- Grafana Loki log aggregation without full-text indexing (storage vs. query expressiveness tradeoff)
- Vendor technical reports document multi-tenant challenges, data retention policies, tool sprawl
- Hybrid push-pull patterns for firewall traversal and egress-only networks
- Logging-centric observability as pragmatic compromise (structured logs, correlation identifiers, pattern matching)
- Jenkins/GitLab emphasis on log-based troubleshooting reflects operational reality

**Contribution:** Demonstrates that industry practices prioritize operational feasibility over signal completeness, revealing a gap between documented best practices and evidence-based validation.

### Section 2.7: Identified Gaps and Implications for Constrained CI/CD Observability

**Purpose:** Synthesize the critical gaps revealed by Sections 2.3–2.6 and establish the research agenda for subsequent chapters.

**Key Gaps Identified:**

1. **Non-privileged telemetry collection:** Sidecar evaluations occur in orchestrated environments; standalone or VM-based runners underexplored
2. **Post hoc correlation:** Distributed tracing emphasizes in-band context propagation; retrospective correlation using pipeline metadata not systematically characterized
3. **Ephemeral workload instrumentation:** Third-party packaged software in CI/CD pipelines receives minimal attention vs. custom microservices
4. **Evaluation methodologies:** Standard benchmarks (Online Boutique, DeathStarBench) model synchronous request-response; CI/CD batch semantics differ
5. **MTTD/MTTR operationalization:** Lack of standardized definitions in CI/CD contexts (alert trigger vs. operator awareness vs. automated remediation)
6. **Reproducible artifacts:** Absence of CI/CD-specific workload benchmarks, fault injection scenarios, instrumentation templates
7. **Operational constraints:** Multi-tenant shared infrastructure, data residency requirements, restricted network egress underaddressed

**Contribution:** Establishes clear boundaries for subsequent research contributions and motivates the prototype design, evaluation methodology, and empirical studies in Chapters 3–4.

## Integration with Earlier Sections

This continuation builds directly on:

- **Section 2.1 (PRISMA):** Methodological rigor established earlier validates the systematic synthesis in Sections 2.3–2.7
- **Section 2.2 (Representative Studies):** Specific citations (Pappula et al., Siddiqui et al.) grounded the preliminary findings; Sections 2.3–2.7 expand to 26 core papers
- **Evidence extraction and comparison matrices:** Inform the categorization of privilege assumptions, deployment patterns, and overhead reports

## Alignment with Research Questions (Implicit)

While the research questions are not restated explicitly (per instructions), the continuation maintains alignment:

- **RQ1 (Feasibility):** Sections 2.3 and 2.5 expose privilege constraints and non-privileged pattern gaps
- **RQ2 (Deployment patterns):** Sections 2.3 and 2.6 analyze sidecar, agent, and kernel-level approaches
- **RQ3 (Overhead and correlation):** Section 2.4 quantifies performance tradeoffs; Section 2.5 addresses correlation challenges

## Writing Quality Assurance

All sections adhere to the specified writing requirements:

- ✅ Formal academic tone suitable for Master's dissertation
- ✅ Full paragraphs, not bullet points or outlines
- ✅ Avoid prescriptive or normative language
- ✅ Reference prior sections implicitly (e.g., "as discussed in the previous sections")
- ✅ No new terminology not grounded in the literature
- ✅ No solution proposals or implementation recommendations
- ✅ Harvard citation style maintained throughout

## Bibliography Completeness

All cited works have been added to `mainbibliography.bib`:

- correiaMonintainerOrchestrationindependentExtensible2023
- dingaEmpiricalEvaluationEnergy2023
- hasanthEvaluatingPerformanceSidecarbased2024
- salcedo-navarroK8sidecarModularKubernetes2025
- sharmaEBPFEnhancedCompleteObservability2024
- kannanDesigningLightweightNetwork2024
- sahuSidecarsCentralLane2023
- liuJCallGraphTracingMicroservices2019
- TraceWeaverDistributedRequest
- InvestigatingPerformanceOverhead
- karkanPerformanceOverheadOpenTelemetry
- norgrenOPTIMIZINGDISTRIBUTEDTRACING
- ramachandranFUSEFaultDiagnosis2023
- levinViperProbeUsingEBPF2020
- janecekContainerWorkloadCharacterization2021
- piProfilingDistributedSystems2018
- raithEndtoEndFrameworkBenchmarking2022
- tanResearchLightweightService2023
- taylorOpenFormatScalable2020
- usmanDESKDistributedObservability2023
- soldaniEBPFNewApproach2023
- sharmaIMPROVINGMICROSERVICESOBSERVABILITY2023
- sandbergEvaluatingOpenTelemetrysImpact
- grossmannMonitoringContainerServices2017

## Next Steps

The user should:

1. Review the drafted sections for technical accuracy and alignment with thesis scope
2. Build the LaTeX document to verify citation links and formatting
3. Consider whether additional subsections are warranted within Sections 2.3–2.7
4. Proceed to Chapter 3 (Planning/Design) grounded in the gaps identified in Section 2.7

---

**Note:** This continuation completes the State of the Art chapter. No solution design, architecture proposals, or implementation details have been introduced, maintaining strict adherence to the research-only scope.
