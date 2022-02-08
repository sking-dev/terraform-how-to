# How to Handle Merge Conflicts in a GitOps Workflow

WIP (2022-02-08)

## Objective

As an IaC engineer, I'd like to make my GitOps workflow robust and scalable by preventing merge conflicts or, when they do occur, by resolving them as quickly and efficiently as possible.

----

## Prevent Merge Conflicts

"Prevention is better than cure".  Can't argue with that!

### Adopt a Friendly Branching Strategy

Using **feature branches** (AKA "topic branches") will lead to smaller, shorter-lived units of work, which are focused on explicit areas of the codebase, so the team should be able to commit and merge to master more frequently.  

More frequent commits will improve the chances of avoiding merge conflicts.

Each feature branch should begin its life as an up-to-date working copy of the master branch.

```bash
git checkout master
git pull origin master
git checkout -b 1234-nsg-add-rule-smtp
```

Each feature branch should be as short-lived as possible, so that it generates a small(er) number of commits to merge.

This should reduce the potential for merge conflicts in comparison to a long(er) lived branch that will have a greater quantity of commits over a longer period of time.  Both of these factors - increased time and scope - increase the chances of commits that impact on multiple areas of the codebase and thus code that's being modified elsewhere.

### Keep Feature Branches Focused

Keep your changes to the minimum required to successfully achieve your objective e.g. the scope / requirement as defined in the work item.

Don't be tempted to fix things in other files - even simple style convention infringements - as this increases the chances of modifying a file that another team member else has merged to master.

### Protect the Master Branch

Prohibit any direct changes to the master branch.  This can be done via a branch policy.

In other words, there has to be a Pull Request (PR) that's reviewed and approved before the master branch is updated.

This will guard against the possibility that a team member forgets to create a feature branch before making their changes.

### Pull Request Best Practice

This can also be referred to as "good PR hygiene".

It basically means, the PR should be as easy to review as possible, and the reviewer(s) should take care / pains (both!) to do a proper job of reviewing rather than blindly hitting "Approve".

Here are some useful suggestions from <https://www.atlassian.com/blog/git/written-unwritten-guide-pull-requests> .

- Keep the PR small (in scope)
  - This should be achieved by default with feature branches (see above)
- Provide a useful title and description
- Write high quality commit messages
- Add comments to the PR as required to give extra guidance to the reviewer(s)
- Add visual elements e.g. screenshots if they can help to clarify what the PR is for

### Maintain a Full Commit History

There's _a lot_ of debate about the pros and cons of "basic merge (no fast forward") versus "squash merge" (not to mention the other common options!)

In the context of a GitOps workflow for IaC deployments, with some team members who are new to Git, I'm going to propose the following rule as a "starter for ten".

Don't allow "squash merge" i.e. mandate "basic merge (no fast forward)".  This can be enforced on PRs via the branch policy on the master branch.

In conjunction with properly crafted commit messages, this will give a full and meaningful commit history which should provide a meaningful audit trail for troubleshooting and resolving merge conflicts.

See the following links for some additional background / discussion.

- <https://betterdev.blog/turn-off-git-fast-forward-merge/>
- <https://github.com/nus-cs2103-AY1819S1/forum/issues/46>
- <https://anuragbhandari.com/coding-tech/merge-commit-vs-squash-commit-in-git-1895/>

### Pre-commit Hooks

_Any scope here for preventing a commit that's going to generate a merge conflict?_

### Strong Communication

Facilitate team visibility of what each other is working on e.g. Azure Boards plus integration with Teams.

Plan your work - do you need to work on the same code at exactly the same time as someone else?  

If this is mission-critical, could you collaborate and work on the code together from a single workstation?

Or can you wait until the in-flight feature branch as been merged has finished and then begin your work item?

----

## Resolve Merge Conflicts

_How to approach this?  Roll back via the command line?_  

`git revert`

Or...

`git merge --abort`

_Or edit affected files?_

### Write a Playbook for Possible Scenarios

_What are the likely scenarios?_

<https://www.git-tower.com/learn/git/faq/solve-merge-conflicts/>

----

## Acknowledgments

"Prevention".

<https://softwareengineering.stackexchange.com/questions/270119/does-frequent-committing-prevent-merge-conflicts>

<https://www.openbankproject.com/how-to-avoid-merge-conflicts-on-git/>

<https://stackoverflow.com/questions/24213948/prevent-file-with-merge-conflicts-from-getting-committed-in-git>

<https://opensource.com/article/21/8/gitops>

<https://team-coder.com/avoid-merge-conflicts/>

----

"Cure".

<https://www.red-gate.com/simple-talk/devops/database-devops/feature-branches-and-pull-requests-with-git-to-manage-conflicts/> ***

<https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts/resolving-a-merge-conflict-using-the-command-line> ***

<https://microsoft.github.io/code-with-engineering-playbook/source-control/git-guidance/> ***

<https://docs.microsoft.com/en-us/azure/devops/repos/git/merging?view=azure-devops&tabs=command-line>

<https://www.git-tower.com/learn/git/faq/solve-merge-conflicts/>
