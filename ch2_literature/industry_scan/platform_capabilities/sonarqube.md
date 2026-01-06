# SonarQube

## Native observability signals

- Metrics: SonarQube provides code quality metrics accessible via Web API endpoints (`/api/measures`, `/api/metrics`). The documentation mentions a `monitoring/metrics` API endpoint for system monitoring.
- Logs: Not stated
- Traces: Not stated

## Export mechanisms

- Metrics export: Web API endpoints for code metrics at `/api/measures` and `/api/metrics`. System monitoring available via `monitoring/metrics` endpoint. Metrics can be retrieved programmatically via HTTP API.
- Logs access: Not stated
- Traces export: Not stated

## OpenTelemetry support

Not stated

## Deployment assumptions

- Java-based application (on-premises installation)
- Supports CI/CD pipeline integration
- DevOps platform integration (GitHub, GitLab, etc.)
- Scanner-based architecture for code analysis
- Web UI for configuration and visualization
- Database backend (implied by reference to "database" in context)

## Configuration surface

- Web UI: Primary configuration interface
- Web API: Programmatic access to functionality and configuration
- Quality profiles: Configurable rule sets per language
- Quality gates: Configurable quality thresholds
- Project settings: Configurable per-project
- Authentication via bearer tokens or X-Sonar-Passcode header

## Security considerations

- Administrative web services secured and require specific permissions
- Authentication required: Bearer authentication scheme (recommended) or X-Sonar-Passcode authentication scheme
- Private projects require Browse permission for API access
- Note: API endpoint `monitoring/metrics` cannot use bearer authentication scheme (must use X-Sonar-Passcode)
- Token-based access control for Web API

## Explicit limitations stated

- "Note that the Web API V2 will gradually replace the Web API as endpoints get deprecated and replaced." (API versioning in transition)
- Monitoring/metrics endpoint limitation: "If you cannot use the bearer authentication scheme (e.g., with the API endpoint monitoring/metrics), you can use the X-Sonar-Passcode authentication scheme."

## Notes (factual only)

- SonarQube Server is described as "industry-standard on-premises automated code review and static analysis tool"
- Supports 30+ languages, frameworks, and IaC platforms
- Web API documentation accessible from within SonarQube Server UI (help button in top bar)
- Metric keys listed in "Understanding measures and metrics" documentation
- Integrates with SonarQube for IDE (VS Code, IntelliJ, Visual Studio, Eclipse) via "Connected Mode"
- Focused on code quality analysis, not infrastructure observability
- Default content-type for Web API requests: `application/x-www-form-urlencoded`
- Web API V2 gradually replacing older Web API

## Sources

- SonarSource Documentation - SonarQube Server Homepage: <https://docs.sonarsource.com/sonarqube-server/latest/>
- SonarSource Documentation - Web API: <https://docs.sonarsource.com/sonarqube-server/latest/extension-guide/web-api/>
- SonarSource Documentation - Monitoring: <https://docs.sonarsource.com/sonarqube/latest/instance-administration/monitoring/>
