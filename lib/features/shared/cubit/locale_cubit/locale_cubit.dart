import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../main.dart';
import '../../data/local_data.dart';

part 'locale_state.dart';

@injectable
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit()
      : super(Locale(LocalData.getLangCode() ?? "en")); // Default locale

  // Method to access the current locale without context
  Locale getCurrentLocale() {
    return _getLocal();
  }

  // Method to update the locale
  void setLocale(BuildContext context, Locale _locale) {
    LocalData.setLangCode(_locale.languageCode);
    context.setLocale(_locale);

    MyApp.of(context).updateState();
    // emit(LocaleChangedState(_locale));
  }

  void toggleLocale(BuildContext context, bool isEnglish) {
    if (isEnglish) {
      LocalData.setLangCode("en");
      context.setLocale(Locale("en", "US"));
      MyApp.of(context).updateState();
      emit(const Locale("en", "US")); // English locale
    } else {
      LocalData.setLangCode("ar");
      context.setLocale(Locale("ar", "KW"));
      MyApp.of(context).updateState();
      emit(const Locale("ar", "KW")); // Arabic locale
    }
  }

  Locale _getLocal() {
    Locale locale;
    String? LangCode = LocalData.getLangCode() ?? "ar";
    print("getCurrentLocale LangCode $LangCode");

    if (LangCode == "en") {
      locale = const Locale('en', 'US');
    } else {
      locale = const Locale('ar', 'KW');
    }

    return locale;
  }
}
