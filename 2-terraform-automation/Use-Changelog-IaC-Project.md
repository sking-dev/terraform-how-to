# How to Use a Changelog in an IaC Project

## Objective

As an IaC engineer, I'd like use a changelog to inform team members, and any other interested parties, about changes to the project's codebase and thereby the associated deployments.

----

## Caveat

This is a "nice to have" which seems like a good idea (to me, anyway!) but the changelog concept may not be appropriate for a project that's focused on Infrastructure as Code.

Let's find out..!

----

## What is a Changelog?

_A changelog is a file which contains a curated, chronologically ordered list of notable changes for each version of a project._

Source: <https://keepachangelog.com/en/1.0.0/>

## What Does an IaC Changelog Look Like?

One thing that makes me think I'm barking up the wrong tree is that I haven't found any examples online - so far - of what a changelog should (or could) look like for an IaC project.

Perhaps the most obvious blocker is that IaC is typically not versioned and released in the same way as software development code.

This is particularly true of IaC that deploys a long-lived infrastructure estate: many changes will be made over time, and these are usually small-scale, incremental changes that aren't "customer-facing" - in other words, no one outside of the immediate team will know or care about these changes (unless they go wrong!) - and explicitly versioning each change would create administrative overhead without any compelling value.

_Disclaimer: the above is my opinion at the time of writing, and it may change going forward._

TODO: Investigate if there is any potential benefit in adopting **semantic versioning** to version Infrastructure as Code.  

_It may be that this depends on the shape of the codebase e.g. a collection of Terraform modules may lend themselves more easily to versioning than a collection of "static" Terraform files._

----

## What Could Go Into an IaC Changelog?

In the context of a GitOps workflow for IaC, we have the following explicit sources of information regarding a given change to the code and the associated deployment of IaaS or PaaS resources.

- The work item / ticket that the feature branch is based on
- The updated code itself
- The `git commit` message
- The Pull Request

The quickest / easiest one to gain access to will be the `git commit` message.

However, there's a school of thought which maintains that the "quick win" of directing output from `git log` to a `CHANGELOG.md` file is problematic for a number of reasons.

- Commit message will vary in quality across a project team
  - Equal weight should be given to "the what" and "the why" but this is not guaranteed
    - TODO: It may be possible to enforce good commit message hygiene as a way of addressing this weakness - have a look at this...
      - <https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html>
      - <https://github.com/tommarshall/git-good-commit>
- Poor "signal to noise ratio"
  - A changelog only needs to include the notable changes that summarise the project's development
    - Commits will tend to include the steps and missteps taken along the way which can result in a lot of "noise"
- Commit messages may be couched in technical language and / or omit background information
  - They may not explain each change clearly enough to a wider audience

----

## Can a Changelog Be Automated?

Yes, it can!  Here are a couple of links for future reference.

- <https://mokkapps.de/blog/how-to-automatically-generate-a-helpful-changelog-from-your-git-commit-messages/>
- <https://noobygames.de/automatically-create-a-changelog-using-azure-devops/>

----

## Conclusion

As per above, there are a few "known unknowns" which are currently blocking the adoption of changelog.

Until these gaps are filled in, the jury's out on whether this concept can add any real value to an IaC project.

Watch this space..!

----

## Acknowledgments

Useful resources that aren't explicitly referenced elsewhere in this document.

- <https://www.freecodecamp.org/news/a-beginners-guide-to-git-what-is-a-changelog-and-how-to-generate-it/>
- <https://www.reddit.com/r/devops/comments/mlso73/keeping_a_changelog_file/?sort=old>
  - <https://github.com/tommarshall/git-good-commit>
  - <https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html>
- <https://stackoverflow.com/questions/3523534/what-are-some-good-ways-to-manage-a-changelog-using-git>
