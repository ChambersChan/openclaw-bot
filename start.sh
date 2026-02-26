#!/bin/bash

# 创建目录
mkdir -p /root/.openclaw/workspace/skills

# 复制配置文件
cp /template/.openclaw/openclaw.json /root/.openclaw/openclaw.json

# 只复制模板里有的配置文件
cp /template/.openclaw/workspace/*.md /root/.openclaw/workspace/

# 只复制模板里已有的 skills（不删除运行时新建的）
for skill in /template/.openclaw/workspace/skills/*; do
  [ -e "$skill" ] && cp -r "$skill" /root/.openclaw/workspace/skills/
done

# 启动 bot
exec node index.js
