// ignore_for_file: non_constant_identifier_names

// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:cron/cron.dart';
import 'package:retry/retry.dart';

// Project imports:
import 'package:feishu_bot/feishu_bot.dart';

void main(List<String> args) {
  runZonedGuarded(() {
    _main(args);
  }, (e, s) {
    log.e('Fatal error occurred', error: e, stackTrace: s);
  });
}

Future<void> _main(List<String> args) async {
  String city = Platform.environment["CITY"] ?? "";
  String amap_key = Platform.environment["AMAP_KEY"] ?? "";
  String fs_url = Platform.environment["FS_URL"] ?? "";
  String? fs_sign = Platform.environment["FS_SIGN"];

  if (city.isEmpty || amap_key.isEmpty || fs_url.isEmpty) {
    log.e(
        "ERROR: Could not get required variables, please check if the Environment variables are set correctly");
    exit(1);
  }

  Adcode adcode = await retry(
    () async {
      return await Adcode.getAdcode(amap_key, city);
    },
    onRetry: (e) {
      log.e('Could not get adcode, retrying...', error: e);
    },
    maxAttempts: 5,
  );
  Service service = Service(FeishuBot(fs_url, fs_sign));

  log.i("Started successfully at ${DateTime.now().toString()}");

  final cron = Cron();
  // Weather Push
  cron.schedule(Schedule.parse("0 0 9,12,15,18,21 * * *"), () async {
    await retry(
      () async {
        await service.sendWeatherInfo(
          cityName: adcode.name,
          adcode: adcode.adcode,
          amap_key: amap_key,
        );
      },
      onRetry: (e) {
        log.e('Could not send weather information, retrying...');
      },
      maxAttempts: 5,
    );
  });
}
