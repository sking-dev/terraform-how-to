# How to Handle Merge Conflicts in a GitOps Workflow

WIP (2022-02-08)

## Objective

As an IaC engineer, I'd like to make my GitOps workflow as robust and scalable as possible by preventing merge conflicts as far as possible or, when they do occur, by resolving them as quickly and efficiently as possible.

----

## Prevent Merge Conflicts

### Protect the Master Branch

Prohibit any direct changes to the master branch.

This can be done via a branch policy.  TODO: Add more details.

### Branching Strategy

The name of the game here is, more frequent commits.

Adopting feature branches (AKA topic branches) leads to smaller units of work, focused on particular areas of the codebase, so the team should be able to commit and merge to master more frequently.  

Each feature branch begins its life as an up-to-date working copy of the master branch, and should result a small(er) number of commits to merge, which should reduce the potential for merge conflicts in comparison to a long(er) lived branch that will have a greater quantity of commits over a longer period of time - both factors are likely to result in commits that which are more likely to touch multiple areas of the codebase.

### Keep Feature Branches Focused

Keep your changes to the minimum required to successfully achieve your requirements (as defined in the work item)  Don't be tempted to fix things in other files - even simple style convention infringements - as this increases the chances of you modifying a file that someone else has committed.

### Pre-commit Hooks

_Any scope here for preventing a commit that's going to generate a merge conflict?_

### Validation Pipelines

_As per above - can these directly address the issue at hand?_

### Pull Request Hygiene

_What does this mean?_

Is it stuff like, what's the time limit for PRs to be actioned?  A week / three days / two days?  

What other stuff?

### Strong Communication

Facilitate team visibility of what each other is working on.

Plan your work - do you need to work on the same code at exactly the same time as someone else?  

If this is imperative, you can work on it together from a  single workstation.  

Or, if at all possible, wait until the first person has finished and then begin your work item.

### Manage Code at Scale

_What (other) ways of working?_

### Commit History

Don't allow squash commits - mandate "no fast forward" - check why / what value this will add.

- <https://betterdev.blog/turn-off-git-fast-forward-merge/>

----

## Resolve Merge Conflicts

The `git revert` command...

`git merge --abort` - what does this do?

### Write a Playbook for Possible Scenarios

_What are the likely scenarios?_

<https://www.git-tower.com/learn/git/faq/solve-merge-conflicts/>

----

## Acknowledgments

Prevention.

<https://softwareengineering.stackexchange.com/questions/270119/does-frequent-committing-prevent-merge-conflicts>

<https://www.openbankproject.com/how-to-avoid-merge-conflicts-on-git/>

<https://stackoverflow.com/questions/24213948/prevent-file-with-merge-conflicts-from-getting-committed-in-git>

<https://opensource.com/article/21/8/gitops>

<https://team-coder.com/avoid-merge-conflicts/>

----

Cure.

<https://www.git-tower.com/learn/git/faq/solve-merge-conflicts/>
