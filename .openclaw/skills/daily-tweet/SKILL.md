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
  discord_channel:
    description: Discord channel ID to send public notifications
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

**CRITICAL: X has a strict 280 character limit. Your tweet MUST be under 280 characters or it will fail with 403 error.**

**WRITE FROM PRODUCT PERSPECTIVE:**
- Focus on USER BENEFITS, not technical details
- Say what users can DO, not what code changed
- Be exciting and engaging

**Bad examples (too technical):**
- "Refactored sandock and bumped version" ❌
- "Updated API endpoints for better performance" ❌
- "Fixed bug in session handling" ❌

**Good examples (product-focused):**
- "Ship AI agents to production faster with our new deployment tools" ✅
- "Your coding agents just got smarter - now with better memory" ✅
- "Build AI-powered features in minutes, not weeks" ✅

**STRICT FORMAT - Use this exact structure:**
```
Update: [One sentence summary] 🚀

Today's progress:
- [commit 1 - short description]
- [commit 2 - short description]
- [commit 3 - short description]

{{hashtag}}
{{site_url}}
```

**Case A: New commits found**
- Start with "Update: [summary] 🚀"
- Add "Today's progress:" section
- List up to 3-4 key commits as bullet points with "-"
- End with hashtag and site_url (if configured)
- Total MUST be under 280 characters including line breaks
- Use \n for line breaks

**Case B: No new commits + Weekday (Mon-Fri)**
- Tweet:
```
Update: Building something great! 🚀

Stay tuned for what's coming next.

{{hashtag}}
{{site_url}}
```

**Case C: No new commits + Weekend**
- Skip posting, report "Weekend break" to Discord

**VALIDATION STEP - REQUIRED:**
Before posting, use this command to count characters:
```bash
echo -n "Your tweet content here" | wc -c
```
If the count is > 280, you MUST shorten by removing less important commits.

**FORMATTING RULES:**
- Use \n for line breaks in x-post command
- Start with "Update:" and add 🚀 emoji
- Use "-" for bullet points under "Today's progress:"
- Hashtag on its own line
- site_url on its own line at the end (if configured)
- Keep each bullet point short (under 40 chars)

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

**IMPORTANT:** After posting, send a PUBLIC message to the Discord channel @mentioning the user.

**Use messaging tool with channel target:**
- Target: `channel:{{discord_channel}}` (use the discord_channel input)
- This sends a public message visible to everyone

**Success message:**
```
<@[user_id]> Daily tweet posted!

Tweet: [tweet URL]
Commits: [number of commits]
```

**Failure message:**
```
<@[user_id]> Failed to post daily tweet.

Error: [error message]
```

**Skip message (weekend):**
```
<@[user_id]> Skipped daily tweet (weekend break).
```

**Note:**
- Use `channel:{{discord_channel}}` as the target (e.g., `channel:978510023904854047`)
- Use `<@[user_id]>` format to @mention the user (e.g., `<@978510023904854047>`)
- If discord_channel is not set, skip sending the public notification

### 7. Save Today's Log

```bash
git log {{remote}}/{{branch}} --author="{{git_author}}" --since="1 day ago" --oneline --no-merges > ~/.openclaw/.daily-tweet-last-log.txt
```

## Tweet Guidelines

**HARD LIMIT: 280 characters maximum (including line breaks). Tweets exceeding this WILL FAIL.**

- Use English
- Start with "Update:" and 🚀 emoji
- Use bullet points (-) for commits under "Today's progress:"
- Keep each bullet short (under 40 chars)
- Hashtag on its own line at the end
- site_url on its own line if configured
- If too long, remove less important commits

## Example Tweets

**With commits:**
```bash
x-post $'Update: Continuing active development! 🚀\n\nToday\'s progress:\n- Added Discord integration\n- Fixed tweet formatting\n- Upgraded to gemini-3.1-pro\n\n#OpenClaw\nhttps://openclaw.ai'
```

**No new commits (weekday):**
```bash
x-post $'Update: Building something great! 🚀\n\nStay tuned for what\'s coming next.\n\n#OpenClaw\nhttps://openclaw.ai'
```

**Without site_url:**
```bash
x-post $'Update: New features shipped! 🚀\n\nToday\'s progress:\n- Added X API integration\n- Improved error handling\n\n#BuildInPublic'
```
