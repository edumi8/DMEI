# Nexus Repository Manager

## Native observability signals

- Metrics: Not stated
- Logs: Not stated
- Traces: Not stated

## Export mechanisms

- Metrics export: REST API available with OpenAPI Specification. API documentation accessible at `<nexus_url>/service/rest/swagger.json` (does not require privileges). Swagger UI embedded in Nexus Repository UI under System sub-menu (requires `nx-settings-read` privilege).
- Logs access: Not stated
- Traces export: Not stated

## OpenTelemetry support

Not stated

## Deployment assumptions

- Java-based application (implied by Jetty 12 web server, Groovy scripting support)
- Web server: Jetty 12 (as of version 3.81.0)
- Repository manager model supporting multiple package formats (Maven, npm, Docker, PyPI, NuGet, and many others)
- Integrations with CI/CD tools (Jenkins plugin available)
- Integration with Sonatype IQ Server for governance and policy management
- Web UI for administration
- REST API for automation
- Community Edition and Professional Edition offerings
- High Availability deployment support

## Configuration surface

- Web UI: Primary administration interface
- REST API: Programmatic access with OpenAPI Specification at `/service/rest/swagger.json`
- Swagger UI: Interactive REST API interface (embedded in UI under System menu)
- Scripting API: Groovy-based custom scripting (disabled by default for security)
- Staging API: Artifact movement between repositories
- Tagging API: Component metadata management via REST API
- Webhooks: Available for integration
- Configuration via UI settings menu
- User authentication and authorization controls

## Security considerations

- Groovy scripting engine disabled by default for security
- Privilege-based access control (`nx-settings-read` privilege required for API view, though view provides access to multiple UI sections)
- REST API functional only for operations user has permission to use
- Swagger UI API view: "The API view lists all APIs and their examples, however, only the APIs that the user has permission to utilize are functional."
- Stricter URL parsing behavior as of version 3.81.0 (RFC 3986 compliance): malformed requests receive 404
- Repository Firewall capability for component risk management (quarantine risky components)

## Explicit limitations stated

- "Stricter URL parsing behavior" as of 3.81.0: "Malformed requests receive a 404 when they may have been successful in previous versions."
- RFC 3986 requirement: "According to URL standards, double quotes \" must be percent-encoded as %22 when used in query parameters."
- Scripting API security constraint: "To make Nexus Repository more secure, the Groovy scripting engine is disabled by default."
- Swagger UI privilege note: "The nx-settings-read privilege is required to access this page. This privilege provides access to multiple views in the user interface. There is not a setting to view only the API view at this time."

## Notes (factual only)

- Nexus Repository available in two editions: Community Edition and Professional Edition
- Described as "universal, trusted, centralized repository" for package managers
- Supports multiple repository formats: Maven, npm, Docker, PyPI, NuGet, Helm, Go, Apt, Yum, CocoaPods, Composer, Conan, Conda, Git LFS, Hugging Face, p2, R, Raw, RubyGems, Rust/Cargo
- Beta endpoints in API are "fully supported by Sonatype and are safe to use in production systems"
- Jenkins integration available via Nexus Platform Plugin for Jenkins
- Maven plugin available for staging packages
- Staging feature allows artifact movement between repositories with quality checks
- Tagging feature supports custom JSON metadata attributes on components
- Updated to Jetty 12 in version 3.81.0
- REST API leverages OpenAPI Specification (OAS)
- Integration with Sonatype IQ Server provides component intelligence and policy management

## Sources

- Sonatype Help - Sonatype Nexus Repository: <https://help.sonatype.com/en/sonatype-nexus-repository.html>
- Sonatype Help - Automation (REST API, Integrations): <https://help.sonatype.com/repomanager3/integrations>
