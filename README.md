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

## 使用 Docker 镜像

### 构建镜像

```bash
docker build -t openclaw-discord-bot:latest .
```

### 运行容器

```bash
docker run -d \
  --name openclaw-discord-bot \
  -e DISCORD_TOKEN=your_discord_token \
  -e LITELLM_API_KEY=your_api_key \
  -v ~/vika/sandagent:/workspace/sandagent \
  -v ~/vika/kapps:/workspace/kapps \
  -v $(pwd)/.openclaw:/workspace \
  openclaw-discord-bot:latest
```

### 目录挂载说明

| 主机路径 | 容器路径 | 说明 |
|----------|----------|------|
| `~/vika/sandagent` | `/workspace/sandagent` | sandagent 项目目录 |
| `~/vika/kapps` | `/workspace/kapps` | kapps 项目目录 |
| `./openclaw.json` | `/root/.openclaw/openclaw.json` | OpenClaw 配置文件 |
| `./.openclaw` | `/root/.openclaw/workspace` | OpenClaw 工作区 (AGENTS.md, SOUL.md, memory/ 等) |
| `./openclaw-agents` | `/root/.openclaw/agents` | OpenClaw sessions (聊天历史) |

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

### 安装依赖

```bash
npm install
```

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
# 方式一：使用环境变量文件
source .env && node index.js

# 方式二：手动设置环境变量
export DISCORD_TOKEN=your_discord_token
export LITELLM_API_KEY=your_api_key
node index.js
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

## 目录结构

```
zoe-claw/
├── index.js              # 入口文件
├── package.json          # 依赖配置
├── Dockerfile            # Docker 构建文件
├── docker-compose.yml    # Docker Compose 配置
├── openclaw.json         # OpenClaw 配置 (workspace: /workspace)
└── .openclaw/            # OpenClaw 工作区 (挂载到 /workspace)
    ├── AGENTS.md         # 智能体操作指南
    ├── SOUL.md           # 人设、语气和边界
    ├── USER.md           # 用户信息
    ├── IDENTITY.md       # 智能体身份
    ├── TOOLS.md          # 工具说明
    ├── HEARTBEAT.md      # 心跳检查清单
    ├── memory/           # 记忆日志
    └── skills/           # 技能模块
```

**挂载的项目目录:**

```
~/vika/
├── sandagent/            # 挂载到 /workspace/sandagent
└── kapps/                # 挂载到 /workspace/kapps
```

**容器内工作区结构:**

```
/workspace/               # OpenClaw cwd
├── AGENTS.md
├── SOUL.md
├── ...
├── sandagent/            # 项目目录
└── kapps/                # 项目目录
```
