import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../main.dart';
import '../../../common/constants/general_constants.dart';
import '../../../common/utility/theme.dart';
import '../../data/local_data.dart';

part 'theme_state.dart';

@injectable
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());
  // Default locale

  ThemeMode? _themeMode;
  ThemeData? _theme;

  void changeTheme(BuildContext context, ThemeMode themeMode) {
    LocalData.setIsDarkMode(themeMode == ThemeMode.dark);
    GeneralConstants.themeMode = themeMode;
    MyApp.of(context).updateState();
  }

  // Future<void> changeTheme(ThemeMode themeMode) async {
  //   if (themeMode == ThemeMode.dark) {
  //   } else {}
  // }

  getIsDarkMode() {
    final bool isDarkMode = LocalData.getIsDarkMode() ?? false;
    return isDarkMode;
  }

  getTheme() {
    final bool isDarkMode = LocalData.getIsDarkMode() ?? false;
    print("isDarkMode $isDarkMode");

    if (isDarkMode) {
      _theme = AppTheme.darkTheme;
    } else {
      _theme = AppTheme.lightTheme;
    }

    return _theme;
  }

  getThemeMode() {
    final bool isDarkMode = LocalData.getIsDarkMode() ?? false;

    if (isDarkMode) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    return _themeMode;
  }
}
