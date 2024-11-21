import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

import '../../di/dependency_init.dart';

class LocalData {
  static final SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  static void clearAllData() {
    sharedPreferences.clear();
    // CustomMainRouter.push(const LoginRoute());
  }

   

  static bool? getIsDarkMode() {
    return sharedPreferences.getBool("isDarkMode");
  }

  static String? getLangCode() {
    return sharedPreferences.getString("LangCode");
  }

   
  
  static Future<void>? setIsDarkMode(bool isDarkMode) async {
    await sharedPreferences.setBool("isDarkMode", isDarkMode);
  }

  static Future<void>? setLangCode(String langCode) async {
    await sharedPreferences.setString("LangCode", langCode);
  }

   
 
  bool? getBool(String key) {
    return sharedPreferences.getBool(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return sharedPreferences.setBool(key, value);
  }

  getKeys() {
    return sharedPreferences.getKeys();
  }
}
