---
title: "Git Processes, Scripts and Ideas"
date: 2012-03-16 02:56
categories:
- git
- development
---
Lately I've been refining some of my git processes (as well as learning
a lot about git along the way).  I thought I'd write up a post to share
some of the ways i've been using git.

## Workflow

Our typical workflow at [crowdtilt](https://www.crowdtilt.com) is pretty
standard.  We have a `dev` branch, a `master` branch, and various feature/topic
branches.  We also make heavy use of github for pull requests/code reviews.

When I go to develop a new feature/bugfix, I start by creating a new branch
off of the latest `dev`, and start coding.  I often make many small commits
along the way because I'm a strong believer in commit early, commit often.  I
also push my branch to github pretty frequently just to be on the safe side.

Once my feature branch has been tested, and is ready to be merged into `dev`,
I rebase all of my small commits into 1.  We try to keep all of our PR's to 1
commit just to keep our git history clean, useful, and readable as a history
of concise and (hopefully) small changes.  To do this, I have been simply
using:

```
$ git rebase -i dev
```

This will drop me into vim with a lits of all the commits between `dev`'s
`HEAD` and my current branch's `HEAD`.  It will look something like this:

```
pick 1dea3ff Commit #1
pick 57a5a28 Commit #2
pick 3f21ade Commit #3
```

I simply squash all the commits into one by replacing `pick` with `s` on
all but the first line.  This gives me something like this:

```
pick 1dea3ff Commit #1
s 57a5a28 Commit #2
s 3f21ade Commit #3
```

This tells git that I want to squash all of these commits into one.  Once
I quit and save it'll then let me give a new commit message for my new
mega-commit.

Here I try to follow convention with a short summary on the first line,
and then a lengthier description describing my feature/bugfix/whatever in
a paragraph below that.

Once I have my branch neatly tidied up with one descriptive commit, it's time
to pull request.

## Pull Requests and hub

I love the github web interface for reviewing code and checking out diffs, but
it is very tedious to go to the website, find your branch, and make the pull
request through the web interface.  Enter
[hub](https://github.com/defunkt/hub) -- a wonderful command-line tool that
lets you create pull requests (amongst lots of other cool things) right
from the command line.

To do a pull request right from my coding directory, I can simply run:

```
$ hub pull-request "Pull Request Title"
```

The caveat here is that hub (and github, too) default all pull requests
to merge into the `master` branch.  We always merge into `dev`, and then
merge `dev` into `master` when we are ready to deploy changes to production
(I'll talk more about our deploy processes in another article). So to get
it to merge into `dev`, we must run the following:

```
$ hub pull-request "Pull Request Title" -b dev
```

This is closer to what we need, but by default what this will do is setup
a pull request on github from `throughnothing:feature-branch` to
`crowdtilt:dev`.  It does this because it assumes that I want to do a pull
request from my users fork to the original users repository.  We don't really
have each developer fork our repos, we just all work on the same repo in our
own branches, so we really want it to do a pull-request from
`crowdtilt:feature-branch` to `crowdtilt:dev`.  This means we need:

```
$ hub pull-request "Pull Request Title" -b dev -h crowdtilt:feature-branch
```

It seemed really simple at first, but now it's a lot to type.  Time for some
`~/.bashrc` magic.  To make things as simple as possible for our development
process, I've written this little bash function to put in our `~/.bashrc` files
to smooth things out:

``` bash
pullreq() {
    [ -z $BRANCH ] && BRANCH="dev"
    HEAD=$(git symbolic-ref HEAD 2> /dev/null)
    [ -z $HEAD ] && return # Return if no head
    REMOTE=`cat .git/config | grep "remote \"origin\"" -A 2 | tail -n1 | sed 's/.*:\([^\/]*\).*/\1/'`

    hub pull-request -b $BRANCH -h $REMOTE:${HEAD#refs/heads/} $1
}
```

This accepts a `BRANCH` environment variable that can be set, but will default
to `dev` (which is pretty much 90+% of our use cases).  It also parses the
github user that the origin of the repository

Not only has `hub` greatly streamlined our pull request process, but when
combined with the bash function, it eliminates errors of pull requesting
feature branches to be merged into `master` (and even having them
*accidentally* merged into master directly -- that never happens, right?)
instead of `dev`.

Using this script, when we're ready to do a deploy and merge `dev` into `master`
we simply can run (from the `dev` branch):

```
$ BRANCH=master pullreq
```

And the pull request will be created to merge dev into master so we can review
it on github.

## Managing Branch Chaos

I said earlier that I was a believer in commit early, commit often.  Well, I'm
also a believer in small branches.  We pretty much make branches for everything.
Even if it's just a simple css change, or a one-line bug-fix, I like to
quarantine changesets into a branch of their own.  So many times i'll be
caught in the middle of a simple change and have to go tend to something else.
Having branches lets me quickly commit "saving my place", or "WIP"
in my branch, and get to work looking at something in another branch.
My feature branch will be there waiting for me when I'm ready to go back to it.

Additionally, smaller branches make for smaller merges, which are easier to
review, and less prone to introducing glaring errors that could have been
caught.

A side-effect of all this branching and pushing and merging is that you can
quickly get confused about which branches have been merged and which haven't.
The list of branches shown on github and on the command line grows to make it
harder for you to find the branches you still care about.  So of course,
we can delete the branches as we go, but this is very tedious to do so
frequently as you have to delete the branch locally, and on github:

```
$ pullreq
# Review code on github
$ git checkout dev && git merge feature-branch && git push origin dev
$ gut branch -D feature-branch  # delete feature-branch locally
$ git push origin :feature-branch # delete feature-branch on github
```

Enter more `~/.bashrc` goodness.  I wanted a way to streamline
this process as well because i was typing the above waaay too frequently, so
I came up with two handy bash functions:

```
git_purge_local_branches() {
  [ -z $1 ] && return
  BRANCHES=`git branch --merged $1 | grep -v '^*' | grep -v 'master' | grep -v 'dev' | tr -d '\n'`
  echo "Running: git branch -d $BRANCHES"
  git branch -d $BRANCHES
}

git_purge_remote_branches() {
  [ -z $1 ] && return
  git remote prune origin

  BRANCHES=`git branch -r --merged $1 | grep 'origin' | grep -v '/master$' | grep -v '/dev$' | sed 's/origin\//:/g' | tr -d '\n'`
  echo "Running: git push origin $BRANCHES"
  git push origin $BRANCHES
}
```

`git_purge_local_branches()` will -- as the name implies -- purge local
branches that have been merged into the branch you give it.  And
`git_purge_remote_branches()` will do the same but it will remove the branches
from the `origin` remote.  So every now and then, when we get a lot of branches
hanging around getting in our way, we can clean them up with:

```
$ git_purge_local_branches dev
$ git_purge_remote_branches dev
```

And of course, because running 2 commands just became too much, I created
`git_purge`...one purge to rule them all:

```
git_purge() {
  branch=$1
  [ -z $branch ] && branch="dev"
  git_purge_local_branches $branch
  git_purge_remote_branches $branch
}
```

So now its super easy to manage our branch chaos.  When I start to see too
many branches building up, I can simply `git_purge` and it'll wipe out
any branches locally and on the origin that have already been merged
into dev.  Then we're back to a blissful state of branch zen.

## Final Thoughts

That pretty much sums up my current git processes.  I really enjoy how
streamlined things have become, how well our processes work, and how easy it is
to keep our branches clean and clutter-free while at the same time encouraging
us to branch, branch, branch!

How are you using git?  Tell me how I can make my workflow even better and more
kick-ass :)
