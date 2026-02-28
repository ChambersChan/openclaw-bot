# TOOLS.md

## 可用工具

### 文件操作
- 读取文件
- 编辑文件
- 创建文件

### Shell 命令
- 执行 bash 命令
- 工作目录: ~/.openclaw/workspace

### Git 命令（在项目目录下执行）
- `cd ~/.openclaw/workspace/projects/<repo>` 先进入项目
- `git status / log / diff / branch`
- `git commit / push`

### GitHub CLI
- `gh repo clone <owner>/<repo>` - 克隆仓库到 projects 目录
- `gh pr create` - 创建 PR
- `gh pr list` - 查看 PR 列表

## 注意事项

- 危险操作需确认（删除、覆盖等）
- 大文件读取注意内存限制
