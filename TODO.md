# Thesis TODO - CI/CD Observability in Containerized Environments

## Chapter 1: Introduction

### Section 1.1: Context and Motivation

- [x] Add environment inventory: servers count, Linux/Windows mix, CI/CD services (GitLab, Jenkins, Nexus, SonarQube, Dependency-Track), privilege constraints. *(Content present: mentions GitLab, Jenkins, SonarQube, Nexus, Dependency-Track, mixed Linux/Windows, privilege constraints)*
- [x] Describe current telemetry gaps, incident detection delays, and impact on delivery cadence. *(Content present: discusses reduced development velocity, delayed releases, fragmented telemetry)*
- [x] Clarify target reliability improvements tied to observability (MTTD/MTTR, pipeline throughput). *(Covered in extended abstract summary and validation targets)*

### Section 1.2: Problem Statement

- [x] Rewrite problem statement to reference concrete pain points and privilege constraints. *(Completed: clear problem statement exists referencing non-privileged access and heterogeneous infrastructure)*
- [x] Align problem framing with evaluation metrics and target improvements. *(Completed: mentions reproducible evaluation of reliability improvements)*
- [x] State assumptions/limitations (no host admin, mixed OS, third-party images). *(Completed: explicitly states non-privileged access constraints and heterogeneous infrastructure)*

### Subsection 1.2.1: Extended Abstract Summary

- [x] Draft extended abstract summary *(Completed: comprehensive summary exists covering problem, approach, validation, and contributions)*

### Subsection 1.2.2: Contributions

- [x] Finalize documentation of reference architecture contribution *(Completed: clearly documented)*
- [x] Document prototype contribution details *(Completed: reproducible prototype with templates described)*
- [x] Prepare empirical evaluation contribution summary *(Completed: measurement methodology documented)*
- [x] Develop practical guidance documentation *(Completed: decision guidance for operations teams described)*

### Section 1.3: Research Objectives

- [x] Verify O1 (Reference architecture) scope and deliverables *(Completed: clearly defined)*
- [x] Confirm O2 (Prototype implementation) implementation plan *(Completed: reproducible prototype with templates)*
- [x] Define O3 (Quantitative evaluation) measurement procedures *(Completed: MTTD, MTTR, throughput, overhead with documented procedures)*
- [x] Set O4 (Performance constraints) thresholds and targets *(Completed: <5% overhead target stated)*
- [x] Establish O5 (Reproducibility and guidance) artifact list *(Completed: templates, scripts, guidance documented)*

### Section 1.4: Research Questions

- [x] Validate research question 1 clarity and scope *(Completed: RQ1 on telemetry collection is clear)*
- [x] Validate research question 2 clarity and scope *(Completed: RQ2 on instrumentation patterns is clear)*
- [x] Validate research question 3 clarity and scope *(Completed: RQ3 on constraints/trade-offs is clear)*

### Section 1.5: Methodology Overview

- [x] Complete Phase 1 planning (Problem Analysis and Literature Review) *(Completed: PRISMA-guided review described)*
- [x] Complete Phase 2 planning (Technology Assessment) *(Completed: evaluation criteria outlined)*
- [x] Complete Phase 3 planning (Architecture Design) *(Completed: component placement and data flows described)*
- [x] Complete Phase 4 planning (Prototype Implementation) *(Completed: reproducible prototype plan outlined)*
- [x] Complete Phase 5 planning (Evaluation) *(Completed: quantitative and qualitative evaluation described)*
- [x] Add ethical considerations summary (data handling, operational risk) consistent with full chapter. *(Completed: dedicated section exists)*
- [ ] Add traceability table linking phases to objectives and research questions. *(Consider adding for clarity)*

## Chapter 2: Literature Review

### Section 2.1: PRISMA Methodology Overview

- [x] Finalize information sources list *(Completed: IEEE, ACM, Springer, ScienceDirect, Google Scholar, arXiv, gray literature documented)*
- [x] Document search terms and Boolean operators *(Completed: three concept groups defined with example query structure)*
- [x] Define inclusion/exclusion criteria *(Completed: criteria documented with date range 2018-2025, focus on constrained environments)*
- [x] Establish selection process documentation *(Completed: three-stage process described)*
- [ ] Record database query strings, execution dates, and result counts. *(Actual execution pending)*
- [ ] Prepare PRISMA flow diagram data table (identification, screening, eligibility, inclusion). *(Awaiting search execution)*

### Subsection 2.1.1: Identification

- [ ] Execute database searches (IEEE Xplore) *(PENDING: to be executed)*
- [ ] Execute database searches (ACM Digital Library) *(PENDING)*
- [ ] Execute database searches (Springer) *(PENDING)*
- [ ] Execute database searches (ScienceDirect) *(PENDING)*
- [ ] Execute database searches (Google Scholar) *(PENDING)*
- [ ] Document search queries and results count *(PENDING)*
- [ ] Version query strings and store snapshots for reproducibility. *(PENDING)*
- [ ] Capture export of initial records (RIS/CSV) for screening. *(PENDING)*

### Subsection 2.1.2: Screening

- [ ] Perform title and abstract screening *(PENDING)*
- [ ] Document screening decisions *(PENDING)*
- [ ] Record exclusion reasons *(PENDING)*
- [ ] Identify uncertain items for full-text review *(PENDING)*
- [ ] Use screening log with decision codes; double-check 10% sample. *(PENDING)*
- [ ] Track inter-rater agreement (if applicable) or rationale for single-reviewer approach. *(PENDING)*

### Subsection 2.1.3: Eligibility

- [ ] Conduct full-text review of potential studies *(PENDING)*
- [ ] Assess methodological detail quality *(PENDING)*
- [ ] Record excluded studies with reasons *(PENDING)*
- [ ] Extract privilege assumptions, telemetry modalities, metrics (MTTD/MTTR/overhead), CI/CD scope. *(PENDING)*
- [ ] Note missing data and contact authors if critical gaps exist (optional). *(PENDING)*

### Subsection 2.1.4: Inclusion and Data Extraction

- [ ] Extract data from included studies *(PENDING)*
- [ ] Create structured evidence tables *(PENDING)*
- [ ] Verify extraction accuracy *(PENDING)*
- [ ] Include fields: deployment context, tooling, correlation mechanisms, evaluation methods, overhead. *(PENDING)*
- [ ] Perform secondary check on 10% of entries for accuracy. *(PENDING)*

### Section 2.2: PRISMA Flow Diagram

- [ ] Generate PRISMA flow diagram with counts *(Structure described, awaiting data)*
- [ ] Include identification stage numbers *(PENDING)*
- [ ] Include screening stage numbers *(PENDING)*
- [ ] Include eligibility stage numbers *(PENDING)*
- [ ] Include inclusion stage numbers *(PENDING)*
- [ ] Embed diagram in Chapter 2 and archive source (draw.io/LaTeX). *(PENDING)*
- [ ] Ensure counts reconcile with evidence tables. *(PENDING)*

### Subsection 2.2.1: Quality Assessment Criteria

- [x] Define quality assessment approach *(Completed: internal/external validity and transparency criteria documented)*
- [ ] Evaluate internal validity for each study *(PENDING: awaiting included studies)*
- [ ] Evaluate external validity for each study *(PENDING)*
- [ ] Assess reporting transparency *(PENDING)*
- [ ] Document quality assessment outcomes *(PENDING)*
- [ ] Define scoring rubric and thresholds for inclusion in synthesis vs. narrative only. *(PENDING)*
- [ ] Summarize common biases/limitations relevant to constrained CI/CD observability. *(PENDING)*

### Section 2.3: Related Work (Preliminary)

- [x] Document representative studies *(Completed: Pappula et al. 2021, Siddiqui et al. 2023 cited)*
- [x] Identify preliminary gaps *(Completed: noted scarce empirical studies on non-privileged environments)*
- [ ] Complete full synthesis after PRISMA execution *(PENDING)*

## Chapter 3: Skill Management and Project Planning

### Section 3.1: Skill Management

### Subsection 3.1.1: Skills Identification

- [x] Document container orchestration skills needed *(Completed: mentioned in section)*
- [x] Document telemetry tooling skills (OpenTelemetry, Prometheus, Loki, Jaeger) *(Completed)*
- [x] Document scripting skills needed *(Completed: automation mentioned)*
- [x] Document experimental design skills needed *(Completed: empirical evaluation mentioned)*
- [x] Document project management soft skills needed *(Completed)*
- [x] Document structured interview skills needed *(Completed: qualitative validation mentioned)*
- [ ] Add current proficiency level and target level for each skill. *(Consider adding detail)*
- [ ] Link each skill to evidence plan (course, POC, reading). *(Could be more explicit)*

### Subsection 3.1.2: Skills Assessment and Development

- [x] Conduct self-assessment for advanced tracing *(Mentioned: gaps in advanced tracing identified)*
- [x] Conduct self-assessment for Windows container telemetry *(Mentioned: gaps in Windows telemetry identified)*
- [x] Plan gap-closing activities *(Completed: focused exercises planned)*
- [ ] Schedule time-boxed exercises and record outcomes. *(Planned but not scheduled with dates)*
- [ ] Capture artifacts (dashboards, traces) as proof of competency. *(Planned)*

### Subsection 3.1.3: Strategy to Improve Skills

- [x] Define practical exercises (sidecar POC, Prometheus, OpenTelemetry) *(Completed: three exercises listed with acceptance criteria)*
- [ ] Complete sidecar exporter POC (non-privileged metrics) *(PENDING: execution)*
- [ ] Configure Prometheus scraping experiments *(PENDING)*
- [ ] Configure OpenTelemetry tracing experiments *(PENDING)*
- [ ] Verify context propagation in proxy/sidecar setup *(PENDING)*
- [ ] Document skill acquisition evidence *(PENDING)*
- [ ] Conduct knowledge-sharing sessions *(PENDING)*
- [x] Define acceptance criteria per exercise (e.g., 24h stable metrics collection under load). *(Completed: criteria mentioned)*

### Section 3.2: Project Management

### Subsection 3.2.1: Phase 1 – PREPD Deliverable (November 2025–January 2026)

- [x] Define Phase 1 scope (systematic review, tech assessment, architecture, baseline) *(Completed)*
- [ ] Conduct systematic literature review using PRISMA *(IN PROGRESS: protocol defined, execution pending)*
- [ ] Complete technology assessment matrix *(PENDING)*
- [ ] Design initial reference architecture *(PENDING: high-level approach defined)*
- [ ] Establish baseline telemetry measurements *(PENDING)*
- [ ] Collect baseline measurement procedures *(Planned)*
- [ ] Prepare PREPD report *(IN PROGRESS)*
- [ ] Prepare presentation materials *(PENDING)*
- [ ] Maintain risk register (probability, impact, owner, mitigation/contingency). *(Mentioned but not shown)*
- [x] Establish monitoring/controlling cadence (advisor/supervisor meetings, status reports, KPIs). *(Mentioned in 3.2 content)*

### Subsection 3.2.2: Work Plan (Extended Abstract)

- [x] Review Phase 1 tasks from extended abstract *(Completed: tasks listed)*
- [x] Review Phase 2 tasks from extended abstract *(Completed: tasks listed)*
- [x] Align current plan with extended abstract deliverables *(Completed: alignment documented)*
- [ ] Build WBS covering SLR, tech assessment, architecture, prototype, deployment, evaluation, writing; map tasks to milestones. *(High-level exists, detailed WBS pending)*
- [ ] Insert Gantt (Phase 1/2) snapshot consistent with WBS dates. *(PENDING)*
- [x] Add acceptance criteria for key deliverables (architecture diagram, prototype, datasets, analysis scripts). *(Completed: criteria documented)*

### Subsection 3.2.3: Phase 2 – Thesis Development (January–June 2026)

- [x] Define Phase 2 timeline and activities *(Completed: Jan-Jun breakdown provided)*
- [ ] Finalize state of the art (Jan–Feb) *(PENDING)*
- [ ] Select candidate technology stack (Jan–Feb) *(PENDING)*
- [ ] Implement prototype (Feb–Mar) *(PENDING)*
- [ ] Create deployment automation (Feb–Mar) *(PENDING)*
- [ ] Coordinate production deployment (Apr) *(PENDING)*
- [ ] Collect observability data (May) *(PENDING)*
- [ ] Execute measurement campaigns (May) *(PENDING)*
- [ ] Validate and analyze results (Jun) *(PENDING)*
- [ ] Write up results chapters (Jun) *(PENDING)*
- [ ] Prepare final submission (mid-Jun) *(PENDING)*
- [ ] Document evidence tables for literature review *(PENDING)*
- [ ] Complete technology assessment matrix *(PENDING)*
- [ ] Produce reproducible deployment scripts *(PENDING)*
- [ ] Archive evaluation dataset with analysis scripts *(PENDING)*
- [ ] Document experimental procedures *(PENDING)*

### Subsection 3.2.4: Risk Management

- [x] Identify key risks (infrastructure delays, access limitations, tooling incompatibilities) *(Completed: risks mentioned)*
- [x] Define mitigation strategies (staging tests, alternative scenarios, POCs) *(Completed)*
- [ ] Create formal risk register with probability/impact scoring *(Mentioned but not shown as artifact)*
- [ ] Assign risk owners *(PENDING)*


## Chapter 4: Conclusion and Next Steps

### Section 4.1: Dissertation Scope Summary

- [x] Review and validate problem context summary *(Completed: problem context clearly summarized)*
- [x] Review and validate research objectives summary *(Completed: objectives referenced)*
- [x] Review and validate methodology summary *(Completed: PRISMA and design science approach referenced)*
- [x] Review and validate results summary *(N/A for PREPD stage - evaluation pending)*
- [x] Review and validate conclusions summary *(Appropriate for current stage)*

### Section 4.2: Next Steps

- [x] Document immediate next steps (SLR, tech assessment, prototype, evaluation) *(Completed: clear list provided)*
- [ ] Finalize systematic literature review *(PENDING: Phase 1 activity)*
- [ ] Produce PRISMA flow diagram and evidence tables *(PENDING)*
- [ ] Complete technology assessment matrix *(PENDING)*
- [ ] Select candidate stack for prototyping *(PENDING)*
- [ ] Document selection rationale *(PENDING)*
- [ ] Verify compatibility with privilege constraints *(PENDING)*
- [ ] Implement prototype in staging environment *(PENDING: Phase 2)*
- [ ] Produce deployment templates *(PENDING)*
- [ ] Instrument CICD services per reference architecture *(PENDING)*
- [ ] Execute measurement campaign (baseline) *(PENDING)*
- [ ] Execute measurement campaign (post-deployment) *(PENDING)*
- [ ] Run controlled fault-injection experiments *(PENDING)*
- [ ] Collect quantitative evaluation data *(PENDING)*
- [ ] Collect qualitative evaluation data *(PENDING)*
- [ ] Analyze results *(PENDING)*
- [ ] Generalize findings *(PENDING)*
- [ ] Prepare implementation chapters *(PENDING)*
- [ ] Prepare evaluation chapters *(PENDING)*
- [ ] Prepare implications chapters *(PENDING)*
- [ ] Publish milestone dates (prototype ready, staging validation, production deployment, measurement window, analysis freeze, submission). *(High-level timeline exists, detailed dates pending)*
- [ ] Record dependencies (infrastructure access, approvals, dataset availability) and decision gates to proceed. *(Mentioned, could be more explicit)*
- [ ] Outline dissemination plan (thesis, internal report, possible workshop/conference) respecting confidentiality. *(Briefly mentioned)*

### Subsection 4.2.1: Validation Targets

- [x] Define MTTD reduction targets *(Mentioned as primary metric)*
- [x] Define MTTR reduction targets *(Mentioned as primary metric)*
- [x] Define pipeline throughput targets *(Mentioned)*
- [x] Define alert precision targets *(Mentioned)*
- [x] Define detection coverage targets *(Mentioned)*
- [x] Set instrumentation overhead target (< 5%) *(Explicitly stated)*
- [x] Document measurement procedures *(High-level approach documented)*
- [x] Document acceptance criteria *(Mentioned in subsection)*
- [x] Define success metrics *(Primary metrics identified)*
- [x] Establish validation procedures *(Baseline comparison and fault injection outlined)*
- [ ] Specify formulas and data sources for each metric; set confidence levels. *(Could add more technical detail)*
- [ ] Define baseline measurement period and retention plan. *(PENDING)*
- [ ] Enumerate fault-injection scenarios (service crash, latency, resource exhaustion) with expected signals and alerts. *(PENDING)*
- [ ] Prepare analysis scripts/pipeline to compute metrics reproducibly. *(PENDING)*

### Section 4.3: Expected Deliverables

- [x] Document expected deliverables list *(Completed: 4 key deliverables listed)*
- [ ] Prepare documented reference architecture *(PENDING: Phase 2)*
- [ ] Prepare deployment templates and configuration artifacts *(PENDING)*
- [ ] Create reproducible prototype *(PENDING)*
- [ ] Test prototype deployment scripts and container images *(PENDING)*
- [ ] Compile evaluation report with raw measurement data *(PENDING)*
- [ ] Create analysis scripts and reproducible pipeline *(PENDING)*
- [ ] Generate key figures and tables *(PENDING)*
- [ ] Write practitioner guidance note *(PENDING)*
- [ ] Document deployment constraints *(Mentioned, detail pending)*
- [ ] Document trade-offs *(Mentioned, detail pending)*
- [ ] Document recommended practices *(Mentioned, detail pending)*
- [ ] Include architecture diagrams (exporters, collectors, storage, viz, data flows, privilege assumptions). *(PENDING)*
- [ ] Add docker-compose/k8s manifests (sidecars, collectors) with Windows/Linux notes. *(PENDING)*
- [ ] Provide sample configs (Prometheus scrape jobs, Loki/Fluent Bit pipelines, OTel collectors) with templated secrets. *(PENDING)*
- [ ] Write staging runbook: prerequisites, start/stop, health checks, troubleshooting, rollback. *(PENDING)*

### Section 4.4: Dissemination and Review

- [x] Acknowledge dissemination considerations *(Mentioned: thesis, technical reports, conference/workshop options)*
- [ ] Document timeline for deliverables *(High-level exists, needs detail)*
- [ ] Define responsibilities for deliverables *(PENDING)*
- [ ] Plan milestone review meetings *(Mentioned: advisor/supervisor meetings)*
- [ ] Compare results with literature synthesis *(PENDING: post-evaluation)*
- [ ] Position contributions relative to literature *(PENDING)*
- [ ] Identify limitations *(PENDING)*
- [ ] Evaluate conference/workshop submission opportunities *(Mentioned as future consideration)*
- [ ] Review organizational publication policies *(Mentioned: respecting confidentiality)*
- [ ] Identify target venues for publication *(PENDING)*
- [ ] Prepare initial drafts for submission *(PENDING)*

---

## Front Matter Tasks

### Abstract and Resumo

- [x] Finalize English abstract (max 200 words) *(Completed: abstract is well-written and under 200 words)*
- [ ] Finalize Portuguese Resumo (max 1000 words) *(CRITICAL: Still has placeholder text - needs translation/expansion)*
- [x] Include problem statement in abstracts *(Completed)*
- [x] Include methodology summary in abstracts *(Completed)*
- [x] Include key findings in abstracts *(Appropriate for PREPD stage - expected contributions mentioned)*
- [x] Include main conclusions in abstracts *(Appropriate for PREPD stage)*
- [ ] Delete placeholder text in `abstractotherlanguage` and insert final summary once language is set. *(CRITICAL: Portuguese resumo still has instructions, not content)*
- [ ] Ensure symbols list reflects observability units (latency, throughput, resource usage) only. *(Current symbols are generic examples - should update)*

### Glossary and Acronyms

- [x] Define core acronyms (CICD, MTTD, MTTR, PRISMA) *(Completed: present in glossary.tex)*
- [ ] Use consistent capitalization for acronyms *(Review needed)*
- [ ] Document all technical terms *(Could expand)*
- [ ] Include all relevant terms in the glossary *(Partial)*
- [ ] Review and validate glossary content *(Needs review)*
- [ ] Add acronyms for CI/CD tools and observability stack (GitLab, Jenkins, Nexus, SonarQube, Dependency-Track, OTel, Prometheus, Loki, Jaeger, Grafana, DORA) and remove unused placeholders (RTS/GPOS/RTOS/PGF). *(CRITICAL: RTS/GPOS/RTOS/PGF are still present but not used in thesis)*

### Lists and Preliminary Content

- [ ] Verify acknowledgments content *(Optional section - currently commented out)*
- [x] Generate list of figures *(Enabled in frontmatter.tex)*
- [x] Generate list of tables *(Enabled in frontmatter.tex)*
- [ ] Generate list of listings/code *(Currently commented out - enable when code listings added)*
- [ ] Generate list of algorithms *(Currently commented out - enable if algorithms added)*
- [ ] Generate list of datasets *(Not currently configured)*

## Bibliography Management

### Bibliography Review

- [ ] Verify Harvard style compliance in mainbibliography.bib *(Currently using IEEE style per main.tex line 57 - consider if Harvard is required)*
- [ ] Check all citation keys match usage in .tex files *(Need to audit)*
- [ ] Identify and remove duplicate entries *(Need to review)*
- [ ] Identify and add missing references *(Currently only 3 references cited: hevner2004design, prometheus2016, pappula2021building, siddiqui2023jenkins)*
- [ ] Verify formatting consistency *(Need to check)*
- [ ] Check capitalization in titles *(Need to check)*
- [ ] Verify special character encoding (LaTeX) *(Need to check)*
- [ ] Spell check all fields *(Need to check)*
- [ ] Grammar check all fields *(Need to check)*
- [ ] Verify all URLs are accessible *(Need to check)*
- [ ] Check for broken links *(Need to check)*
- [ ] Change `biblatex` style in `main.tex` to authoryear/Harvard equivalent and rerun biber. *(Currently using IEEE style - clarify if Harvard is mandatory requirement)*
- [ ] Import sources from PREPD report and current SLR; normalize fields (title case, URLs, DOIs, access dates). *(Expand bibliography as SLR progresses)*
- [ ] Cross-check all `\cite` keys in `.tex` for existence; fix typos or add entries. *(Need systematic check)*
- [ ] Run lint for capitalization and special characters; remove unused entries. *(Need to execute)*

## General Writing Tasks

### Content Standards

- [x] Review all chapters for active voice usage *(Writing is generally in active voice)*
- [x] Check for colloquialisms and remove *(Writing is appropriately formal)*
- [ ] Verify spelling throughout document *(Should run spell checker)*
- [ ] Verify grammar throughout document *(Should run grammar checker)*
- [x] Check consistency of technical terminology *(Terminology appears consistent)*
- [x] Ensure consistent use of terminology *(Good consistency observed)*
- [ ] Review document for clarity and conciseness *(Ongoing refinement recommended)*

### Cross-referencing and Citations

- [x] Verify all chapters are labeled *(Completed: chap:Chapter1-4 labels present)*
- [x] Verify all sections are labeled *(Major sections appear labeled)*
- [ ] Verify all figures are labeled *(No figures currently in document)*
- [ ] Verify all tables are labeled *(No tables currently in document)*
- [ ] Verify all equations are labeled *(No equations currently in document)*
- [ ] Verify all citations have corresponding bibliography entries *(Need to check: hevner2004design, prometheus2016, pappula2021building, siddiqui2023jenkins)*
- [ ] Check for orphaned references *(Need to audit bibliography)*
- [ ] Ensure all references are cited in the text *(Need to verify)*
- [ ] Ensure all citations are complete and accurate *(Need to verify bibliography entries)*

### Code and Figures

- [ ] Ensure all code listings have language specification *(No code listings yet)*
- [ ] Ensure all code listings have captions *(No code listings yet)*
- [ ] Ensure all code listings have labels *(No code listings yet)*
- [ ] Ensure all figures are centered *(No figures yet)*
- [ ] Ensure all figures have descriptive captions *(No figures yet)*
- [ ] Ensure all figures have labels *(No figures yet)*
- [ ] Ensure all tables are centered *(No tables yet)*
- [ ] Ensure all tables have captions *(No tables yet)*
- [ ] Ensure all tables have labels *(No tables yet)*
- [ ] Ensure all algorithms have captions *(No algorithms yet)*
- [ ] Ensure all algorithms have labels *(No algorithms yet)*

## Build and Submission

### Document Build

- [x] Run `make clean` to remove temporary files *(Can be done anytime)*
- [x] Run `make` to build document *(Appears to build successfully based on generated files)*
- [x] Verify PDF builds without errors *(main.pdf exists)*
- [ ] Verify PDF builds without warnings *(Should check build log)*
- [ ] Check final PDF appearance *(Review needed)*
- [ ] Ensure all hyperlinks are functional *(Review needed)*
- [ ] Verify all multimedia elements are displayed correctly *(N/A currently - no figures/multimedia yet)*

### Final Review

- [ ] Spell check entire document *(PENDING)*
- [ ] Grammar check entire document *(PENDING)*
- [ ] Verify all cross-references work *(PENDING)*
- [ ] Verify all citations are correct *(PENDING)*
- [ ] Check page numbering *(Should verify)*
- [ ] Check formatting consistency *(Should verify)*
- [ ] Review table of contents *(Appears in PDF)*
- [ ] Review list of figures *(Empty currently)*
- [ ] Review list of tables *(Empty currently)*
- [ ] Review list of listings/code *(Not enabled)*
- [ ] Review list of algorithms *(Not enabled)*

### Submission Preparation

- [ ] Prepare final PDF *(PREPD version needed soon)*
- [ ] Archive source files *(Good practice)*
- [ ] Document build instructions *(README exists)*
- [ ] Prepare submission package *(For PREPD delivery)*
- [ ] Verify all required files included *(For submission)*

---

## PREPD-Specific Priorities (For Immediate Attention)

### Critical Items for PREPD Submission

1. **CRITICAL: Portuguese Resumo** - Replace placeholder text with actual 1000-word summary
2. **HIGH: Execute PRISMA systematic review** - Begin database searches and screening
3. **HIGH: Technology assessment matrix** - Complete comparative evaluation of observability tools
4. **HIGH: Complete bibliography** - Ensure all cited works (hevner2004design, prometheus2016, pappula2021building, siddiqui2023jenkins) are in mainbibliography.bib
5. **MEDIUM: Clean up glossary** - Remove unused acronyms (RTS, GPOS, RTOS, PGF), add observability-specific terms
6. **MEDIUM: Update symbols list** - Replace generic examples with observability metrics units
7. **LOW: Citation style decision** - Clarify if Harvard style is mandatory (currently using IEEE)

### Recommended Order for PREPD Completion

1. Fix Portuguese Resumo (CRITICAL)
2. Complete bibliography entries for existing citations
3. Execute systematic literature review (identification phase)
4. Begin technology assessment matrix
5. Clean up glossary and symbols
6. Perform final spell/grammar check
7. Build final PREPD PDF
