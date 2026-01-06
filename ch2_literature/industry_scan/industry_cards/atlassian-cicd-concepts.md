# atlassian-cicd-concepts

## Source

Educational content / Conceptual Guide

## Link

https://www.atlassian.com/continuous-delivery/principles/continuous-integration-vs-delivery-vs-deployment

## Platform / Context

Generic CI/CD concepts (not platform-specific); Bitbucket Pipelines mentioned as example

## Observability Signals Used

- **Logs**: Implicit (mentioned in testing context)
- **Automated tests**: Primary validation signal
- **Build status**: Success/failure of builds
- **Metrics**: Not stated
- **Traces**: Not stated

## Deployment Assumptions

- **CI server required**: "Deploy a build server or use a cloud service"
- **Automated testing infrastructure**: "Test suite needs to cover enough of your codebase"
- **Deployment automation**: "Deployments need to be automated"
- **Cloud service option**: "Bitbucket Pipelines which adds automation to every Bitbucket repository"

## Correlation Approach

- **Version control**: "Version control system that tracks changes so you know the version of the code used"
- **Build artifacts**: Packaged and compiled code passed between stages
- **Repository-centric**: CI/CD configuration in repository root
- **No distributed tracing mentioned**: Not stated

## Pain Points Explicitly Mentioned

1. **Testing cost without automation**: "Testing costs are reduced drastically – your CI server can run hundreds of tests in the matter of seconds"
2. **Deployment complexity**: "The complexity of deploying software has been taken away"
3. **Release pressure**: "There is much less pressure on decisions for small changes"
4. **Documentation lag**: "Your documentation process will need to keep up with the pace of deployments"
5. **Feature flag dependency**: "Feature flags become an inherent part of the process of releasing significant changes"
6. **Testing culture requirement**: "Your testing culture needs to be at its best. The quality of your test suite will determine the quality of your releases"
7. **Installation and maintenance**: "One of the traditional cost associated with continuous integration is the installation and maintenance of a CI server"

## What is Explicitly Avoided

- **Manual deployments**: "No human intervention" in CD/continuous deployment
- **Long release cycles**: "Release software on a daily basis" vs. monthly/quarterly
- **Large batch changes**: "Small batches of changes" preferred
- **Infrequent integration**: "Merge their changes as often as possible, at least once a day"

## Notes for Later (No Conclusions)

- Clear distinction between CI, CD (delivery), and CD (deployment)
- CD = automated deployment to staging; continuous deployment = automated to production
- CI is prerequisite for CD: "You can't really do CD without already having CI in place"
- Continuous deployment status mirroring: trigger job shows "running" if downstream manual job pending
- Bitbucket Pipelines: cloud-based, configuration file at repository root, no separate CI server needed
- Strong emphasis on testing as quality gate
- Human approval step differentiates continuous delivery from continuous deployment
