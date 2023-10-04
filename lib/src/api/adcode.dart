import 'package:dio/dio.dart';

class Adcode {
  int _adcode;
  String _name;
  static List<Adcode> _districts = [];

  Adcode._({required int adocde, required String name})
      : this._adcode = adocde,
        this._name = name;

  static Future<Adcode> getAdcode(String apiKey, String keyword) async {
    try {
      Response response = await Dio().get(
          "https://restapi.amap.com/v3/config/district?key=$apiKey&keywords=$keyword&subdistrict=1&extensions=base");
      if (response.data["status"] == "0" ||
          response.data["infocode"] != "10000") {
        throw "Failed to get adcode";
      }

      Map<String, dynamic> city = (response.data["districts"] as List).first;
      for (var i = 0; i < city["districts"].length; i++) {
        Map<String, dynamic> info = city["districts"][i];
        _districts.add(
            Adcode._(adocde: int.parse(info["adcode"]), name: info["name"]));
      }
      return Adcode._(adocde: int.parse(city["adcode"]), name: city["name"]);
    } catch (e) {
      throw "Failed to get adcode";
    }
  }

  int get adcode {
    return _adcode;
  }

  String get name {
    return _name;
  }

  List<Adcode> get districts {
    return _districts;
  }
}
