#!/bin/bash

# ============================================
# 目录结构初始化
# ============================================

mkdir -p /root/.openclaw/workspace/projects  # clone 的项目
mkdir -p /root/.openclaw/workspace/skills     # 安装的 skills
mkdir -p /root/.openclaw/cron                 # 定时任务

# 复制配置文件
cp /template/.openclaw/openclaw.json /root/.openclaw/openclaw.json

# ============================================
# Git & GitHub 配置（云端自主工作）
# ============================================

# 配置 git 用户信息
if [ -n "$GIT_USER_NAME" ]; then
    git config --global user.name "$GIT_USER_NAME"
    echo "[Git] user.name: $GIT_USER_NAME"
else
    git config --global user.name "OpenClaw Bot"
    echo "[Git] user.name: OpenClaw Bot (default)"
fi

if [ -n "$GIT_USER_EMAIL" ]; then
    git config --global user.email "$GIT_USER_EMAIL"
    echo "[Git] user.email: $GIT_USER_EMAIL"
fi

# 配置 gh CLI 认证
if [ -n "$GH_TOKEN" ]; then
    echo "$GH_TOKEN" | gh auth login --with-token
    gh auth setup-git  # git push/pull 自动使用 gh 认证
    echo "[GitHub] Authenticated via GH_TOKEN"
else
    echo "[Warning] GH_TOKEN not set, GitHub operations will fail"
fi

# ============================================
# 安装核心 Skills
# ============================================

SKILLS_DIR="/root/.openclaw/workspace/skills"

install_skill() {
    local skill_name=$1
    if [ ! -d "$SKILLS_DIR/$skill_name" ]; then
        echo "[Skill] Installing $skill_name..."
        cd "$SKILLS_DIR"
        npx clawhub@latest install "$skill_name" --quiet 2>/dev/null
        cd - > /dev/null
    else
        echo "[Skill] $skill_name already installed"
    fi
}

# GitHub 操作（clone/push/pr 等）
install_skill "github"

# ============================================
# 复制模板 Skills
# ============================================

# 只复制模板里已有的 skills（不删除运行时新建的）
for skill in /template/.openclaw/workspace/skills/*; do
    [ -e "$skill" ] && cp -r "$skill" "$SKILLS_DIR/"
done

# 复制 workspace 下的 md 文件
cp /template/.openclaw/workspace/*.md /root/.openclaw/workspace/ 2>/dev/null || true

# 安装 skill 依赖
for skill in "$SKILLS_DIR"/*; do
    if [ -f "$skill/package.json" ]; then
        echo "[Skill] Installing deps for $(basename "$skill")..."
        cd "$skill" && npm install --production && cd - > /dev/null
    fi
done

# ============================================
# 创建符号链接（让 openclaw 能找到 skills）
# ============================================

mkdir -p /usr/local/lib/node_modules/openclaw/skills
for skill in "$SKILLS_DIR"/*; do
    if [ -d "$skill" ]; then
        skill_name=$(basename "$skill")
        ln -sf "$skill" /usr/local/lib/node_modules/openclaw/skills/"$skill_name"
    fi
done

# 为 x-post 创建命令链接
if [ -f "$SKILLS_DIR/x-api/scripts/x-post.mjs" ]; then
    ln -sf "$SKILLS_DIR/x-api/scripts/x-post.mjs" /usr/local/bin/x-post
    chmod +x "$SKILLS_DIR/x-api/scripts/x-post.mjs"
fi

# ============================================
# 启动 Gateway
# ============================================

echo "============================================"
echo "OpenClaw Gateway starting..."
echo "Projects dir: ~/.openclaw/workspace/projects"
echo "Skills dir:   ~/.openclaw/workspace/skills"
echo "============================================"

exec openclaw gateway run --allow-unconfigured
