// index.js
const { Client, GatewayIntentBits } = require("discord.js");
const { exec, spawn } = require("child_process");

const WORKSPACE = "/workspace";

const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent
  ]
});

// 启动 OpenClaw Gateway
function startGateway() {
  return new Promise((resolve) => {
    const gateway = spawn("openclaw", ["gateway", "start", "--allow-unconfigured"], {
      cwd: WORKSPACE,
      detached: true,
      stdio: "ignore"
    });

    gateway.on("error", (err) => {
      console.error("Gateway启动失败:", err);
    });

    console.log("OpenClaw Gateway 启动中...");
    // 等待 gateway 初始化
    setTimeout(resolve, 5000);
  });
}

client.on("clientReady", async () => {
  console.log(`Logged in as ${client.user.tag}`);
  await startGateway();
  console.log("OpenClaw Gateway 已启动");
});

client.on("messageCreate", (msg) => {
  if (msg.author.bot) return;
  if (!msg.mentions.has(client.user)) return;

  const question = msg.content.replace(/<@!?\d+>/, "").trim();
  if (!question) return;

  // 转义引号
  const escapedQuestion = question.replace(/"/g, '\\"').replace(/\n/g, " ");

  // 使用 openclaw agent
  const command = `openclaw agent --agent main --message "${escapedQuestion}"`;

  console.log(`执行命令: ${command}`);

  exec(command, { maxBuffer: 1024 * 1024, cwd: WORKSPACE }, (err, stdout, stderr) => {
    if (err) {
      console.error("执行出错:", err.message);
      msg.reply(`执行出错: ${err.message.substring(0, 200)}`);
      return;
    }
    const reply = (stdout || stderr || "没有结果。").trim();
    // Discord 消息限制 2000 字符
    msg.reply(reply.substring(0, 2000));
  });
});

client.login(process.env.DISCORD_TOKEN);
