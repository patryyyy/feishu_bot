import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class FeishuBot {
  String _webhookUrl;
  String? _signature;

  FeishuBot(this._webhookUrl, [this._signature]);

  Future<void> sendMessage(Message message) async {
    Map<String, dynamic> msg = message.msg;

    if (this._signature != null) {
      int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      String sign = _generateSecret(this._signature!, timestamp);

      msg["timestamp"] = timestamp.toString();
      msg["sign"] = sign;
    }

    await Dio().post(this._webhookUrl, data: jsonEncode(msg));
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
  Map<String, dynamic>? _msg;

  Message(String msg) {
    Map<String, dynamic> str = {
      "msg_type": "text",
      "content": {"text": "$msg"}
    };

    this._msg = str;
  }

  Map<String, dynamic> get msg {
    return this._msg!;
  }
}

class MessageCard implements Message {
  @override
  Map<String, dynamic>? _msg;

  MessageCard(String title, String content, [String? url]) {
    Map<String, dynamic> str = {
      "msg_type": "interactive",
      "card": {
        "header": {
          "title": {"content": "$title", "tag": "plain_text"}
        },
        "elements": [
          {
            "tag": "div",
            "text": {"content": "$content", "tag": "lark_md"}
          },
        ]
      }
    };

    if (url != null) {
      (str["card"]["elements"] as List).add({
        "actions": [
          {
            "tag": "button",
            "text": {"content": "更多信息", "tag": "lark_md"},
            "url": "$url",
            "type": "default",
            "value": {}
          }
        ],
        "tag": "action"
      });
    }
    this._msg = str;
  }

  @override
  Map<String, dynamic> get msg {
    return this._msg!;
  }
}
