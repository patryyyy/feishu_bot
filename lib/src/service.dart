// ignore_for_file: non_constant_identifier_names

// Project imports:
import 'package:feishu_bot/feishu_bot.dart';

class Service {
  final FeishuBot _bot;

  Service(this._bot);

  Future<void> sendWeatherInfo({
    required String cityName,
    required int adcode,
    required String amap_key,
  }) async {
    WeatherData weatherData =
        await WeatherData.getWeatherData(amap_key, adcode);

    await _bot.sendMessage(
      SimpleCard(
        title: '$cityName天气',
        content: weatherData.toString(),
        urlDesc: "更多信息",
        urlHoverDesc: "更多天气信息",
        url: "https://www.msn.cn/zh-cn/weather",
      ),
    );
    log.t(
        'Successfully sent weather information at ${DateTime.now().toString()}');
  }
}
