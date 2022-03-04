# How to Handle Merge Conflicts in a GitOps Workflow

## Objective

As an IaC engineer, I'd like to make my GitOps workflow robust and scalable as possible by preventing merge conflicts or, when they do occur, by resolving them in a quick and efficient manner.

----

## Prevent Merge Conflicts

"Prevention is better than cure", as the wise old saying, er, says.

### Adopt a Friendly Branching Strategy

Using **feature branches** (AKA "topic branches") will lead to smaller, shorter-lived units of work, which are focused on explicit areas of the codebase, so the team should be able to commit and merge to 'master' (AKA 'main') more frequently.

More frequent commits will improve the chances of avoiding merge conflicts.  That is, in comparison to a long(er) lived branch that will have a greater quantity of commits over a longer period of time.  Both of these factors - increased time and scope - increase the chances of commits that impact on multiple areas of the codebase and thus code that's being modified elsewhere.

Each feature branch should begin its life as an up-to-date working copy of the master branch.

```bash
git checkout master
git pull origin master
git checkout -b my-feature-branch # The name of the branch will depend on the naming convention you adopt
```

Each feature branch should be as short-lived as possible, so that it generates a small(er) number of commits to merge.

However, "best laid plans" and all that...  There will at some point be feature branches that, for whatever reason, live for longer than is strictly desirable.  In this case, it's best practice to update your local feature branch with any changes to master that have happened since you created your branch.

```bash
git branch # Confirm you're still on your feature branch
git checkout master
git pull origin master
git checkout my-feature-branch # Go back to your feature branch
git merge master # This will surface any merge conflicts that may exist between your local code & what's in master - uh oh!

# NOTE: It should be possible to do 'git merge origin master' on your feature branch - save having to switch branches as per above - but I can't get this to work for some reason.
```

NOTE: There seems to be a big debate in Git circles over whether `git merge` is better than `git rebase` or vice versa.  My head's spinning after reading a host of blog posts and threads on this topic but, overall, my inclination at the moment is towards `git merge` (but watch this space..!)

- <https://mutesoft.com/spaces/software/git-refresh-feature-branch-from-master.html>
- <https://www.perforce.com/blog/vcs/git-rebase-vs-git-merge-which-better>
- <https://belev.dev/git-merge-vs-rebase-to-keep-feature-branch-up-to-date>
- <https://timwise.co.uk/2019/10/14/merge-vs-rebase/>

### Keep Feature Branches Focused

Keep your changes to the minimum required to successfully achieve your objective e.g. the scope / requirement as defined in the work item.

Don't be tempted to fix other things that might catch your eye in other files - even if they're simple typos or poor formatting - as this increases the chances of modifying a file that another team member has recently merged to master.

### Protect the 'master' Branch

Prohibit any direct changes to the 'master' branch.  This can be done via a branch policy.

In other words, there has to be a Pull Request (PR) that's reviewed and approved before the master branch is updated.

This will guard against the possibility that a team member forgets to create a feature branch before making their changes.

### Follow Pull Request Best Practice

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

In conjunction with properly crafted commit messages, this will give a full and meaningful commit history which should provide a meaningful audit trail for troubleshooting / resolving merge conflicts.

See the following links for some additional background / discussion.

- <https://betterdev.blog/turn-off-git-fast-forward-merge/>
- <https://github.com/nus-cs2103-AY1819S1/forum/issues/46>
- <https://anuragbhandari.com/coding-tech/merge-commit-vs-squash-commit-in-git-1895/>

### Make Use of Pre-commit Hooks

_Can we use pre-commit hooks to detect / prevent a commit that's going to lead to a merge conflict?_

The 'check-merge-conflict' hook looks like it could help on this front but, after some testing, I'm not convinced of its utility.

<https://github.com/pre-commit/pre-commit-hooks#check-merge-conflict>

This hook is designed to "check for files that contain merge conflict strings" but my question is, how would these strings get into the files in my feature branch?

The only way I can think of is, I've committed my changes to my feature branch then, before I push to a remote branch, I decide to make sure my feature branch is (otherwise) current as follows.

```bash
git checkout main
git pull origin main
git checkout my-feature-branch # Go back to my feature branch
git merge master # Bring in any changes from 'main' since my feature branch was created
# At this point, I will get a merge conflict error if any of my local changes impact on the same code (files / lines) from 'main'
```

If there is a merge conflict, my file(s) will have the strings injected (by Git) but I won't need to do a `git commit` (I've already done that) so how / why would the pre-commit hook be invoked in order to detect the merge conflict?

Or...  Is it designed to act as a safety net in case I only partially resolve the merge conflict and attempt to (re)commit updated files with some of the strings left behind?

I'm going to give up on this option as I can't see how it would add any value, in the GitOps workflow context at least.

Disclaimer: I may not be using this hook correctly and / or my expectations may be misaligned.

Other resources:

- <https://stackoverflow.com/questions/24213948/prevent-file-with-merge-conflicts-from-getting-committed-in-git>
- <https://www.elliotjordan.com/posts/pre-commit-01-intro/>

### Ensure Strong Communication

Facilitate visibility of what each team member is working on e.g. make use of Azure Boards, including integration with Microsoft Teams.

Plan your work - do you need to work on the same code at exactly the same time as someone else?  

- If your change is mission-critical, could you collaborate and work on the code together to make the changes from a single workstation?
- Or can you wait until the in-flight feature branch has been merged to master and then begin your work item?

----

## Resolve Merge Conflicts

_What's the best way to approach this?_  

_Undo the merge and return to a "last known good" state?_

_Or face it head-on and resolve the merge conflict using the pointers that Git will provide?_

### What is a Merge Conflict

Here are some useful articles that explain what a merge conflicts are (why they happen) and suggest how to resolve them.

- <https://www.atlassian.com/git/tutorials/using-branches/merge-conflicts>
- <https://css-tricks.com/merge-conflicts-what-they-are-and-how-to-deal-with-them/>
- <https://www.git-tower.com/learn/git/faq/solve-merge-conflicts/>
- <https://opensource.com/article/20/4/git-merge-conflict>
- <https://docs.microsoft.com/en-us/azure/devops/repos/git/merging?view=azure-devops&tabs=command-line>

### Undo

After much strenuous reading on the subject of merge conflicts, I have come to the conclusion that despite my best efforts - the guard rails I'm building to prevent merge conflicts - merge conflicts **will** occur, so I'm going to adopt the approach that whichever team member's "in the chair" should take the responsibility to analyse why a merge conflict is happening and then resolve it line-by-line as required.

For the record, [here are my musings on the "undo" approach](Undo-Merge-Conflict.md) in case anyone's interested (you never know!) or I need to revisit this idea in the future.

### Resolve

All roads seem to lead back to facing the merge conflict head-on, and deciding what should be kept from your local changes and what should be brought in from the version on the 'master' branch.

I've tried setting up simulations / test labs but they've ended up being a bit meaningless / confusing (both!)

I think the only real way to get comfortable with resolving merge conflicts will be to experience real world scenarios which we won't encounter until more of the team are working on our full IaC codebase using the GitOps workflow.

TODO: Revisit this in a few months time to impart any knowledge gained from this anticipated hands-on experience.

----

### Write a Playbook for Possible Scenarios

_What are the likely scenarios?_

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
