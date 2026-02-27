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

# 为 x-post 创建命令链接
if [ -f /root/.openclaw/workspace/skills/x-api/scripts/x-post.mjs ]; then
  ln -sf /root/.openclaw/workspace/skills/x-api/scripts/x-post.mjs /usr/local/bin/x-post
  chmod +x /root/.openclaw/workspace/skills/x-api/scripts/x-post.mjs
fi

# 为自定义技能创建符号链接
mkdir -p /usr/local/lib/node_modules/openclaw/skills
for skill in /root/.openclaw/workspace/skills/*; do
  if [ -d "$skill" ]; then
    skill_name=$(basename "$skill")
    ln -sf "$skill" /usr/local/lib/node_modules/openclaw/skills/"$skill_name"
  fi
done

# 启动 Gateway（前台运行，自动连接配置的 channels）
exec openclaw gateway run --allow-unconfigured
