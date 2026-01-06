# Jenkins Pipeline Best Practices and Debugging

## Source
**SHORT_KEY:** jenkins-pipeline-best-practices  
**TITLE:** Jenkins Pipeline Best Practices  
**LINK:** https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/  
**DATE_ACCESSED:** 2026-01-06

## What observability signals are used?
- **Console logs:** Implicit primary signal (not explicitly stated but assumed)
- **Build history:** Referenced via "Cleaning up old Jenkins builds"
- **Job execution results:** Success/failure status
- **NotSerializableException errors:** Pipeline serialization failures
- **Groovy code execution:** Controller resource usage (memory, CPU)

## What deployment assumptions/constraints are revealed?
- **Controller resource constraints:** "Groovy code always executes on controller which means using controller resources (memory and CPU)"
- **Pipeline serialization:** "CPS relies on being able to serialize the pipeline's current state"
- **Workspace concurrency issues:** "Try not to share workspaces across multiple Pipeline executions"
- **Shell script execution:** "Use single steps (such as `sh`) to accomplish multiple parts of the build"
- **Agent-based execution:** Commands should run on agents, not controller

## How are CI/CD metrics correlated across services?
- **Build numbers:** Sequential build numbers for job history
- **Pipeline execution engine:** Overhead from starting/stopping steps
- **Workspace locking:** Lockable Resources Plugin for workspace coordination
- **No distributed tracing:** Correlation via build numbers and workspace management only

## What pain points or challenges are mentioned?
- **Controller resource exhaustion:** "Groovy code...requires more resources (CPU, memory, storage) on the controller"
- **Serialization failures:** "NotSerializableException to be thrown when the pipeline attempts to persist its state"
- **Workspace conflicts:** "can lead to either unexpected file modification...or workspace renaming"
- **Pipeline step overhead:** "each of those steps has to be started and stopped, requiring connections and resources"
- **JsonSlurper memory issues:** "loads the local file into memory on the controller twice"
- **HttpRequest controller impact:** "request is coming directly from the controller"
- **Large shared libraries:** "requires checking out a very large file before the Pipeline can start"
- **Variable declaration overhead:** "large amounts of memory for little to no benefit"

## What observability approaches are avoided or not mentioned?
- **Distributed tracing:** Not mentioned for pipeline debugging
- **Metrics-based debugging:** Not discussed as debugging approach
- **Real-time monitoring:** Focus on post-execution analysis
- **Automated log analysis:** Manual inspection implied

## Technical specifics
- **Groovy optimization:**
  - Use shell steps (`sh`) instead of Groovy for main functionality
  - Avoid JsonSlurper; use shell + jq for JSON parsing
  - Avoid HttpRequest; use curl/wget from agent
  - Combine multiple steps into single shell step
- **Serialization handling:**
  - Use `@NonCPS` annotation to disable CPS transformation
  - Avoid assigning non-serializable objects to variables
  - PERFORMANCE_OPTIMIZED durability reduces serialization frequency
- **Workspace management:**
  - Build in distinct containers (cloud-type agents)
  - Disable concurrency or use Lockable Resources Plugin
  - Copy files from shared volumes instead of sharing workspaces
- **Resource management:**
  - Use buildDiscarder directive to remove old builds
  - Keep shared libraries small
  - Avoid large global variable declaration files

## Platform/environment
- **Jenkins controller:** Groovy code execution environment
- **Agents:** Shell script and build execution environment
- **Cloud agents:** Recommended for isolated, repeatable builds
- **Shared libraries:** External Groovy code repositories
- **Lockable Resources Plugin:** For workspace coordination

## Security considerations
- **Avoid Jenkins.getInstance:** "can lead to severe security and performance issues"
- **Sandbox restrictions:** Using Jenkins APIs from sandboxed Jenkinsfile requires whitelisting methods
- **System user permissions:** Whitelisted methods run as System user with overall admin permissions
- **Plugin development:** Recommended approach for Jenkins API access instead of Pipeline code

---

## Pipeline failure modes discussed
- **NotSerializableException:** Pipeline state serialization failures due to non-serializable objects
- **Controller resource exhaustion:** Groovy code consuming excessive memory/CPU on controller
- **Workspace conflicts:** Concurrent pipeline executions modifying same workspace
- **Pipeline step overhead:** Performance degradation from excessive step creation
- **Large file processing:** JsonSlurper loading large files into controller memory

## Signals used during incident resolution
- **Exception messages:** NotSerializableException for debugging serialization issues
- **Console logs:** Implied primary debugging signal (not explicitly stated)
- **Build history:** Review historical builds to identify patterns
- **Pipeline syntax:** Analyze Groovy code for resource-intensive operations
- **Manual inspection:** Review pipeline configuration for best practice violations
- **Performance analysis:** Identify controller resource usage from Groovy code