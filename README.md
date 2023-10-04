# Feishu Bot

一个简单的飞书机器人用于推送天气信息，会在每天9点、12点、15点、18点与21点推送天气消息

## 使用

条件：

- 申请高德”Web服务API”密钥（Key）
- 创建飞书机器人，并打开签名校验

步骤：

1. 克隆本项目源代码，使用`dart pub get && dart compile exe bin/feishu_bot.dart`编译
2. 在运行可执行文件之前，添加以下环境变量：

```
CITY                 (中文城市名称)
GAODE_API_KEY        (高德API Key)
FEISHU_BOT_URL       (飞书机器人webhook地址)
FEISHU_BOT_SIGNATURE (飞书机器人签名校验密钥)
```

3. 启动程序

## 许可证

本项目采用**MIT**许可证