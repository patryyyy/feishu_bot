// Package imports:
import 'package:dio/dio.dart';

class Adcode {
  final int adcode;
  final String name;

  Adcode._({required this.adcode, required this.name});

  static Future<Adcode> getAdcode(String apiKey, String keyword) async {
    final response = await Dio().get(
      "https://restapi.amap.com/v3/config/district?key=$apiKey&keywords=$keyword&subdistrict=1&extensions=base",
    );

    if (response.data["status"] == "0" ||
        response.data["infocode"] != "10000") {
      throw AdcodeException("Failed to get adcode");
    }

    Map<String, dynamic> city = (response.data["districts"] as List).first;
    return Adcode._(adcode: int.parse(city["adcode"]), name: city["name"]);
  }
}

class AdcodeException implements Exception {
  final String _msg;

  AdcodeException(this._msg);

  @override
  String toString() {
    return "AdcodeException: $_msg";
  }
}
