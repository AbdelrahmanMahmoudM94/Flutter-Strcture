import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class Log {
  static const MethodChannel perform = MethodChannel("x_log");

  static Logger logger = Logger();

  static d(String msg, {tag = 'X-LOG'}) {
    logger.d(msg);
  }

  static w(String msg, {tag = 'X-LOG'}) {
    logger.w(msg);
  }

  static i(String msg, {tag = 'X-LOG'}) {
    logger.i(msg);
  }

  static e(String msg, {tag = 'X-LOG'}) {
    logger.e(msg);
  }

  static json(String msg, {tag = 'X-LOG'}) {
    try {
      logger.wtf(msg);
    } catch (e) {
      d(msg);
    }
  }
}
