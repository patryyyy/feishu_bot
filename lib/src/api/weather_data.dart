// Package imports:
import 'package:dio/dio.dart';

class WeatherData {
  final String province;
  final String city;
  final int adcode;
  final String weather;
  final int temperature;
  final String winddirection;
  final String windpower;
  final int humidity;
  final String reporttime;

  WeatherData._({
    required this.province,
    required this.city,
    required this.adcode,
    required this.weather,
    required this.temperature,
    required this.winddirection,
    required this.windpower,
    required this.humidity,
    required this.reporttime,
  });

  static Future<WeatherData> getWeatherData(String apiKey, int adcode) async {
    Response response = await Dio().get(
      "https://restapi.amap.com/v3/weather/weatherInfo?key=$apiKey&city=$adcode&extensions=base",
    );
    if (response.data["status"] == "0" ||
        response.data["infocode"] != "10000") {
      throw WeatherDataException("Failed to get weather data");
    }
    Map<String, dynamic> weatherData = (response.data["lives"] as List).first;
    return WeatherData._(
        province: weatherData["province"],
        city: weatherData["city"],
        adcode: int.parse(weatherData["adcode"]),
        weather: weatherData["weather"],
        temperature: int.parse(weatherData["temperature"]),
        winddirection: weatherData["winddirection"],
        windpower: weatherData["windpower"],
        humidity: int.parse(weatherData["humidity"]),
        reporttime: weatherData["reporttime"]);
  }

  @override
  String toString() {
    StringBuffer str = StringBuffer();
    DateTime now = DateTime.now();
    str.write("${now.toString().substring(0, 19)}\n");

    str.writeln("天气: $weather");
    str.writeln("温度: $temperature℃");
    str.writeln("风向: $winddirection");
    str.writeln("风力级别: $windpower级");
    str.writeln("空气湿度: $humidity");
    str.writeln("数据发布时间: $reporttime");

    return str.toString();
  }
}

class WeatherDataException implements Exception {
  final String _msg;

  WeatherDataException(this._msg);

  @override
  String toString() {
    return "WeatherDataException: $_msg";
  }
}
