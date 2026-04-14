# Servers

| Server       | Description                                                                 |
|--------------|-----------------------------------------------------------------------------|
| le-s-po-lin1 | Primary CI/CD host running core orchestration and shared platform services. |
| le-s-po-lin2 | Secondary CI/CD and test host; also runs database services.                 |
| le-s-po-app1 | Application host where test and staging deployments are executed.           |
| le-s-po-win1 | Windows worker host for platform-specific build, test, and deployment jobs. |

## Services

| Service            | Description                                                                                          |
|--------------------|------------------------------------------------------------------------------------------------------|
| GitLab             | Hosts source repositories and triggers CI/CD workflows through commits, merges, and webhooks.        |
| Jenkins Controller | Orchestrates pipeline workflows, schedules stages, and dispatches jobs to available workers.         |
| Jenkins Worker     | Executes build, test, analysis, packaging, and deployment steps assigned by the controller.          |
| SonarQube          | Performs static code analysis and enforces quality-gate checks during pipeline execution.            |
| Dependency-Track   | Ingests software bills of materials and tracks dependency and vulnerability risk.                    |
| Nexus Repository   | Stores and serves versioned build artifacts and dependencies consumed by pipeline jobs.              |
| Test Environments  | Isolated environments for pre-release deployment and validation.                                     |
