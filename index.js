// index.js
const { Client, GatewayIntentBits } = require("discord.js");
const { spawn } = require("child_process");

const WORKSPACE = "/workspace";

const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent
  ]
});

client.on("clientReady", async () => {
  console.log(`Logged in as ${client.user.tag}`);
});

client.on("messageCreate", async (msg) => {
  if (msg.author.bot) return;
  if (!msg.mentions.has(client.user)) return;

  const question = msg.content.replace(/<@!?\d+>/, "").trim();
  if (!question) return;

  console.log(`执行命令: openclaw agent --agent main --local --message "${question}"`);

  // 先发送一个占位消息
  const replyMsg = await msg.reply("🦞 思考中...");

  const agent = spawn("openclaw", ["agent", "--agent", "main", "--local", "--message", question], {
    cwd: WORKSPACE
  });

  let fullReply = "";
  let lastEditTime = 0;
  let pendingEdit = null;

  // 编辑消息（带节流，Discord 限制 5秒内最多5次编辑）
  const editReply = async (text) => {
    const now = Date.now();
    const timeSinceLastEdit = now - lastEditTime;

    if (timeSinceLastEdit < 1000) {
      // 节流：1秒内不重复编辑，记录待编辑内容
      pendingEdit = text;
      return;
    }

    lastEditTime = now;
    pendingEdit = null;

    try {
      await replyMsg.edit(text.substring(0, 2000));
    } catch (e) {
      // 编辑失败忽略
    }
  };

  // 实时输出 stdout
  agent.stdout.on("data", async (data) => {
    const text = data.toString();
    process.stdout.write(text); // 实时打印到控制台
    fullReply += text;
    await editReply(fullReply);
  });

  // 实时输出 stderr
  agent.stderr.on("data", (data) => {
    process.stderr.write(data.toString());
  });

  agent.on("close", async (code) => {
    // 确保最后一次编辑生效
    if (pendingEdit || fullReply) {
      const finalReply = (pendingEdit || fullReply).trim() || "没有结果。";
      try {
        await replyMsg.edit(finalReply.substring(0, 2000));
      } catch (e) {}
    }
  });

  agent.on("error", async (err) => {
    console.error("执行出错:", err.message);
    try {
      await replyMsg.edit(`执行出错: ${err.message}`);
    } catch (e) {}
  });
});

client.login(process.env.DISCORD_TOKEN);
