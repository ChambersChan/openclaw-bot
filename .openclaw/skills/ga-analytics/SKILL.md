---
name: ga-analytics
description: Fetch Google Analytics 4 data and generate growth insights
triggers:
  - ga analytics
  - google analytics
  - daily analytics
  - fetch analytics
inputs:
  ga_property_id:
    description: GA4 Property ID
    default: ""
  ga_credentials_base64:
    description: Base64 encoded Service Account JSON credentials
    default: ""
  discord_channel:
    description: Discord channel ID to send reports
    default: ""
  site_url:
    description: Website URL for reference
    default: ""
---

# GA Analytics

Fetch Google Analytics 4 data, compare with 7 days ago, and generate growth insights.

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `ga_property_id` | `""` | GA4 Property ID |
| `ga_credentials_base64` | `""` | Base64 encoded credentials |
| `discord_channel` | `""` | Discord channel for reports |
| `site_url` | `""` | Website URL |

## Execution Steps

### 1. Fetch GA Data

Run the analytics script:

```bash
node /root/.openclaw/workspace/skills/ga-analytics/scripts/fetch-ga.cjs
```

The script will output JSON with:
- Yesterday's metrics
- 7 days ago metrics (for comparison)
- Week-over-week change percentages
- Top pages and traffic sources

### 2. Analyze the Data

Based on the fetched data, analyze:

**Traffic Health:**
- Is traffic growing or declining?
- Which channels are driving growth?

**User Behavior:**
- Are users engaged? (engagement rate, session duration)
- What content resonates most?

**Growth Opportunities:**
- Underperforming channels to improve
- High-potential content to amplify

### 3. Generate Growth Insight

Write ONE actionable growth suggestion based on the data. Focus on:

**If traffic is growing:**
- Suggest how to amplify what's working
- Recommend doubling down on top channels

**If traffic is declining:**
- Identify potential causes
- Suggest recovery actions

**If traffic is stable:**
- Suggest experiments to try
- Recommend new channels to explore

### 4. Report to Discord

**IMPORTANT:** After analysis, send a PUBLIC message to the Discord channel.

**Use messaging tool with channel target:**
- Target: `channel:{{discord_channel}}`

**Report format:**
```
📊 Daily Analytics Report

📅 Date: [Yesterday's Date]

👥 Users: [X] ([↑/↓ Y%] vs last week)
📱 Sessions: [X] ([↑/↓ Y%])
👀 Page Views: [X] ([↑/↓ Y%])
🆕 New Users: [X] ([↑/↓ Y%])

🔝 Top Traffic Sources:
1. [Source] - [X] users ([↑/↓ Y%])
2. [Source] - [X] users
3. [Source] - [X] users

📄 Top Pages:
1. [Page] - [X] views
2. [Page] - [X] views
3. [Page] - [X] views

💡 Growth Insight:
[One actionable suggestion based on the data]

{{site_url}}
```

### 5. Error Handling

If GA API fails:
```
❌ Failed to fetch GA analytics data.

Error: [error message]

Please check:
1. GA_PROPERTY_ID is correct
2. GA_CREDENTIALS_BASE64 is valid
3. Service Account has access to GA property
```

## Notes

- Data may have 24-48 hour delay in GA4
- Compare with 7 days ago to account for weekly patterns
- Keep insights actionable and specific
