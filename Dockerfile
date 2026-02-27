# 阶段1: 构建阶段 - 安装依赖
FROM node:22-slim AS builder

WORKDIR /workspace

# 换国内源
RUN sed -i 's|deb.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list.d/debian.sources

# 安装编译依赖（临时）
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    git \
    && rm -rf /var/lib/apt/lists/*

# 安装全局 openclaw
RUN npm install -g openclaw \
    && npm cache clean --force

# 阶段2: 运行阶段 - 最小化镜像
FROM node:22-slim

WORKDIR /workspace

# 换国内源
RUN sed -i 's|deb.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list.d/debian.sources

# 安装 git（技能需要）
RUN apt-get update && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

# 安装 Google Analytics Data API 客户端
RUN npm install -g @google-analytics/data \
    && npm cache clean --force

# 创建目录
RUN mkdir -p /root/.openclaw/workspace

# 只复制运行时需要的文件
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder /usr/local/bin /usr/local/bin

# 复制配置模板（首次启动时使用）
COPY openclaw.json /template/.openclaw/openclaw.json
COPY .openclaw /template/.openclaw/workspace

# 复制启动脚本
COPY start.sh ./
RUN chmod +x start.sh

# 启动
CMD ["./start.sh"]
