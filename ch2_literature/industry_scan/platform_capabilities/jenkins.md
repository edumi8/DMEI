# Jenkins

## Native observability signals

- Metrics: Jenkins exposes metrics through plugins. The Prometheus plugin exposes metrics at a configurable endpoint (default: `/prometheus/`). Two types of metrics are exposed: (1) metrics from the Metrics-plugin, and (2) metrics from the Prometheus plugin itself. The plugin collects metrics asynchronously with a configurable period (default: 120 seconds).
- Logs: Jenkins uses `java.util.logging` for logging. By default, every log above `INFO` level is sent to stdout. Jenkins provides a web UI for configuring, collecting, and reporting log records (System Log / Log Recorders). Logs can be viewed in the web UI or written to disk via the Support Core Plugin.
- Traces: Not stated

## Export mechanisms

- Metrics export: Prometheus plugin exposes metrics at HTTP endpoint (default: `/prometheus/`, requires trailing slash). The endpoint can be scraped by Prometheus server or accessed via HTTP client. Plugin collects metrics asynchronously.
- Logs access: Logs available via system mechanisms: `journalctl -u jenkins.service` (Linux rpm/deb), log files at `%JENKINS_HOME%/jenkins.out` and `%JENKINS_HOME%/jenkins.err` (Windows msi), `/var/log/jenkins/jenkins.log` (macOS), `JENKINS_HOME` directory or `.jenkins/log` (war file), `docker logs <containerId>` (Docker). Custom log recorders can be created via web UI. Support Core Plugin writes custom logs to disk.
- Traces export: Not stated

## OpenTelemetry support

Not stated

## Deployment assumptions

- Java-based application running as service or war file
- Installation methods: Linux package (rpm/deb), Windows (msi), macOS, war file deployment, Docker container
- Jenkins controller and agent architecture with remoting connections
- Plugin-based extensibility model
- Expects ability to configure JVM system properties for logging (`-Djava.util.logging.config.file`)
- Monitoring is plugin-based (not built-in)

## Configuration surface

- Environment variables: `PROMETHEUS_NAMESPACE` (metric prefix, default: `default`), `PROMETHEUS_ENDPOINT` (REST endpoint, default: `/prometheus/`), `COLLECTING_METRICS_PERIOD_IN_SECONDS` (async task period, default: `120`), `COLLECT_DISK_USAGE` (enable/disable disk usage collection), `JENKINS_LOG` (log location, via systemd), `JENKINS_HOME` (installation directory)
- Configuration files: `logging.properties` (Java logging configuration), `org.jenkins-ci.plist` (macOS), `jenkins.xml` (Windows), systemd service configuration (Linux)
- Web UI: System Log configuration, Log Recorders setup, plugin configuration
- JVM system properties: `-Djava.util.logging.config.file`, `-Dhudson.remoting.Launcher.pingIntervalSec` (agent ping configuration)

## Security considerations

- Prometheus plugin endpoint exposed without authentication (requires external protection)
- Monitoring documentation page states: "This page is under development, there will be more content added soon."
- No explicit security warnings documented for metrics endpoints
- Log files may contain sensitive information
- Custom log recorders accessible via web UI (inherits Jenkins authentication)

## Explicit limitations stated

- Prometheus plugin documentation: "The endpoint you've configured or the default endpoint `/prometheus/` in case you didn't configure an endpoint, needs to end with a trailing slash when you configure the endpoint in your scraping tool. If you miss adding the trailing slash you'll get a 302 response with a redirection to the endpoint ending with a slash. Some tools cannot handle this well."
- Monitoring documentation page: "This page is under development, there will be more content added soon."
- Default log level INFO: "For a normal production environment the default level is INFO, it is not advised to have debug log in production."

## Notes (factual only)

- Jenkins monitoring page is marked as "under development"
- Prometheus plugin installed on 6.76% of controllers (as of documentation date)
- Multiple monitoring integrations documented: Datadog, Newrelic, Prometheus/Grafana, JavaMelody
- Ping thread mechanism for connection monitoring between controller and agents (default timeout: 4 minutes)
- Ping thread can be disabled via system properties for troubleshooting
- Jenkins provides web UI-based log recorder for grouping relevant logs and filtering noise
- Log levels configurable per Java package/logger
- Support Core Plugin enables custom logs to be written to disk automatically

## Sources

- Jenkins Documentation - Monitoring Jenkins: <https://www.jenkins.io/doc/book/system-administration/monitoring/>
- Jenkins Plugin Site - Prometheus Plugin: <https://plugins.jenkins.io/prometheus/>
- Jenkins Documentation - Viewing Logs: <https://www.jenkins.io/doc/book/system-administration/viewing-logs/>
