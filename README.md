## 🚀 Quickly Start

### 1. 准备工作
```bash
cp .env.example .env
# 编辑 .env 填入TOKEN和 API 密钥
```

编辑 IDENTITY.md 和 USER.md 自定义名称和填入项目信息

### 2. 启动服务

````bash
docker build -t claw-discord-bot .
docker-compose up -d
````