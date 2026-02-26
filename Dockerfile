# 阶段1: 构建阶段 - 安装依赖
FROM node:22-slim AS builder

WORKDIR /workspace

# 安装编译依赖（临时）
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources \
    && apt-get update && apt-get install -y \
    build-essential \
    python3 \
    git \
    && rm -rf /var/lib/apt/lists/*

# 安装全局 openclaw
RUN npm install -g openclaw \
    && npm cache clean --force

# 安装 bot 依赖
COPY package*.json ./
RUN npm install --production \
    && npm cache clean --force

COPY index.js ./
COPY openclaw.json /root/.openclaw/openclaw.json
# 复制技能到 openclaw 配置目录
COPY .openclaw/skills /root/.openclaw/skills
# 复制工作区文件到 agent workspace
COPY .openclaw/SOUL.md /root/.openclaw/workspace/SOUL.md
COPY .openclaw/AGENTS.md /root/.openclaw/workspace/AGENTS.md
COPY .openclaw/USER.md /root/.openclaw/workspace/USER.md
COPY .openclaw/IDENTITY.md /root/.openclaw/workspace/IDENTITY.md
COPY .openclaw/TOOLS.md /root/.openclaw/workspace/TOOLS.md

# 阶段2: 运行阶段 - 最小化镜像
FROM node:22-slim

WORKDIR /workspace

# 安装 git（技能需要）
RUN apt-get update && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

# 创建 openclaw 配置目录
RUN mkdir -p /root/.openclaw/skills /root/.openclaw/workspace/memory

# 只复制运行时需要的文件
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /workspace/node_modules ./node_modules
COPY --from=builder /workspace/index.js ./
COPY --from=builder /root/.openclaw/openclaw.json /root/.openclaw/openclaw.json
COPY --from=builder /root/.openclaw/skills /root/.openclaw/skills
COPY --from=builder /root/.openclaw/workspace /root/.openclaw/workspace

# 启动
CMD ["node", "index.js"]
