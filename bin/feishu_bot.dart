import 'dart:io';

import 'package:cron/cron.dart';

import 'package:feishu_bot/feishu_bot.dart';

void main(List<String> args) async {
  // 获取环境变量
  String CITY = Platform.environment["CITY"] ?? "";
  String GAODE_API_KEY = Platform.environment["GAODE_API_KEY"] ?? "";
  String FEISHU_BOT_URL = Platform.environment["FEISHU_BOT_URL"] ?? "";
  String FEISHU_BOT_SIGNATURE =
      Platform.environment["FEISHU_BOT_SIGNATURE"] ?? "";

  // 判断是否为空
  if (GAODE_API_KEY.isEmpty ||
      FEISHU_BOT_SIGNATURE.isEmpty ||
      FEISHU_BOT_URL.isEmpty ||
      CITY.isEmpty) {
    stderr.writeln(
        "ERROR: Could not get API Key, please check if the environment variables are set correctly");
    exit(1);
  }

  // 获取城市adcode
  Adcode adcode = await Adcode.getAdcode(GAODE_API_KEY, CITY);

  print("Started successfully at ${DateTime.now().toString()}");

  final cron = Cron();

  cron.schedule(Schedule.parse("0 0 9,12,15,18,21 * * *"), () async {
    await sendWeatherInfo(adcode.adcode, adcode.name, GAODE_API_KEY,
        FEISHU_BOT_SIGNATURE, FEISHU_BOT_URL);
  });
}

Future<void> sendWeatherInfo(int city, String name, String GAODE_API_KEY,
    String FEISHU_BOT_SIGNATURE, String FEISHU_BOT_URL) async {
  WeatherData weatherData =
      await WeatherData.getWeatherData(GAODE_API_KEY, city);
  FeishuBot feishuBot = FeishuBot(FEISHU_BOT_URL, FEISHU_BOT_SIGNATURE);

  await feishuBot.sendMessage(Message("Hi, 新的天气来喽"));
  await feishuBot.sendMessage(MessageCard(
      name, weatherData.toString(), "https://www.msn.cn/zh-cn/weather"));
}
