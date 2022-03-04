# How to Undo a Merge Conflict

## A Caveat

This approach seems like a good idea on paper - to sidestep the potential pain and anxiety of facing a merge conflict head-on - but it doesn't appear to guarantee success and it may be more trouble than it's worth.

I'm including it for the record to document my thought processes, and in case I decide to revisit it should any new information come to light (as they say!)

----

## Undo a Merge Conflict

_Is there a simple and reliable method to undo a problematic merge and return to a "last known good" state?_

### 'git revert' Versus 'git merge --abort'

_Is it appropriate to use `git revert`?_

_Or is `git merge --abort` a better choice for this scenario?_

My current understanding is that `git revert` is intended to rollback to a particular commit, either the "last known good" commit or one further back in the timeline, depending on what the situation requires.

It seems to me like it would be useful if the issue was on the 'master' branch, but it doesn't seem to be the right choice when it comes to smoothing out local difficulties with feature branches.

So, let's go with `git merge --abort`.

----

### 'git merge --abort'

Here are my thoughts (so far!) on how `git merge --abort` could be used to rollback in the feature branch context.

Here's our hypothetical scenario.

A feature branch is started.

Work is put on hold, for whatever reason, for a number of hours / days / weeks (delete as appropriate!)

The longer the delay in closing off this feature branch, the greater the chance of encountering merge conflicts!

So...

We return to the feature branch (eventually!) and run the command `git merge origin master` to see if any merge conflicts are flagged up.

No?  Amazing!  We proceed to the PR and merge our changes to 'master'.

Yes?  OK, here's what we'll do.

- Abort the merge using `git merge --abort`
- Make sure we have a record of our intended local changes
  - E.g. dump them in a text file
- Delete the feature branch using `git branch -d my-branch`
- Move to the local 'master' branch using `git checkout master`
- Pull from the remote master branch to update the local version
  - `git pull origin master`
- Create a new feature branch
  - `git checkout -b my-branch-v2`
- If they're still appropriate, recreate our previous changes in this new feature branch
- Try the merge process again

Hmmm...

This is good as far as it goes, but is there a better / neater way of capturing our changes before we delete the original feature branch?

It's time to bring in `git stash`!

<https://stackoverflow.com/questions/7694467/resolving-git-merge-conflicts>

----

### 'git stash'

This command should work as follows.

- We "park" our changes by running `git stash` on our original feature branch
- We move over to our local 'master' branch
  - `git checkout master`
- Pull from the remote master branch to update our local version
  - `git pull origin master`
- Create a fresh version of the feature branch
  - `git checkout -b my-branch-v2`
- Use `git stash pop` OR `git stash apply` to bring your parked changes into this new branch
  - TODO: Establish which is better day-to-day - `...pop` or `...apply`?
- All good?  Great!  Now you can go back & delete your original feature branch

This seems pretty funky, right?

However...  

You might find there there are still merge conflicts looming at the end of this process - this isn't a "magic bullet" as the elapsed time in completing your feature branch increases the likelihood that your changes include a conflict with whatever else has been merged to 'master' in the meantime.

----

Further resources to look at:

- <https://www.codeleaks.io/how-to-undo-git-merge/>
