import 'package:dio/dio.dart';

class WeatherData {
  String _province;
  String _city;
  int _adcode;
  String _weather;
  int _temperature;
  String _winddirection;
  String _windpower;
  int _humidity;
  String _reporttime;

  WeatherData._(
      {required String province,
      required String city,
      required int adcode,
      required String weather,
      required int temperature,
      required String winddirection,
      required String windpower,
      required int humidity,
      required String reporttime})
      : this._province = province,
        this._city = city,
        this._adcode = adcode,
        this._weather = weather,
        this._temperature = temperature,
        this._winddirection = winddirection,
        this._windpower = windpower,
        this._humidity = humidity,
        this._reporttime = reporttime;

  static Future<WeatherData> getWeatherData(String apiKey, int city) async {
    try {
      Response response = await Dio().get(
          "https://restapi.amap.com/v3/weather/weatherInfo?key=$apiKey&city=$city&extensions=base");
      if (response.data["status"] == "0" ||
          response.data["infocode"] != "10000") {
        throw "Failed to get weather data";
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
    } catch (e) {
      throw "Failed to get weather data";
    }
  }

  String get province {
    return _province;
  }

  String get city {
    return _city;
  }

  int get adcode {
    return _adcode;
  }

  String get weather {
    return _weather;
  }

  int get temperature {
    return _temperature;
  }

  String get winddirection {
    return _winddirection;
  }

  String get windpower {
    return _windpower;
  }

  int get humidity {
    return _humidity;
  }

  String get reporttime {
    return _reporttime;
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
