---
name: github-cli
description: Use GitHub CLI (gh) for pull request workflows including creating PRs, code reviews, adding comments, merging, and managing PR metadata. Use when working with GitHub pull requests, reviewing code, or managing GitHub repositories from the command line.
---

# GitHub CLI

Use the GitHub CLI (`gh`) to create pull requests, review code, manage comments, and handle PR workflows without leaving the terminal.

## Prerequisites

- GitHub CLI installed (`gh` command available)
- Authenticated with GitHub (`gh auth login`)
- Inside a git repository or use `-R owner/repo` flag

## Core Workflows

### Create a Pull Request

Basic usage:
```bash
# Create PR with title and body
gh pr create --title "Feature: Add authentication" --body "Implements JWT auth"

# Interactive creation (prompts for details)
gh pr create

# Create as draft
gh pr create --draft --title "WIP: Refactor database"

# Specify base branch
gh pr create --base master --title "New feature"

# Assign reviewers and labels
gh pr create --title "Fix bug" --reviewer user1,user2 --label bug,priority-high
```

Advanced options:
```bash
# Use template file
gh pr create --body-file PR_TEMPLATE.md

# Open in browser instead
gh pr create --web

# Specify different repository
gh pr create -R owner/repo --title "Cross-repo PR"
```

### List and View PRs

List pull requests:
```bash
# List open PRs
gh pr list

# Filter by state, author, assignee, or label
gh pr list --state all
gh pr list --author @me
gh pr list --label bug
gh pr list --search "is:open review:required"

# Limit results
gh pr list --limit 20

# Get as JSON for scripting
gh pr list --json number,title,author,updatedAt
```

View PR details:
```bash
# View in terminal
gh pr view 123

# Open in browser
gh pr view 123 --web

# Get specific fields as JSON
gh pr view 123 --json title,body,comments,reviews

# View diff
gh pr diff 123

# Check CI/CD status
gh pr checks 123
```

### Review Code and Add Comments

Submit reviews:
```bash
# Approve a PR
gh pr review 123 --approve

# Approve with comment
gh pr review 123 --approve --body "LGTM! Great work."

# Request changes
gh pr review 123 --request-changes --body "Please address security concerns"

# Comment without approval/rejection
gh pr review 123 --comment --body "Some questions about the implementation"
```

Add general comments (not on specific lines):
```bash
# Add comment to PR conversation
gh pr comment 123 --body "I've addressed the feedback"

# Add comment from file
gh pr comment 123 --body-file response.md

# Add comment using editor
gh pr comment 123 --editor
```

**Note**: Line-specific code review comments must be done through the interactive review flow or via the web interface. The `gh pr review` command without flags opens an interactive editor where you can add detailed line-by-line comments.

### Read Comments and Reviews

View all comments:
```bash
# View PR with inline comments
gh pr view 123

# Get comments as JSON
gh pr view 123 --json comments --jq '.comments[] | {author: .author.login, body: .body}'

# Get review comments (on code lines)
gh pr view 123 --json reviews --jq '.reviews[] | {author: .author.login, state: .state, body: .body}'
```

### Check PR Status and CI/CD

Monitor checks:
```bash
# View all checks
gh pr checks 123

# Watch checks in real-time (updates every 10s)
gh pr checks 123 --watch

# Check merge readiness
gh pr view 123 --json mergeable,mergeStateStatus,reviewDecision
```

### Merge Pull Requests

```bash
# Merge with merge commit (default)
gh pr merge 123

# Merge with squash
gh pr merge 123 --squash

# Merge with rebase
gh pr merge 123 --rebase

# Merge and delete branch
gh pr merge 123 --delete-branch

# Custom commit message
gh pr merge 123 --squash --subject "feat: add auth" --body "Details here"

# Auto-merge when checks pass
gh pr merge 123 --auto --squash
```

### Edit and Manage PRs

Update PR metadata:
```bash
# Edit title and body
gh pr edit 123 --title "New title" --body "Updated description"

# Manage reviewers
gh pr edit 123 --add-reviewer user1,user2
gh pr edit 123 --remove-reviewer user1

# Manage labels
gh pr edit 123 --add-label bug,priority
gh pr edit 123 --remove-label wontfix

# Add assignees
gh pr edit 123 --add-assignee user1

# Change base branch
gh pr edit 123 --base develop

# Mark draft as ready
gh pr ready 123
```

Close or reopen:
```bash
# Close without merging
gh pr close 123

# Close with comment
gh pr close 123 --comment "Closing in favor of #124"

# Reopen
gh pr reopen 123
```

### Test Changes Locally

```bash
# Checkout PR branch for local testing
gh pr checkout 123
```

This creates and switches to a local branch tracking the PR, useful for testing before review.

## Common Workflows

### Complete Code Review

```bash
# 1. List PRs needing your review
gh pr list --search "review-requested:@me"

# 2. Checkout PR locally
gh pr checkout 123

# 3. Test changes (run tests, review code)

# 4. Submit review
gh pr review 123 --approve --body "LGTM!"
# or
gh pr review 123 --request-changes --body "Please fix the error handling"
```

### Create and Track a PR

```bash
# 1. Create feature branch
git checkout -b feature/new-feature
git add .
git commit -m "feat: implement new feature"
git push origin feature/new-feature

# 2. Create PR
gh pr create \
  --title "feat: Add new feature" \
  --body "Implements X. Closes #456" \
  --reviewer user1,user2 \
  --label feature

# 3. Monitor checks
gh pr checks --watch

# 4. Respond to feedback
# ... make changes ...
git push

gh pr comment <PR_NUMBER> --body "✅ Addressed all feedback"
```

### Find and Filter PRs

```bash
# PRs needing your review
gh pr list --search "review-requested:@me"

# Your open PRs
gh pr list --author @me

# PRs with failed checks
gh pr list --search "is:open status:failure"

# Stale PRs
gh pr list --search "is:open updated:<2024-01-01"
```

## Tips and Best Practices

**Creating PRs**:
- Use descriptive titles (consider conventional commit format)
- Provide context: what changed, why, and link to issues
- Use `--draft` for work-in-progress needing early feedback
- Add relevant labels and reviewers

**Reviewing Code**:
- Be constructive and specific in feedback
- Use `--approve`, `--request-changes`, or `--comment` appropriately
- For line-specific comments, use interactive mode: `gh pr review 123`

**Managing Comments**:
- Address all feedback and mark as resolved
- Add summary comments when pushing new changes
- Use `gh pr view 123` to read all comments before responding

**JSON Output**:
- Use `--json` flag with field names for scripting
- Combine with `--jq` for filtering: `gh pr list --json number,title --jq '.[] | select(.title | contains("bug"))'`
- Common fields: `number`, `title`, `body`, `author`, `state`, `comments`, `reviews`, `mergeable`

## Quick Reference

```bash
# Create PR
gh pr create --title "Title" --body "Description"

# List PRs
gh pr list --author @me
gh pr list --search "review-requested:@me"

# View PR
gh pr view 123
gh pr view 123 --web

# Review
gh pr review 123 --approve
gh pr review 123 --request-changes --body "Feedback"
gh pr comment 123 --body "General comment"

# Merge
gh pr merge 123 --squash --delete-branch

# Edit
gh pr edit 123 --add-reviewer user1
gh pr edit 123 --add-label bug

# Status
gh pr checks 123
gh pr diff 123

# Test locally
gh pr checkout 123
```

## Troubleshooting

**Authentication errors**:
```bash
gh auth status
gh auth login
```

**Not in a git repo**: Either navigate to a repo or use `-R owner/repo` flag

**Line-specific comments**: Use interactive review mode (`gh pr review 123` without flags) or web interface for detailed line-by-line feedback

For more help: `gh pr --help` or `gh pr <subcommand> --help`
