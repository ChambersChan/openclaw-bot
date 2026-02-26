# OpenClaw - Discord AI Bot

基于 OpenClaw 的 Discord AI 助手机器人。

## 环境要求

- Node.js 22+
- Docker (推荐)

## 环境变量

| 变量名 | 说明 | 必填 |
|--------|------|------|
| `DISCORD_TOKEN` | Discord Bot Token | 是 |
| `LITELLM_API_KEY` | LiteLLM API Key | 是 |
| `X_API_KEY` | X (Twitter) API Key | 否 |
| `X_API_SECRET` | X (Twitter) API Secret | 否 |
| `X_ACCESS_TOKEN` | X (Twitter) Access Token | 否 |
| `X_ACCESS_SECRET` | X (Twitter) Access Token Secret | 否 |

## 使用 Docker 镜像

### 构建镜像

```bash
docker build -t openclaw-discord-bot:latest .
```

### 准备工作

查阅 `.openclaw/` 目录下的文件，对应调整自身定位，如自定义 IDENTITY.md 名称、更新 USER.md 项目信息和负责事项等

### 运行容器

```bash
docker run -d \
  --name openclaw-discord-bot \
  -e DISCORD_TOKEN=your_discord_token \
  -e LITELLM_API_KEY=your_api_key \
  -e X_API_KEY=your_x_api_key \
  -e X_API_SECRET=your_x_api_secret \
  -e X_ACCESS_TOKEN=your_x_access_token \
  -e X_ACCESS_SECRET=your_x_access_secret \
  -v /path/to/project1:/workspace/project1 \
  -v /path/to/project2:/workspace/project2 \
  -v $(pwd)/.data:/root/.openclaw \
  openclaw-discord-bot:latest
```

### 目录挂载说明

| 主机路径 | 容器路径 | 说明 |
|----------|----------|------|
| `/path/to/project` | `/workspace/project` | 项目目录 (根据需要添加) |
| `./.data` | `/root/.openclaw` | OpenClaw 数据目录 |

### 使用 Docker Compose

1. 复制配置文件：

```bash
cp docker-compose.example.yml docker-compose.yml
# 编辑 docker-compose.yml 添加项目目录挂载
```

2. `docker-compose.yml` 示例：

```yaml
services:
  openclaw-discord-bot:
    build: .
    image: openclaw-discord-bot:latest
    container_name: openclaw-discord-bot
    restart: unless-stopped
    environment:
      - DISCORD_TOKEN=${DISCORD_TOKEN}
      - LITELLM_API_KEY=${LITELLM_API_KEY}
      - X_API_KEY=${X_API_KEY}
      - X_API_SECRET=${X_API_SECRET}
      - X_ACCESS_TOKEN=${X_ACCESS_TOKEN}
      - X_ACCESS_SECRET=${X_ACCESS_SECRET}
    volumes:
      # 项目目录 (根据需要添加)
      # - /path/to/your/project:/workspace/project
      - ./.data:/root/.openclaw
```

3. 启动：

```bash
docker-compose up -d --build
```

> **注意**: Docker Compose 会自动读取当前目录下的 `.env` 文件。

## 本地开发

### 安装 OpenClaw (全局)

```bash
npm install -g openclaw
```

### 配置环境变量

```bash
# 复制示例配置文件
cp .env.example .env

# 编辑 .env 文件，填入真实的 Token 和 API Key
vim .env
```

### 启动 Bot

```bash
openclaw gateway run
```

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
      "mentionPatterns": ["@zoe-claw", "zoe-claw"]
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
├── start.sh              # 容器启动脚本
├── Dockerfile            # Docker 构建文件
├── docker-compose.yml    # Docker Compose 配置
├── .env.example          # 环境变量模板
├── openclaw.json         # OpenClaw 配置
└── .openclaw/            # OpenClaw 工作区模板
    ├── AGENTS.md
    ├── SOUL.md
    ├── USER.md
    ├── IDENTITY.md
    ├── TOOLS.md
    └── skills/           # 自定义技能
```

**容器内工作区结构:**

```
/workspace/               # OpenClaw cwd
├── project1/             # 项目目录
└── project2/             # 项目目录
```
