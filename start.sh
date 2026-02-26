#!/bin/bash

# 创建目录
mkdir -p /root/.openclaw/workspace/skills
mkdir -p /root/.openclaw/cron

# 复制配置文件
cp /template/.openclaw/openclaw.json /root/.openclaw/openclaw.json

# 只复制模板里有的配置文件
cp /template/.openclaw/workspace/*.md /root/.openclaw/workspace/

# 只复制模板里已有的 skills（不删除运行时新建的）
for skill in /template/.openclaw/workspace/skills/*; do
  [ -e "$skill" ] && cp -r "$skill" /root/.openclaw/workspace/skills/
done

# 启动 Gateway（后台运行）
nohup openclaw gateway run --allow-unconfigured > /tmp/gateway.log 2>&1 &

# 等待 Gateway 就绪
echo "Waiting for Gateway to be ready..."
for i in {1..30}; do
  if openclaw cron list >/dev/null 2>&1; then
    echo "Gateway is ready!"
    break
  fi
  sleep 1
done

# 启动 bot
exec node index.js
