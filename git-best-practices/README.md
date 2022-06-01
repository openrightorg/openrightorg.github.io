# Git best practices

*by Don Mahurin, 2022*

## Background

Source control is a crucial tool for engineers, enabling them
to track, isolate, and release software. Every engineer should
understand the importance of source control and how to use it properly.
Unfortunately, engineers ( and managers, architects ... ) are sometimes
lacking essential knowledge of source control.

This lack of knowledge can lead to wasted time, incomplete
documentation, lost information, and a lack of accountability. By
understanding the importance of source control and how to use it
effectively, engineers can improve the quality and maintainability of
their code and avoid common pitfalls.

**The Purpose of Source Control**

Source control serves several important purposes in software
development:

1.  **Documentation**: Source control comments and scope rationale
    provide valuable documentation for software development. This
    documentation can help developers understand why certain changes
    were made and can also aid in troubleshooting.

2.  **Versioning**: Source control allows developers to indicate
    specific revisions for release or checkpointing. This can help
    developers go to known versions of software and help ensure that the
    intended version of the software is being used.

3.  **Traceability**: Source control provides traceability, allowing
    developers to understand who or where software changes originate.
    This information is important for explanation and can also be
    necessary for legal or compliance reasons.

## Essential git commands

As a prerequisite to a discussion of git best practices, we need to go
over some basic git commands.

**How to pull**

The general syntax of git pull is easy. We specify the remote repo and
branch. If we do not specify, the current remote and branch are used.

```
git pull [remote] [branch]
```

But often we would like to specify different local and remote branches.

And usually we should use --rebase to ensure that the local branch is in
sync with the remote side (more or why this is preferred later).

```
git pull --rebase <remote> <remote_branch>:<local_branch>
```

**How to push**

Pushing with git is similar to pull, we can also specify the remote repo
and branch to push to.

```
git push [remote] [branch]
```

The local and remote branch can also be specified. Though note that they
are reversed from what they are with pull.

```
git push <remote> <local_branch>:<remote_branch>
```

**How to change commits**

Before a commit is pushed to a shared repository, you can (and should)
modify commits to clarify the intent of the commit.

To modify the commit message:

```
git commit --amend
```

To add or modify a file in the current commit

```
git commit --amend file
```

To take a file out of the current commit:

```
git reset HEAD^ -- file
git commit --amend
```

## Guidelines for good commits

Now we have some basic commands covered. Let us refine our commits.

**Guidelines for Meaningful Commits in Source Control**

In order to create and maintain individual meaning for commits in source
control, it is recommended to follow ACID-like transaction properties:

1.  **Atomic**: Each commit should be independent and self-contained. It
    should be possible to apply the changes in the commit without
    relying on changes from other commits.

2.  **Consistent**: Commits should follow consistent conventions for
    commit messages and comments. This makes it easier for other
    developers to understand the changes and their purpose.

3.  **Isolated**: Commits should have a limited scope of change. They
    should be focused on a single task or issue and not include
    unrelated changes.
    Commits should also separate functional changes (changes to code or
    behavior) from non-functional changes (such as changes to file
    names, indentation, or formatting).

4.  **Durable**: Commits and their associated comments should persist
    intact over time. This ensures that the meaning of the commit is
    clear and understandable even in the future.

By following these guidelines, developers can create meaningful and
understandable commits that improve the traceability and maintainability
of the source code.

**Guidelines for Writing Meaningful Commit Messages**

Commits serve as important documentation for software development, so
it's important to provide clear and concise explanations of the changes
being made. A meaningful commit message should include the following
information:

- Who: Identify whether the change originated from you or someone else.
  If changes were made by multiple authors, they should be separated.

- What: Clearly document what is being changed. The output of 'git show'
  should match the files changed and the commit message.

- When: Ensure that the commit date is accurate to the change.

- Why: Explain the reason for the change, including any issue tracking
  IDs. This can help other developers understand the context of the
  change and the problem that it's intended to solve.

Any imported changes should be kept separate, perhaps in a separate
repository, and follow similar conventions to document the origin, date,
and purpose..

By following these guidelines, developers can write more effective and
understandable commit messages that improve the documentation,
traceability, and maintainability of the software code.

## More essential commands

Let us build on our basic use of git, and give a few more necessary git
commands

**Amending an earlier commit**

We previously went over how to change the current commit, but sometimes
we need to change an earlier commit.

```
git rebase -i revision^
```

In the interactive editor, mark the commit as “edit” then modify with
the commands discussed for changing the current commit.

**Combining commits**

Sometimes for clarity or to follow guidelines, we would like to combine
commits. We do this by using “squash”

Git rebase -i revision^

Then we mark commits to be combined (with the previous commit), with
“squash”

When we squash, we should remember to make commits more meaningful
according to our stated guidelines.

Good squash usage (atomic, simplified result)

<table style="margin: 0; padding: 0; border: none; border-collapse: collapse; border-spacing: 0"><tr>
<td style="border: none; margin: 0; padding: 0"><pre><code>C15 Fix main prompt spelling
C14 Remove extra info field
C13 Change main input field prompt
C12 Set fields with default values
C11 Add extra info field
</code></pre></td>
<td style="border: none">
=>
</td>
<td style="border: none"><pre><code><strike>squash C15 Fix main prompt spelling</strike>
pick C13 Change main input field prompt
pick C12 Set fields with default values
<strike>C14 Remove extra info field</strike>
<strike>C11 Add extra info field</strike></code></pre></td>
</tr></table>

Here, the spelling fix is combined with the change that introduced it,
and the premature extra field code is completely removed

Less good squash usage (non-atomic, unsimplified result)

<table style="margin: 0; padding: 0; border: none; border-collapse: collapse; border-spacing: 0"><tr>
<td style="border: none; margin: 0; padding: 0"><pre><code>C15 Fix main prompt spelling
C14 Remove extra info field
C13 Change main input field prompt
C12 Set fields with default values
C11 Add extra info field
</code></pre></td>
<td style="border: none">
=>
</td>
<td style="border: none"><pre><code><strike>squash C15 Fix main prompt spelling</strike>
<strike>squash C14 Remove extra info field</strike>
<strike>squash C13 Change main input field prompt</strike>
pick C12 Set fields with default values
pick C11 Add extra info field</code></pre></td>
</tr></table>

Here, unrelated changes are merged together, and the commit message no
longer matches the change

## Rebasing

As previously mentioned, when we pull, we should usually use --rebase.

We do this because:

- To synchronize our changes with the upstream repository.

- Tends to encourage commits to be more atomic and portable

- Forces commits to be merged individually, rather than in bulk

If we do not rebase and we merge instead, we can cause the following
issues:

- Combined individual commits may not be equivalent to merge result

- Tracking changes to individual commits may become difficult or
  impossible

- History becomes cluttered with merge commits

- History is more difficult to follow as it is no longer linear

## Branches

Branches are useful to allow us to separate independent development -
Though, we should strive to have a minimal number of branches. Fewer
branches means less duplication of effort.

Here, the simplest approach is the best.

- Use a single main branch (master/main)

- All other branches (testing, feature, release, next), should
  branch/re-branch from the main branch

This follows the general git flow conventions of GIT (man gitworkflows),
Gihub workflow, Gitlab workflow, the Linux kernel.

Note, that this does not include a ‘develop’branch. Of course, you
should create temporary feature/development branches as needed, and use
meaningful names. But having a persistent “develop”branch (the nvie
strategy), unnecessarily adds a second main branch, and more work. My
observation is that the nvie strategy devolves into ‘develop’being the
main branch.

## Combining repos

Large projects are often composed of many repositories.

There are a few common ways to combine repos for your project. Some
good. Some less good.

**git submodule** (recommended) - external repo’s are configured and
specific revisions to use are tracked in the main repo.

- Recommend using “pure virtual”modeled main repo, where the repo only
  contains repo references, and no other files

- Recommend using “update --remote”as a normal case. This exposes issues
  more rapidly.

- With the conventions above, git submodule can behave similarly to the
  Google “repo”tool.

**repo** (tool from Google) (recommended) - repositories and revisions
are specified in a XML manifest file, which itself can (and should) be
tracked in its own repository.

**git subtree** - changes from other repo’s are imported into the main
repo as a directory, and may be synchronized indirectly using git
subtree

**“Mono-repo”** (not recommended) - Only one repo - used to avoid
complexity of properly syncing repos of a large project, but in doing
so, breaks fundamental collaborative and decentralized nature of git.
Syncing with upstream projects becomes nearly impossible, without
additional tools. Additional tools would basically be reinventing ‘git
subtree’ This is a case of the invention of tools due to not
understanding existing tools.

## Other important git tools

Some other important git tools to understand, that we did not cover

git cherry-pick - pull in changes from other branches

- git stash - set aside (but keep) current modifications

- git revert - note, this does not remove a commit, it just creates a
  revert commit to reverse the change

- git mergetool/difftool - use a graphical tool to merge conflicts or
  compare

- git blame - find who made specific changes in a file

- git bisect - find when an issue was introduced by using this binary
  search mechanism

- git filter-branch/filter-repo - mass changes of a repo (advanced)

- git lfs - essential to allow large files to be stored efficiently in
  git
