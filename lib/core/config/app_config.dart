import 'dart:io';
import 'package:flutter/foundation.dart';

enum Environment { dev, prod }

class AppConfig {
  AppConfig._();

  static Environment environment = Environment.dev;

  static String get baseUrl {
    if (environment == Environment.prod) {
      return 'https://api.zunosocial.com/v1';
    }

    // Development URL
    if (kIsWeb) {
      return 'http://localhost:3000/v1';
    } else if (Platform.isAndroid) {
      // 10.0.2.2 is the special IP to access your computer's localhost from Android Emulator
      return 'http://10.0.2.2:3000/v1';
    } else {
      return 'http://localhost:3000/v1';
    }
  }

  static const String appName = 'ZUNO Social AI';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
