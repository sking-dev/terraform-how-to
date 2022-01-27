# How to Use Git Pre-commit Hooks with Terraform IaC

## Objective

As an IaC engineer, I'd like to use Git pre-commit hooks to validate my Terraform code client-side thereby avoiding the need to include validation tasks in my CI pipeline.

Caveat: It may not be quite as clear-cut as this.  Later on, I'll discuss [the other way to potentially skin this cat](#run-hooks-in-pipeline) and try to establish if client-side is the best way to go.

## What We Need

### A Localised File to Provide Pre-Commit Configuration

This file should be named `.pre-commit-config.yaml` and it should go in the root of the Git repository that holds the Terraform code.

I'm going to clarify what the contents of this file should be for my particular scenario, but here are a couple of examples in the meantime.

```yaml
# Source: https://medium.com/slalom-build/pre-commit-hooks-for-terraform-9356ee6db882
---
repos:
- repo: https://github.com/gruntwork-io/pre-commit
  rev: <VERSION> # Get the latest from: https://github.com/gruntwork-io/pre-commit/releases
  hooks:
    - id: tflint
      args:
        - "--module"
        - "--deep"
        - "--config=.tflint.hcl"
    - id: terraform-validate
    - id: terraform-fmt
- repo: git://github.com/antonbabenko/pre-commit-terraform
  rev: <VERSION> # Get the latest from: https://github.com/antonbabenko/pre-commit-terraform/releases
  hooks:
    - id: terraform_tfsec
    - id: terraform_docs
    - id: checkov
```

```yaml
# Source: https://getbetterdevops.io/produce-reliable-terraform-code-with-pre-commit-hooks/

---
repos:
  - repo: https://github.com/gruntwork-io/pre-commit
    rev: v0.1.12
    hooks:
      - id: terraform-fmt
      - id: terraform-validate
      - id: tflint
        args:
          - "--module"
          - "--deep"
          - "--config=.tflint.hcl"
      - id: markdown-link-check

  - repo: git://github.com/antonbabenko/pre-commit-terraform
    rev: v1.47.0
    hooks:
      - id: terraform_tfsec
      - id: terraform_docs
```

#### Which Third Party Repo Should We Use

From my research thus far, there appears to be two main contenders.

- <https://github.com/gruntwork-io/pre-commit>
- <https://github.com/antonbabenko/pre-commit-terraform>

So, which one is my best bet?

In the examples above, both repos are used as each offers different pre-commit hooks (albeit with some overlap)

I'm going to go with "gruntwork-io" as my "starter for ten" as it's a commercial organisation with a solid reputation in Terraform circles, so it's probably less alarming to The Powers That Be as third party open source software.

Plus, at this point in time, I'm not planning to use any security scanners which seems to be the USP for the "antonbabenko" repo.

### Install pre-commit on Local Workstation

Install pre-commit itself **plus** any tools that will be invoked by the pre-commit hooks on your local workstation, as this is where you'll be running the `pre-commit` operation.

NOTE: At the time of writing, I'm only planning to use native Terraform commands for linting and validation i.e. `terraform fmt` and `terraform validate` so I won't need to install these explicitly (Terraform is already installed on my local workstation)

- pre-commit
  - `sudo pip install pre-commit`
    - This is the framework that the third party repos are leveraging - see <https://pre-commit.com/> for more details
    - On Ubuntu running under WSL, you may hit an error related to `apt` / `snap` - see <https://stackoverflow.com/questions/63422437/corrupted-python-package-in-ubuntu18-04ltswsl> for how to resolve this
    - `pre-commit --version` should return (something like) `pre-commit 2.16.0`

### Install pre-commit in Local Repo

Run `pre-commit install` so that the configuration for the pre-commit hooks is read from the YAML file that you added to the repository.

After running this command, pre-commit will run automatically whenever you do a `git commit`.

### Perform a git commit

Let's give it a whirl!

```plaintext
$ git commit -v
Terraform validate.......................................................Passed
Terraform fmt............................................................Failed
- hook id: terraform-fmt
- exit code: 3

2-terraform-automation/pre-commit-test-code.tf        
--- old/2-terraform-automation/pre-commit-test-code.tf
+++ new/2-terraform-automation/pre-commit-test-code.tf
@@ -4,12 +4,12 @@
 }

 resource "random_password" "password" {
-  length = 16
-  special = true
+  length           = 16
+  special          = true
   override_special = "_%@"
 }

 output "test" {
-  value = random_password.password.result
+  value     = random_password.password.result
   sensitive = true
 }
```

So `terraform validate` has passed (nice!) but `terraform fmt` has failed because the code blocks aren't lined up nicely.

After running `terraform fmt` in the working directory, I try the `git commit` again and, this time, both check pass (woohoo!)

```plaintext
$ git commit -v
Terraform validate.......................................................Passed
Terraform fmt............................................................Passed
```

----

## Things to Ponder

### Run Hooks Manually

There seems to be a general consensus that it's a good move to run your pre-commit hooks manually when you first introduce them into your repository.

`pre-commit run --all-files`

I don't think this is critical as such, but it does ensure that the existing code conforms to the same standards as new / updated code.

TODO: Are there other other use cases for running pre-commit manually?

----

### Run Hooks in Pipeline

There's an argument for running pre-commit hooks in a CI pipeline.

UPDATE: OK - let's get into this!

_What is the argument for running pre-commit hooks in the pipeline?_

As I see it, the main reason to run pre-commit hooks in the pipeline as part of the build validation is (as) a "belt and braces" approach in case some team members don't run the hooks client-side.

As with so many things, this sounds good in theory but, basically, it isn't feasible because it's anti-pattern.

_How so?_

Pre-commit hooks are effectively a gate between the commit and the push to the remote branch, and build validation runs as a gate on the merge to master which is too far right in the workflow.

_So how do we go about this?_

The compromise appears to be to run `pre-commit` in the pipeline as a CI task.  

This can be either against all files **or** changed files only - the latter could be more efficient - which will cause the pipeline to fail if any files don't conform to the pre-commit hooks.

This script will do the job in a CI pipeline task.

```bash
#!/bin/bash
# Install pre-commit framework.
pip install pre-commit

# Verify version installed.
pre-commit --version

# Set up git hook scripts as per configuration file in repo.
pre-commit install

# Run pre-commit to check all files in repo.
pre-commit run --all-files --show-diff-on-failure
```

However, from my testing so far...

Because this script task runs on all (the) files in my IaC repository, it's taking a long time and it's failing with a big list of errors for `terraform fmt`.

This is because I've only fixed the style convention issues on a small percentage of the files in my repository.  

To be very honest, it will be a drag to resolve all these issues for the sake of this testing, so I've been trying to run `pre-commit` on **just** the files that have changed in the most recent commit.

```bash
# Run pre-commit to check any changed file.
pre-commit run --from-ref origin/HEAD --to-ref HEAD
```

But...

This opens up a can of worms because I need to tell `pre-commit` which branch to compare against the master branch.

In the branching strategy that I'm using - TODO: add a link here to a pending document about GitOps workflow - this branch will change from one PR to the next, so I'll need to source the name of my feature branch from an Azure Pipeline variable and potentially supplement the `pre-commit` command with a Git command that ensures the branches are available to the `pre-commit` framework.

```bash
# Something like this (TBC)
pre-commit run --files $(git diff --name-only HEAD main)
```

This is getting a little bit complicated, so I'm going to go for "Plan B" in the short term: run individual, equivalent CI tasks in my build validation pipeline as a quick(er) win.

```plaintext
Caveat:

The downside of rolling back from running 'pre-commit' in the pipeline to mirroring what it does in CI tasks instead is that this will add some extra configuration work in terms of, setting up the CI tasks and keeping them up-to-date if the pre-commit change going forward.
```

TODO: The "Plan B" (above) will give me a quicker win, but I'm planning to revisit this again at a future date.  Watch this space!

----

## Acknowledgments

Useful resources that haven't been acknowledged elsewhere in this document.

<https://www.padok.fr/en/blog/pre-commit-hooks>

<https://learn.adafruit.com/creating-and-sharing-a-circuitpython-library/check-your-code>

<https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/secure/devsecops-controls#ide-security-plug-ins-and-pre-commit-hooks>

<https://getbetterdevops.io/produce-reliable-terraform-code-with-pre-commit-hooks/>

<https://lucytalksdata.com/pre-commit-the-gatekeeper-of-code-quality/>

<https://stackoverflow.com/questions/68202525/pre-commit-tool-in-jenkins-pipelines-nitialize-and-stop-build>

<https://pre-commit.com/#usage-in-continuous-integration>
