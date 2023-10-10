# How to Incorporate Security Scanning into IaC Pipelines

## Objective

As an IaC engineer, I'd like to incorporate security scanning into my IaC pipeline build validation so I can catch any misconfiguration and risk issues before my code is merged and deployed.

## Overview

### Choose Your Weapon

AKA "Decide which security scanning tool - or tools - to use in my CI/CD pipeline".

There are a number of security scanning tools available that can be run locally or in a pipeline to scan for issue in IaC.

```plaintext
NOTE: 

Running a security scanning tool (or tools) locally would catch issues earlier so could be considered more efficient.  Something to ponder and return to at another time.

See "IDE plugins" in https://cheatsheetseries.owasp.org/cheatsheets/Infrastructure_as_Code_Security_Cheat_Sheet.html#develop-and-distribute .
```

I've done some research into the general consensus on what the best open source options are currently, and I've evaluated a few that looked like "the cream of the crop" (if that's a real saying) by using each one in turn to scan my Terraform code during an Azure DevOps pipeline run.

### Checkov

<https://www.checkov.io/>

Add the following steps into the pipeline YAML file.

```yaml
# Security check using Checkov static analysis tool for Terraform code.
# NOTE: This can be used as a second-line defence to catch any issues missed by tfsec.
- script: |
    echo '[SK] Start Checkov security scan.'
    echo '[SK] Check working directory.'
    pwd
    echo '[SK] Run Docker image.'
    # Use '--soft-fail' argument to suppress error code on initial scan(s) of legacy code.
    docker run --rm --volume "$(pwd):/tf" bridgecrew/checkov --directory /tf --output junitxml --soft-fail > $(pwd)/CheckovReport.xml
  workingDirectory: ${{ parameters.workingdir }}
  displayName: 'Run Checkov'
  # TODO: Enable at a future date once tfsec's output is clean.
  enabled: false

# Publish Checkov scan results to "Tests" tab in Azure Pipelines run UI.  
- task: PublishTestResults@2
  displayName: "Publish Checkov results"
  inputs:
    testRunTitle: "Checkov Scan Results"
    failTaskOnFailedTests: false
    testResultsFormat: "JUnit"
    testResultsFiles: "CheckovReport.xml"
    searchFolder: ${{ parameters.workingdir }}
  # TODO: Enable at a future date once tfsec's output is clean.
  enabled: false
```

```plaintext
Pros:

Seems thorough / comprehensive in terms of results returned.

Cons:

Takes noticeably longer to run than other tools e.g. 20 seconds to scan a modestly sized Terraform directory where tfsec takes around 5 seconds.
```

### Terrascan

- <https://runterrascan.io/docs/getting-started/#using-a-docker-container>
- <https://runterrascan.io/docs/usage/command_line_mode/>

```yaml
# Security check using Terrascan static analysis tool for Terraform code.
# WIP (evaluation)
- script: |
    echo '[SK] Start Terrascan security scan.'
    echo '[SK] Check working directory.'
    pwd
    echo '[SK] Run Docker image.'
    docker run --rm -v "$(pwd):/src" -w /src tenable/terrascan scan -t azure -i terraform
  workingDirectory: ${{ parameters.workingdir }}
  displayName: 'Run Terrascan (EVAL)'
```

```plaintext
Pros:

Relatively easy to set up.

Cons:

Reports an error regarding Terraform 'moved' blocks which are legitimately present within my codebase.

This appears to be a known issue.

See https://github.com/tenable/terrascan/issues/1262 .
```

### tfsec

<https://github.com/aquasecurity/tfsec>

I've been using tfsec for a good few months after an initial evaluation against Checkov.

```yaml
# Security check using *tfsec* static analysis tool for Terraform code.
- script: |
    echo '[SK] Start tfsec security scan.'
    echo '[SK] Check working directory.'
    pwd
    echo '[SK] Run Docker image.'
    # Use '--soft-fail' argument to suppress error code on initial scan(s) of legacy code.
    docker run --rm -v "$(pwd):/src" aquasec/tfsec /src --soft-fail --format JUnit > $(pwd)/tfsecReport.xml
  workingDirectory: ${{ parameters.workingdir }}
  displayName: 'Run tfsec'

# Publish tfsec scan results to "Tests" tab in Azure Pipelines run UI.
- task: PublishTestResults@2
  inputs:
    testRunTitle: 'tfsec Scan Results'
    testResultsFormat: 'JUnit'
    testResultsFiles: '**/tfsecReport.xml'
    searchFolder: ${{ parameters.workingdir }}
    failTaskOnFailedTests: false
    mergeTestResults: false
    publishRunAttachments: true
  displayName: 'Publish tfsec results'
```

```plaintext
Pros: 
Seems thorough and runs efficiently in the pipeline.

Cons: 

Going end-of-life at some point in the not-too-distant (see below)

----

As of September 2023, an EOL notification is appearing in the "Run tfsec" step of my validation pipelines.

"tfsec is joining the Trivy family

tfsec will continue to remain available
for the time being, although our engineering
attention will be directed at Trivy going forward.

You can read more here:
https://github.com/aquasecurity/tfsec/discussions/1994"
```

I have indeed read more, but it's not clear to me how much longer tfsec will remain available / supported.

### Trivy

<https://github.com/aquasecurity/trivy>

#### Acknowledgments

- <https://lgulliver.github.io/trivy-scan-results-to-azure-devops/>
- <https://blog.bajonczak.com/using-trivy-in-azure-devops/>
- <https://onlyutkarsh.medium.com/scanning-container-vulnerabilities-and-publishing-the-results-using-trivy-in-azure-devops-4f8906d83f02>
- <https://www.winopsdba.com/blog/azure-cloud-container-build-scan-publish.html>

```yaml
# Security check using Trivy security scanner from Docker image.
# Run twice: once to detect non-critical then again to detect critical.
# TODO: Consider changing exit code to "1" on scan for critical.
- script: |
    echo '[SK] Start Trivy security scan.'
    echo '[SK] Check working directory.'
    pwd
    echo '[SK] Run Trivy Docker image to scan for non-critical issues.'
    docker run --rm \
    --volume $HOME/Library/Caches:/root/.cache/ \
    --volume "$(pwd):/src" \
    aquasec/trivy config \
    --exit-code 0 \
    --severity LOW,MEDIUM,HIGH \
    --format template --template "@contrib/junit.tpl" \
    --output src/junit-report-non-critical.xml \
    /src
    echo '[SK] Run Trivy Docker image to scan for critical issues.'
    docker run --rm \
    --volume $HOME/Library/Caches:/root/.cache/ \
    --volume "$(pwd):/src" \
    aquasec/trivy config \
    --exit-code 0 \
    --severity CRITICAL \
    --format template --template "@contrib/junit.tpl" \
    --output src/junit-report-critical.xml \
    /src
  workingDirectory: ${{ parameters.workingdir }}
  displayName: 'Run Trivy'
  enabled: true

# Publish Trivy scan results to "Tests" tab in Azure Pipelines run UI.
# TODO: Consider changing 'failTask...' to "true" to highlight critical issues.
- task: PublishTestResults@2
  inputs:
    testRunTitle: 'Trivy Scan Results'
    testResultsFormat: 'JUnit'
    testResultsFiles: '**/junit-report-*.xml'
    searchFolder: ${{ parameters.workingdir }}
    failTaskOnFailedTests: false
    mergeTestResults: true
  displayName: 'Publish Trivy results'
  enabled: true
```

```plaintext
Pros: 

Seems thorough (compares well to tfsec) and can scan other things in addition to IaC e.g. containers.

Cons: 

Initially it seemed a bit tricky to configure - the documentation looks comprehensive but appears to have the occasional "blind spot" (or it might just be me, ha ha!)
```

## Conclusion

I like tfsec and, ideally, I'd continue to use it going forward, but I think it will be beneficial to get ahead of the game and adopt Trivy now rather than wait for it to go end-of-life.
