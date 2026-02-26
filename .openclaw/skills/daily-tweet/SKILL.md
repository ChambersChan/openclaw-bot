---
name: daily-tweet
description: Daily tweet about project development progress
triggers:
  - daily tweet
  - post tweet
inputs:
  git_author:
    description: Git author name to filter commits
    default: ""
  repo_path:
    description: Path to repository (relative to working_dir)
    default: ""
  remote:
    description: Git remote name
    default: "origin"
  branch:
    description: Git branch to check
    default: "main"
  site_url:
    description: Website URL to include in tweet
    default: ""
  hashtag:
    description: Hashtag for tweet
    default: ""
---

# Daily Tweet

Auto-post daily development progress to X (Twitter).

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `git_author` | `""` | Git author name to filter |
| `repo_path` | `""` | Path to repository |
| `remote` | `origin` | Git remote name |
| `branch` | `main` | Git branch to check |
| `site_url` | `""` | Website URL |
| `hashtag` | `""` | Hashtag for tweet |

## Working Directory

- `{{repo_path}}`

## Execution Steps

### 1. Fetch Latest Code

```bash
cd {{repo_path}}
git fetch {{remote}} {{branch}}
```

### 2. Get Today's Git Log

```bash
git log {{remote}}/{{branch}} --author="{{git_author}}" --since="1 day ago" --oneline --no-merges
```

### 3. Compare with Yesterday's Log

- Read yesterday's log: `~/.openclaw/.daily-tweet-last-log.txt`
- Compare to check if there are new commits

### 4. Generate Tweet Content

**Case A: New commits found**
- Summarize today's commits
- Generate a concise tweet (MAX 280 chars)
- Format: Brief intro + key changes + hashtag + site_url

**Case B: No new commits + Weekday (Mon-Fri)**
- Tweet: "Under active development. Stay tuned for updates! {{hashtag}}"

**Case C: No new commits + Weekend**
- Skip posting, report "Weekend break" to Discord

### 5. Post to X

Use `x-post` command to publish tweet:

```bash
x-post "Your tweet content here (max 280 chars)"
```

**Requirements:**
- x-api skill must be installed: `npx clawhub@latest install x-api`
- X API credentials must be configured in environment variables or config file
- Keep tweet under 280 characters

**Capture the result:**
- On success: `x-post` returns tweet URL (e.g., `https://x.com/username/status/123456`)
- On failure: `x-post` returns error message

### 6. Report to Discord

**IMPORTANT:** Always send feedback to Discord after posting (success or failure).

Use messaging tool to send to Discord:

**Success message:**
```
Daily tweet posted successfully!

Tweet: [tweet URL]
Content: [brief summary of what was posted]
Commits: [number of commits included]
```

**Failure message:**
```
Failed to post daily tweet.

Error: [error message]
Content attempted: [what you tried to post]
```

**Skip message (weekend):**
```
Skipped daily tweet (weekend break).
```

### 7. Save Today's Log

```bash
git log {{remote}}/{{branch}} --author="{{git_author}}" --since="1 day ago" --oneline --no-merges > ~/.openclaw/.daily-tweet-last-log.txt
```

## Tweet Guidelines

- Maximum 280 characters
- Use English
- Include `{{hashtag}}` and `{{site_url}}` if provided
- Be concise and engaging
- Focus on user-facing changes when possible

## Example Tweets

```bash
x-post "Update: Refactored ID handling for improved architecture. Building towards better code injection! #Project https://example.com/"
```

```bash
x-post "Under active development. Stay tuned for exciting updates! #Project https://example.com/"
```
