---
name: ga-analytics
description: Fetch Google Analytics 4 data and generate growth insights
metadata:
  openclaw:
    emoji: "📊"
triggers:
  - ga analytics
  - google analytics
  - daily analytics
  - fetch analytics
inputs:
  discord_channel:
    description: Discord channel ID to send reports
    default: ""
  site_url:
    description: Website URL for reference
    default: ""
---

# GA Analytics

Fetch Google Analytics 4 data, compare with 7 days ago, and generate growth insights.

## Environment Variables (Pre-configured)

The following environment variables are already set in the container:
- `GA_PROPERTY_ID` - GA4 Property ID
- `GA_CREDENTIALS_BASE64` - Base64 encoded Service Account JSON

**You do NOT need to set these manually. Just run the script.**

## Inputs

| Variable | Default | Description |
|----------|---------|-------------|
| `discord_channel` | `""` | Discord channel for reports |
| `site_url` | `""` | Website URL |

## Execution Steps

### 1. Fetch GA Data

Run the analytics script directly (environment variables are already configured):

```bash
node /root/.openclaw/workspace/skills/ga-analytics/scripts/fetch-ga.cjs
```

The script will automatically read `GA_PROPERTY_ID` and `GA_CREDENTIALS_BASE64` from environment and output JSON with:
- Yesterday's metrics
- 7 days ago metrics (for comparison)
- Week-over-week change percentages
- Top pages and traffic sources

### 2. Analyze the Data

Based on the fetched data, perform comprehensive analysis:

**Traffic Health:**
- Is traffic growing or declining?
- Which channels are driving growth?
- Is the traffic source diversified or overly dependent on a single channel?

**User Behavior:**
- Are users engaged? (check sessions per user ratio)
- What content resonates most?
- Are users returning or mostly one-time visitors?

**Conversion Indicators:**
- New vs returning user ratio
- Page views per session trend
- Traffic quality assessment

**Growth Opportunities:**
- Underperforming channels to improve
- High-potential content to amplify
- Missing traffic sources to explore

### 3. Generate Detailed Growth Insights

**IMPORTANT: Generate 2-3 specific, actionable suggestions. Each suggestion must be detailed enough that someone can follow it step by step without additional research.**

#### Suggestion Structure (Required):

Each suggestion MUST include:

1. **Problem/Opportunity** - What's the issue or opportunity
2. **Why it matters** - Brief explanation of impact
3. **Step-by-step Action Plan** - Numbered concrete steps
4. **Tools/Resources needed** - Specific tools, links, or templates
5. **Time estimate** - How long it takes
6. **Expected outcome** - What success looks like

#### Choose suggestion direction based on traffic trend:

**🔴 Significant Traffic Decline (>50% down):**

**Suggestion 1: Technical Audit (Always include when traffic drops significantly)**
- Step 1: Open browser DevTools → Network tab → filter by "google" or "analytics"
- Step 2: Check if GA requests are being sent (look for collect?v=2 requests)
- Step 3: Verify GA tag exists in page source
- Step 4: Use GA Debug extension or GA4 DebugView
- Step 5: Check recent git commits for tracking code changes
- Provide specific code snippets to check if applicable

**Suggestion 2: Emergency Traffic Recovery**
- List 3-5 specific platforms to post on immediately
- Provide content templates/ideas for each platform
- Specify posting frequency and timing

**🟡 Slight Decline or Stable:**

**Suggestion 1: Channel Diversification**
- Analyze current traffic sources
- Recommend 2-3 new channels with specific reasons
- Provide step-by-step setup guide for each new channel
- Include content ideas tailored to the website's topic

**Suggestion 2: SEO Quick Wins**
- Analyze top pages and suggest content expansions
- Provide specific keyword suggestions
- Include on-page optimization checklist

**🟢 Traffic Growing:**

**Suggestion 1: Scale What Works**
- Identify top-performing content/channels
- Provide specific amplification strategies
- Include paid promotion options if applicable

**Suggestion 2: Build Community/Retention**
- Specific community building tactics
- Email capture strategies
- Return visitor incentives

#### Social Media Marketing Execution Guide:

**Twitter/X Promotion:**
- Step 1: Create a thread about your product (3-5 tweets)
- Step 2: Use hashtags: #BuildInPublic #IndieHacker #SaaS #[your-niche]
- Step 3: Post at 9am-12pm EST for best engagement
- Step 4: Engage with replies within first 30 minutes
- Content ideas: "Day X of building [product]", feature announcements, user success stories
- Tools: Hypefury, Typefully for scheduling

**Reddit Promotion:**
- Step 1: Find relevant subreddits (r/SaaS, r/entrepreneur, r/webdev, r/[your-niche])
- Step 2: Read rules carefully - many don't allow self-promotion
- Step 3: Contribute helpful comments for 1-2 weeks before posting
- Step 4: Share as "I built X to solve Y problem" not "Check out my product"
- Best subreddits for products: r/SideProject, r/AlphaandBetausers, r/startups
- Timing: Post on Tuesday-Thursday morning US time

**Hacker News:**
- Step 1: Wait for Show HN post (first Wednesday of each month is best)
- Step 2: Title format: "Show HN: [Product] - [One-line description]"
- Step 3: Be ready to respond to comments for 2-3 hours
- Step 4: Have a demo video or screenshots ready
- Tips: Post at 8-9am PST, focus on technical details

**Product Hunt:**
- Step 1: Prepare assets (screenshots, demo video, tagline)
- Step 2: Find a hunter or hunt yourself
- Step 3: Launch at 12:01am PST
- Step 4: Engage in comments all day
- Step 5: Share launch on Twitter, LinkedIn
- Tools: Ship by Product Hunt for waitlist

**Developer Communities:**
- Dev.to: Write technical blog posts, cross-post from your blog
- Hashnode: Build developer audience, good for SEO
- Indie Hackers: Share your journey, get feedback
- Discord servers: Join relevant ones, provide value before promoting

**SEO Quick Wins:**
- Step 1: Use Google Search Console to find pages with impressions but low clicks
- Step 2: Improve title tags and meta descriptions for those pages
- Step 3: Add internal links from high-traffic pages to important pages
- Step 4: Check for 404 errors and fix them
- Step 5: Add schema markup for rich snippets
- Tools: Ahrefs free tools, Screaming Frog, Google PageSpeed Insights

**Content Repurposing:**
- Turn top pages into: Twitter threads, LinkedIn posts, Reddit posts, newsletter content
- Create "How to" guides from FAQ pages
- Make comparison pages (vs competitors)
- Build resource pages that others want to link to

### 4. Report to Discord

**IMPORTANT:** After analysis, send a PUBLIC message to the Discord channel.

**Use messaging tool with channel target:**
- Target: `channel:{{discord_channel}}`

**Report Format:**
```
📊 Daily Analytics Report

📅 Date: [Yesterday's Date]

👥 Users: [X] (↑/↓ Y% vs last week)
📱 Sessions: [X] (↑/↓ Y%)
👀 Page Views: [X] (↑/↓ Y%)
🆕 New Users: [X] (↑/↓ Y%)

📈 Traffic Trend:
[One sentence summary of overall traffic health status]

🔝 Top Traffic Sources:
1. [Source] - [X] users ([percentage]%)
2. [Source] - [X] users ([percentage]%)
3. [Source] - [X] users ([percentage]%)

📄 Top Pages:
1. [Page path] - [X] views
2. [Page path] - [X] views
3. [Page path] - [X] views

💡 Growth Suggestions:

**[Suggestion 1 Title]**
📝 Why: [Why this matters - impact explanation]

✅ Action Plan:
1. [Step 1 with specific details - tools to use, URLs to visit, etc.]
2. [Step 2 with specific details]
3. [Step 3 with specific details]
4. [Continue as needed]

🔧 Tools: [Specific tools, links, code snippets]
⏱️ Time: [Estimated time to complete]
🎯 Expected: [What success looks like, quantifiable if possible]

---

**[Suggestion 2 Title]**
📝 Why: [Why this matters]

✅ Action Plan:
1. [Step 1]
2. [Step 2]
3. [Step 3]

🔧 Tools: [Specific tools/resources]
⏱️ Time: [Estimate]
🎯 Expected: [Expected outcome]

---

**[Suggestion 3 Title]** (optional)
📝 Why: [Why this matters]

✅ Action Plan:
1. [Step 1]
2. [Step 2]

🔧 Tools: [Tools]
⏱️ Time: [Estimate]
🎯 Expected: [Expected outcome]

{{site_url}}
```

### 5. Error Handling

If GA API fails:
```
❌ Failed to fetch GA analytics data.

Error: [error message]
```

## Reference: 2026 Marketing Trends

When generating suggestions, consider these latest trends:

**Social Media Marketing Trends:**
- Short video content efficiency improved, production cost reduced by 90%
- "Social search" becoming new traffic entry point, younger users trust creator's authentic experiences
- Private community operations bring 3-5x higher customer lifetime value
- AI-driven personalized content distribution

**Effective Channel Mix:**
1. **Short Video Platforms** (TikTok/Douyin) - Quick exposure
2. **Content Communities** (Xiaohongshu/Zhihu) - Build trust and professional image
3. **Community Management** (Discord/WeChat Groups) - Improve user retention and repeat visits
4. **Search Engines** (SEO) - Long-term stable traffic

## Notes

- Data may have 24-48 hour delay in GA4
- Compare with 7 days ago to account for weekly patterns
- Suggestions must be actionable with concrete execution methods
- Adjust number of suggestions (2-3) based on actual data
