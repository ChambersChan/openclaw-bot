# OpenClaw - Discord AI Bot

基于 OpenClaw 的 Discord AI 助手机器人。

## 环境要求

- Node.js 22+
- Docker (推荐)

## 准备工作

### 1. 配置 OpenClaw

查阅 `.openclaw/` 目录下的文件，对应调整自身定位，如自定义 IDENTITY.md 名称、更新 USER.md 项目信息和负责事项等

### 2. 环境变量

```bash
cp .env.example .env
```

编辑 `.env` 文件，填入你的配置：

| 变量名 | 说明 | 必填 |
|--------|------|------|
| `DISCORD_BOT_TOKEN` | Discord Bot Token | 是 |
| `LITELLM_API_KEY` | LiteLLM API Key | 是 |
| `GH_TOKEN` | GitHub Personal Access Token | 是* |
| `GIT_USER_NAME` | Git 用户名 | 是* |
| `GIT_USER_EMAIL` | Git 邮箱 | 是* |
| `X_API_KEY` | X (Twitter) API Key | 否 |
| `X_API_SECRET` | X (Twitter) API Secret | 否 |
| `X_ACCESS_TOKEN` | X (Twitter) Access Token | 否 |
| `X_ACCESS_SECRET` | X (Twitter) Access Token Secret | 否 |

> *云端自主工作必需。GH_TOKEN 需要 `repo` 和 `workflow` 权限。

### 3. Git 配置

配置 Git 相关环境变量，用于 AI 自主提交代码：

```bash
# GitHub Personal Access Token
# 从 GitHub Settings > Developer settings > Personal access tokens > Tokens (classic) 获取
# 需要权限: repo, workflow
GH_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx

# Git 提交信息
GIT_USER_NAME=Your Name
GIT_USER_EMAIL=your@email.com
```

## 配置 Coding 能力

### 拉取 GitHub 项目

在 Discord 中让 Bot 拉取你的 GitHub 项目：

```
帮我 clone 项目 https://github.com/your-org/your-repo
```

Bot 会使用 `gh repo clone` 命令将项目克隆到工作区的 `~/.openclaw/workspace/projects/` 目录下。

### 工作流程

1. 拉取项目后，Bot 可以在该项目上进行开发工作
2. 完成修改后，Bot 会自动 commit 并 push 到远程仓库
3. 可以让 Bot 创建 PR 进行代码审查

## 快速开始

## 使用 Docker Compose（推荐）

```bash
docker-compose up -d --build
```

> **注意**: Docker Compose 会自动读取当前目录下的 `.env` 文件。

### 验证运行

```bash
# 查看日志
docker logs -f discord-openclaw
```

## 使用 Docker 镜像

### 构建镜像

```bash
docker build -t openclaw-discord-bot:latest .
```

### 运行容器

```bash
docker run -d \
  --name openclaw-discord-bot \
  -e DISCORD_BOT_TOKEN=your_discord_token \
  -e LITELLM_API_KEY=your_api_key \
  -e GH_TOKEN=your_github_token \
  -e GIT_USER_NAME="Your Name" \
  -e GIT_USER_EMAIL="your@email.com" \
  -v $(pwd)/.data:/root/.openclaw \
  openclaw-discord-bot:latest
```

### 目录挂载说明

| 主机路径 | 容器路径 | 说明 |
|----------|----------|------|
| `./.data` | `/root/.openclaw` | OpenClaw 数据目录（包含 projects、skills） |

> 容器会自动 clone 项目到 `~/.openclaw/workspace/projects/`，无需手动挂载项目目录。

## 常用命令

```bash
# 查看容器日志
docker logs -f openclaw-discord-bot

# 停止容器
docker stop openclaw-discord-bot

# 重启容器
docker restart openclaw-discord-bot

# 删除容器
docker rm -f openclaw-discord-bot
```

## 获取 Discord Token

1. 访问 [Discord Developer Portal](https://discord.com/developers/applications)
2. 创建新应用
3. 进入 Bot 页面，创建 Bot
4. 复制 Token
5. **重要**: 在 Bot 页面开启 "Message Content Intent" 选项

## Discord 配置说明

### 用户授权 (allowFrom)

Discord 斜杠命令需要用户授权。需要在两个地方配置 `allowFrom`：

1. `channels.discord.allowFrom` - 消息处理授权
2. `commands.allowFrom.discord` - 斜杠命令授权

```json
{
  "channels": {
    "discord": {
      "allowFrom": ["用户Discord ID"]
    }
  },
  "commands": {
    "allowFrom": {
      "discord": ["用户Discord ID"]
    }
  }
}
```

### 获取 Discord 用户 ID

1. Discord 设置 → 高级 → 开启 "开发者模式"
2. 右键点击用户头像 → "复制用户 ID"

### 添加多用户

```json
"allowFrom": ["用户ID1", "用户ID2", "用户ID3"]
```

### 触发方式 (mentionPatterns)

Bot 只在消息包含指定关键词时响应：

```json
{
  "messages": {
    "groupChat": {
      "mentionPatterns": ["@your-bot-name", "your-bot-name"]
    }
  }
}
```

### 其他 Discord 配置

| 配置项 | 说明 | 可选值 |
|--------|------|--------|
| `streaming` | 流式回复模式 | `"off"`, `"partial"`, `"block"` |
| `ackReaction` | 处理时的表情反应 | emoji，如 `"👀"` |
| `replyToMode` | 回复模式 | `"off"`, `"first"`, `"all"` |
| `groupPolicy` | 群组访问策略 | `"open"`, `"allowlist"` |

## 目录结构

```
openclaw-discord-bot/
├── start.sh                    # 容器启动脚本
├── Dockerfile                  # Docker 构建文件
├── docker-compose.yml          # Docker Compose 配置
├── .env.example                # 环境变量模板
├── openclaw.json               # OpenClaw 配置
└── .openclaw/                  # OpenClaw 工作区模板
    ├── AGENTS.md
    ├── SOUL.md
    ├── USER.md
    ├── IDENTITY.md
    ├── TOOLS.md
    └── skills/                 # 自定义技能
```

**容器内工作区结构:**

```
~/.openclaw/
├── workspace/
│   ├── projects/               # clone 的项目
│   └── skills/                 # 安装的 skills
└── cron/                       # 定时任务
```
