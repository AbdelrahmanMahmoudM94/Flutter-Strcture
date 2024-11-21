import 'package:flutter/material.dart';

import '../../shared/data/local_data.dart';

class GeneralConstants {
  static ThemeMode? themeMode;
  static int? pageSize = 10;

  static bool hasFocus = false;

  static bool hasConnection = true;

  static String homeWebViewUrl =
      "https://www.swa.gov.sa/${LocalData.getLangCode() ?? "ar"}";
}
