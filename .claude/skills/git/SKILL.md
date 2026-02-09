---
name: git
description: Use git for version control including commits, branches, merging, rebasing, stashing, cherry-picking, and history management. Use when working with git repositories, managing code changes, resolving conflicts, or tracking project history.
---

# Git Version Control

Use git for version control operations including branching, committing, merging, and managing repository history.

## Prerequisites

- Git installed (`git --version`)
- Inside a git repository (`git init` if needed)
- Git user configured (`git config user.name` and `git config user.email`)

## Core Workflows

### Initialize and Clone

```bash
# Initialize new repository
git init

# Clone existing repository
git clone https://github.com/user/repo.git

# Clone with specific branch
git clone -b develop https://github.com/user/repo.git

# Clone with depth (shallow clone)
git clone --depth 1 https://github.com/user/repo.git
```

### Check Status and Changes

```bash
# View repository status
git status

# Short status format
git status -s

# View changes (unstaged)
git diff

# View staged changes
git diff --staged

# View changes for specific file
git diff path/to/file

# Show changes between branches
git diff main..feature-branch
```

### Stage and Commit Changes

Basic commits:
```bash
# Stage specific files
git add file1.js file2.js

# Stage all changes
git add .

# Stage all tracked files (excluding new files)
git add -u

# Interactively stage changes
git add -p

# Commit staged changes
git commit -m "feat: add user authentication"

# Commit with detailed message
git commit -m "feat: add authentication" -m "Implements JWT-based auth with refresh tokens"

# Stage and commit in one step
git commit -am "fix: resolve memory leak"
```

Amend commits:
```bash
# Amend last commit message
git commit --amend -m "New message"

# Add changes to last commit (keep message)
git add forgotten-file.js
git commit --amend --no-edit

# Amend with new author
git commit --amend --author="Name <email@example.com>"
```

### Branch Management

Create and switch:
```bash
# Create new branch
git branch feature-name

# Create and switch to new branch
git checkout -b feature-name

# Switch to existing branch
git checkout branch-name

# Create branch from specific commit
git checkout -b hotfix abc123

# Modern syntax (Git 2.23+)
git switch feature-name
git switch -c new-feature
```

List and manage:
```bash
# List local branches
git branch

# List all branches (local + remote)
git branch -a

# List remote branches
git branch -r

# Delete local branch
git branch -d feature-name

# Force delete local branch
git branch -D feature-name

# Delete remote branch
git push origin --delete feature-name

# Rename current branch
git branch -m new-name

# Rename specific branch
git branch -m old-name new-name
```

### Merging

```bash
# Merge branch into current branch
git merge feature-branch

# Merge with commit message
git merge feature-branch -m "Merge feature X"

# Merge without fast-forward (always create merge commit)
git merge --no-ff feature-branch

# Merge and squash commits
git merge --squash feature-branch

# Abort merge if conflicts
git merge --abort
```

### Rebasing

```bash
# Rebase current branch onto main
git rebase main

# Interactive rebase (edit last 3 commits)
git rebase -i HEAD~3

# Continue after resolving conflicts
git rebase --continue

# Skip current commit during rebase
git rebase --skip

# Abort rebase
git rebase --abort

# Rebase and preserve merge commits
git rebase -p main
```

Interactive rebase operations:
- `pick` - keep commit as-is
- `reword` - change commit message
- `edit` - stop for amending
- `squash` - combine with previous commit
- `fixup` - combine with previous, discard message
- `drop` - remove commit

### Remote Operations

Configure remotes:
```bash
# Add remote
git remote add origin https://github.com/user/repo.git

# List remotes
git remote -v

# Remove remote
git remote remove origin

# Rename remote
git remote rename origin upstream

# Change remote URL
git remote set-url origin https://github.com/user/new-repo.git
```

Fetch and pull:
```bash
# Fetch from remote (doesn't merge)
git fetch origin

# Fetch all remotes
git fetch --all

# Pull (fetch + merge)
git pull

# Pull with rebase instead of merge
git pull --rebase

# Pull specific branch
git pull origin main
```

Push:
```bash
# Push to remote
git push origin main

# Push and set upstream
git push -u origin feature-branch

# Push all branches
git push --all

# Push tags
git push --tags

# Force push (use with caution!)
git push --force

# Safer force push (rejects if remote has changes)
git push --force-with-lease
```

### Stashing

```bash
# Stash current changes
git stash

# Stash with message
git stash save "WIP: refactoring auth"

# Stash including untracked files
git stash -u

# List stashes
git stash list

# Apply most recent stash (keep in stash)
git stash apply

# Apply specific stash
git stash apply stash@{2}

# Pop most recent stash (remove from stash)
git stash pop

# Drop specific stash
git stash drop stash@{1}

# Clear all stashes
git stash clear

# Show stash contents
git stash show
git stash show -p  # with diff
```

### View History

```bash
# View commit history
git log

# Compact one-line format
git log --oneline

# Show last N commits
git log -n 5

# Show commits with diffs
git log -p

# Show commits for specific file
git log -- path/to/file

# Graph view of branches
git log --graph --oneline --all

# Search commits by message
git log --grep="fix bug"

# Show commits by author
git log --author="John"

# Show commits in date range
git log --since="2024-01-01" --until="2024-02-01"

# Beautiful custom format
git log --graph --pretty=format:'%C(yellow)%h%Creset -%C(red)%d%Creset %s %C(green)(%cr) %C(bold blue)<%an>%Creset'
```

### Undoing Changes

Discard changes:
```bash
# Discard unstaged changes in file
git checkout -- file.js

# Discard all unstaged changes
git checkout -- .

# Modern syntax (Git 2.23+)
git restore file.js
git restore .

# Unstage file (keep changes)
git reset HEAD file.js

# Modern syntax
git restore --staged file.js
```

Reset commits:
```bash
# Soft reset - keep changes staged
git reset --soft HEAD~1

# Mixed reset - keep changes unstaged (default)
git reset HEAD~1

# Hard reset - discard all changes (dangerous!)
git reset --hard HEAD~1

# Reset to specific commit
git reset --hard abc123

# Reset single file to specific commit
git checkout abc123 -- path/to/file
```

Revert commits:
```bash
# Create new commit that undoes changes
git revert abc123

# Revert without committing
git revert -n abc123

# Revert merge commit
git revert -m 1 abc123

# Revert range of commits
git revert abc123..def456
```

### Cherry-Picking

```bash
# Apply commit from another branch
git cherry-pick abc123

# Cherry-pick multiple commits
git cherry-pick abc123 def456

# Cherry-pick range of commits
git cherry-pick abc123^..def456

# Cherry-pick without committing
git cherry-pick -n abc123

# Continue after resolving conflicts
git cherry-pick --continue

# Abort cherry-pick
git cherry-pick --abort
```

### Conflict Resolution

```bash
# Show conflicts
git status

# View conflicted files
git diff --name-only --diff-filter=U

# Use ours (current branch) for file
git checkout --ours path/to/file

# Use theirs (incoming branch) for file
git checkout --theirs path/to/file

# After resolving, mark as resolved
git add path/to/file

# Abort merge/rebase
git merge --abort
git rebase --abort
```

### Tags

```bash
# Create lightweight tag
git tag v1.0.0

# Create annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Tag specific commit
git tag -a v1.0.0 abc123 -m "Tag older commit"

# List tags
git tag
git tag -l "v1.*"

# Show tag details
git show v1.0.0

# Push tags to remote
git push origin v1.0.0
git push --tags

# Delete local tag
git tag -d v1.0.0

# Delete remote tag
git push origin --delete v1.0.0
```

### Clean Up

```bash
# Remove untracked files (dry run)
git clean -n

# Remove untracked files
git clean -f

# Remove untracked files and directories
git clean -fd

# Remove ignored files too
git clean -fdx

# Prune remote branches no longer on remote
git remote prune origin

# Delete merged branches
git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
```

## Common Workflows

### Feature Branch Workflow

```bash
# 1. Update main branch
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b feature/new-feature

# 3. Make changes and commit
git add .
git commit -m "feat: implement new feature"

# 4. Keep feature branch updated
git checkout main
git pull
git checkout feature/new-feature
git rebase main

# 5. Push feature branch
git push -u origin feature/new-feature

# 6. After PR merge, cleanup
git checkout main
git pull
git branch -d feature/new-feature
```

### Fix Mistake in Last Commit

```bash
# Forgot to add a file
git add forgotten-file.js
git commit --amend --no-edit

# Wrong commit message
git commit --amend -m "Correct message"

# Wrong changes entirely
git reset --soft HEAD~1
# Make corrections
git commit -m "Corrected commit"
```

### Sync Fork with Upstream

```bash
# Add upstream remote (once)
git remote add upstream https://github.com/original/repo.git

# Fetch upstream changes
git fetch upstream

# Merge upstream into your main
git checkout main
git merge upstream/main

# Push to your fork
git push origin main
```

### Squash Multiple Commits

```bash
# Interactive rebase
git rebase -i HEAD~4

# In editor, change 'pick' to 'squash' or 's' for commits to combine
# Save and close editor
# Edit combined commit message
# Force push if already pushed
git push --force-with-lease
```

### Recover Lost Commits

```bash
# Show reflog (history of HEAD)
git reflog

# Find lost commit and checkout
git checkout abc123

# Or create branch from it
git checkout -b recovered-branch abc123

# Or cherry-pick it
git cherry-pick abc123
```

## Tips and Best Practices

**Commits**:
- Write clear, descriptive commit messages
- Use conventional commits format: `type(scope): message`
- Commit early and often with logical units of work
- Don't commit sensitive data (use `.gitignore`)

**Branches**:
- Use descriptive branch names: `feature/`, `bugfix/`, `hotfix/`
- Keep branches short-lived
- Delete merged branches to keep repo clean
- Pull latest changes before creating new branches

**Merging vs Rebasing**:
- Use merge for public branches to preserve history
- Use rebase for private branches to keep clean history
- Never rebase public/shared branches
- Use `--force-with-lease` instead of `--force`

**Conflicts**:
- Resolve conflicts carefully, test after resolution
- Communicate with team when conflicts arise
- Use visual merge tools when helpful: `git mergetool`

**Remote Work**:
- Pull before push to avoid conflicts
- Push regularly to backup your work
- Use `--force-with-lease` for safer force pushes
- Fetch frequently to stay updated

## Quick Reference

```bash
# Status and changes
git status
git diff
git log --oneline

# Branch operations
git checkout -b new-branch
git branch -d old-branch
git merge feature-branch

# Stage and commit
git add .
git commit -m "message"
git commit --amend

# Remote operations
git pull
git push
git push -u origin branch-name

# Undo changes
git restore file.js
git reset HEAD~1
git revert abc123

# Stash
git stash
git stash pop
git stash list

# History
git log --graph --oneline
git reflog
```

## Troubleshooting

**Detached HEAD state**:
```bash
# Create branch from current position
git checkout -b new-branch-name
```

**Accidentally committed to wrong branch**:
```bash
# On wrong branch, note the commit hash
git log -1  # Copy the commit hash

# Switch to correct branch
git checkout correct-branch
git cherry-pick <commit-hash>

# Return to wrong branch and remove commit
git checkout wrong-branch
git reset --hard HEAD~1
```

**Merge conflicts**:
```bash
# View conflicted files
git status

# After resolving in editor
git add .
git commit  # or git merge --continue
```

**Need to undo force push**:
```bash
# Find commit before force push
git reflog
git reset --hard <commit-before-force-push>
git push --force-with-lease
```

**Configure default editor**:
```bash
git config --global core.editor "code --wait"  # VS Code
git config --global core.editor "vim"           # Vim
```

For more help: `git <command> --help` or `man git-<command>`
