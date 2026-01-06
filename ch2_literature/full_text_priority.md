# PRISMA Full-Text Review Priority Classification

**Date:** 2026-01-05  
**Stage:** Full-Text Review Priority Assignment  
**Reviewer:** AI Assistant (Methodological Review)

---

| Citation key                                             | PRISMA decision   | Full-text priority | Justification                                                        |
|----------------------------------------------------------|-------------------|--------------------|----------------------------------------------------------------------|
| correiaMonintainerOrchestrationindependentExtensible2023 | Keep for skim     | Core               | Empirical tool evaluation, overhead metrics, container-level access  |
| dingaEmpiricalEvaluationEnergy2023                       | Keep for skim     | Core               | Energy and performance overhead metrics for Docker monitoring        |
| faseehaObservabilityMicroservicesInDepth2025             | Keep for skim     | Context            | Survey providing taxonomy, no deployable mechanism                   |
| gomesSystematicMappingStudy2025                          | Keep for skim     | Context            | Systematic mapping study, tools catalog, no mechanism                |
| grossmannMonitoringContainerServices2017                 | Keep for skim     | Core               | Lightweight agent, overhead evaluation, resource-constrained devices |
| hasanthEvaluatingPerformanceSidecarbased2024             | Keep for skim     | Core               | Sidecar vs eBPF overhead comparison, privilege assumptions explicit  |
| hausenblasCloudObservabilityAction2024                   | Keep for skim     | Context            | Book providing terminology and open standards background             |
| InvestigatingPerformanceOverhead                         | Keep for skim     | Core               | Distributed tracing overhead measurements, empirical evaluation      |
| janecekContainerWorkloadCharacterization2021             | Keep for skim     | Core               | Host-level system tracing, privilege level explicit                  |
| kannanDesigningLightweightNetwork2024                    | Keep for skim     | Core               | eBPF network observability, overhead metrics, kernel privilege       |
| karkanPerformanceOverheadOpenTelemetry                   | Keep for skim     | Core               | OpenTelemetry sampling overhead evaluation, empirical results        |
| karkanPerformanceOverheadOpenTelemetry2024               | Keep for skim     | Drop               | Duplicate of karkanPerformanceOverheadOpenTelemetry                  |
| levinViperProbeUsingEBPF2020                             | Keep for skim     | Core               | eBPF observability without modification, privilege explicit          |
| liuJCallGraphTracingMicroservices2019                    | Keep for skim     | Core               | Zero-intrusion tracing, overhead evaluation, massive scale           |
| mamunINTEGRATIONARTIFICIALINTELLIGENCE2024               | Keep for skim     | Context            | Systematic review of AI+DevOps, no deployable mechanism              |
| molkovaModernDistributedTracing2023                      | Keep for skim     | Context            | Book on distributed tracing, instrumentation patterns                |
| norgrenOPTIMIZINGDISTRIBUTEDTRACING                      | Keep for skim     | Core               | Overhead optimization evaluation, resource constraint analysis       |
| pappulaBuildingObservabilityFullStack2021                | Keep for skim     | Core               | Unified observability model, MTTD/MTTR empirical evaluation          |
| piProfilingDistributedSystems2018                        | Keep for skim     | Core               | Non-intrusive profiling, container-level, overhead evaluation        |
| ProfilingDistributedSystems                              | Keep for skim     | Drop               | Duplicate of piProfilingDistributedSystems2018                       |
| raithEndtoEndFrameworkBenchmarking2022                   | Keep for skim     | Core               | Benchmarking with monitoring instrumentation, overhead evaluation    |
| ramachandranFUSEFaultDiagnosis2023                       | Keep for skim     | Core               | eBPF fault diagnosis, third-party cloud constraints explicit         |
| sahuSidecarsCentralLane2023                              | Keep for skim     | Core               | Sidecar overhead microarchitectural analysis, resource utilization   |
| salcedo-navarroK8sidecarModularKubernetes2025            | Keep for skim     | Core               | Modular sidecar overhead evaluation, deployment-time composition     |
| sandbergEvaluatingOpenTelemetrysImpact                   | Keep for skim     | Core               | OpenTelemetry performance impact evaluation, telemetry cost          |
| sharmaEBPFEnhancedCompleteObservability2024              | Keep for skim     | Core               | eBPF observability, overhead reduction vs traditional tools          |
| sharmaIMPROVINGMICROSERVICESOBSERVABILITY2023            | Keep for skim     | Core               | eBPF observability without modification, automated anomaly detection |
| silvaPerformanceEvaluationCloud2025                      | Keep for skim     | Context            | Systematic mapping of metrics and tools, no mechanism                |
| soldaniEBPFNewApproach2023                               | Keep for skim     | Core               | eBPF runtime instrumentation, energy and overhead evaluation         |
| tanResearchLightweightService2023                        | Keep for skim     | Core               | eBPF lightweight service mesh, resource consumption analysis         |
| taylorOpenFormatScalable2020                             | Keep for skim     | Core               | System telemetry format, storage overhead reduction empirical        |
| TraceWeaverDistributedRequest                            | Keep for skim     | Core               | Zero-modification tracing, third-party service constraint explicit   |
| usmanDESKDistributedObservability2023                    | Keep for skim     | Core               | Integrated observability workflow, edge overhead evaluation          |
| usmanSurveyObservabilityDistributed2022                  | Keep for skim     | Context            | Survey on edge observability, design considerations                  |

---

**Classification Summary:**

- **Core:** 26 papers — Empirical evaluations, overhead measurements, deployable mechanisms
- **Context:** 6 papers — Surveys, books, taxonomies, background material
- **Drop:** 2 papers — Duplicates

**Notes:**

- Papers with explicit privilege assumptions (kernel, eBPF, host-level) are marked **Core** because they document incompatibility with constrained environments, which is essential for justifying alternative approaches.
- Papers requiring application code modification (OpenTelemetry SDK integration) are marked **Core** when they provide empirical overhead data, as this informs cost-benefit analysis even if not directly applicable.
- Survey and mapping studies are classified **Context** as they provide taxonomy and tool catalogs without deployable mechanisms.
- Duplicate entries are marked **Drop**.
