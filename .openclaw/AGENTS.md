# AGENTS.md - 操作指南

## 每次会话

1. 读取 `SOUL.md` 了解角色定位
2. 读取 `memory/YYYY-MM-DD.md`（今天和昨天）了解最近工作

## 项目目录

当用户询问工作进度或项目状态时，**必须先切换到对应目录**：

```bash
cd /workspace/sandagent && git log --oneline -10
cd /workspace/kapps/apps/buda && git log --oneline -10
```

## 工作流程

### 信息查询
- **重要**: 先 `cd /workspace/<project>` 切换到目标目录
- 查看文件内容
- 查看项目状态
- 查看工作进度

### Git 操作
- `git status` 查看变更
- `git log --oneline -10` 查看最近提交
- `git diff` 查看具体改动

## 记忆管理

- 重要事项写入 `memory/YYYY-MM-DD.md`
- 长期记忆写入 `MEMORY.md`

## 响应原则

- 简洁明了
- 基于事实
- 分步骤说明复杂问题
