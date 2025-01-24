// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class FeishuBot {
  final String _webhookUrl;
  final String? _signature;

  FeishuBot(this._webhookUrl, [this._signature]);

  Future<void> sendMessage(Message message) async {
    Map<String, dynamic> msg = message.msg;

    if (_signature != null) {
      int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      String sign = _generateSecret(_signature!, timestamp);

      msg["timestamp"] = timestamp.toString();
      msg["sign"] = sign;
    }

    await Dio().post(
      _webhookUrl,
      data: jsonEncode(msg),
      queryParameters: {"Content-Type": "application/json"},
    );
  }

  String _generateSecret(String secret, int timestamp) {
    // 把timestamp+"\n"+密钥当做签名字符串
    String stringToSign = '$timestamp\n$secret';

    // 使用HmacSHA256算法计算签名
    var hmac = Hmac(sha256, utf8.encode(stringToSign));
    var signData = hmac.convert(utf8.encode(''));

    return base64.encode(signData.bytes);
  }
}

class Message {
  late final Map<String, dynamic> msg;

  Message() {
    msg = {
      "msg_type": "text",
      "content": {"text": msg},
    };
  }

  static String escapeJson(String input) {
    return input
        .replaceAll(r'\', r'\\') // 转义反斜杠
        .replaceAll('"', r'\"') // 转义双引号
        .replaceAll('\n', r'\n') // 转义换行符
        .replaceAll('\r', r'\r') // 转义回车符
        .replaceAll('\t', r'\t'); // 转义制表符
  }
}

class SimpleCard implements Message {
  @override
  late final Map<String, dynamic> msg;

  SimpleCard({
    required String title,
    required String content,
    required String urlDesc,
    required String urlHoverDesc,
    required String url,
  }) {
    msg = {
      "msg_type": "interactive",
      "card": {
        "type": "template",
        "data": {
          "template_id": "AAqF8ubMRVDNV",
          "template_version_name": "1.0.0",
          "template_variable": {
            "title": title,
            "content": content,
            "url_desc": urlDesc,
            "url_hover_desc": urlHoverDesc,
            "url": url,
          }
        }
      }
    };
  }
}
