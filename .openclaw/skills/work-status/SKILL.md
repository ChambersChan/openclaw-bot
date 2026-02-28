---
name: work-status
description: 报告当前工作进度
triggers:
  - what are you working on
  - what am I working on
  - recent work
  - current work
  - status report
  - work status
  - 忙什么
  - 最近在做什么
  - 工作进度
  - 进度
---

# Work Status

报告当前工作进度。

## Environment

- `GIT_USER_NAME` - used for git author filter

## 工作目录

- `~/.openclaw/workspace/projects/` - 所有项目

## 操作步骤

### 1. 列出所有项目

```bash
ls ~/.openclaw/workspace/projects/
```

### 2. 遍历每个项目

对每个项目目录执行：

```bash
cd ~/.openclaw/workspace/projects/<project>
git log --author="$GIT_USER_NAME" --oneline -10
git branch --show-current
git status --short
```

### 3. 汇总报告

总结所有项目的最近工作内容。
