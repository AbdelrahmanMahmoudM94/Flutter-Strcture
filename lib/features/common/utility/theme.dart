import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'palette.dart';

class AppTheme {
  AppTheme._();
  // *****************
  //AppBar
  // *****************
  static const AppBarTheme appBarTHemeLight = AppBarTheme(
    elevation: 0.0,
  );

  static AppBarTheme appBarTHemeDark = AppBarTheme(
    elevation: 0.0,
    // surfaceTintColor: Colors.white,
    foregroundColor: Palette.white,
    // color: Palette.backgroundColorDark,
    backgroundColor: Palette.backgroundColorDark,
    iconTheme: IconThemeData(color: Palette.white),
    titleTextStyle: TextStyle(
      color: Palette.white,
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
    ),
  );

  // *****************
  // static colors
  // *****************

  static const Color _lightPrimaryColor = Colors.white;

  static final Color _lightPrimaryVariantColor = Colors.blueGrey.shade800;

  static final Color _lightOnPrimaryColor = Colors.blueGrey.shade200;
  static const Color _lightTextColorPrimary = Palette.black;
  static const Color _darkTextColorPrimary = Palette.white;
  static const Color _darkPrimaryColor =
      Palette.backgroundColorDark; //Colors.blueGrey.shade900;
  static const Color _darkPrimaryVariantColor = Colors.black;

  static final Color _darkOnPrimaryColor = Colors.blueGrey.shade300;
  static final Color _appbarColorDark = Colors.blueGrey.shade800;
  static const Color _iconColor = Colors.white;
  static const Color _accentColor = Color.fromRGBO(74, 217, 217, 1);

  static const TextStyle _lightHeadingText = TextStyle(
    color: _lightTextColorPrimary,
    fontFamily: "OpenSans",
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle _lightBodyText = TextStyle(
    color: _lightTextColorPrimary,
    fontFamily: "OpenSans",
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: _lightHeadingText,
    bodyLarge: _lightBodyText,
  );

  // *****************
  //Buttons
  // *****************
  static final ElevatedButtonThemeData elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
    ),
  );

  static final OutlinedButtonThemeData outlinedButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Palette.primaryColor,
      padding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      side: const BorderSide(color: Palette.primaryColor),
    ),
  );

  //
  // *****************
  // Text Style - dark
  // *****************
  static final TextStyle _darkThemeHeadingTextStyle =
      _lightHeadingText.copyWith(color: _darkTextColorPrimary);

  static final TextStyle _darkThemeBodyeTextStyle =
      _lightBodyText.copyWith(color: _darkTextColorPrimary);

  static final TextTheme _darkTextTheme = TextTheme(
    displayLarge: _darkThemeHeadingTextStyle,
    bodyLarge: _darkThemeBodyeTextStyle,
  );

  // *****************
  // Theme light/dark
  // *****************

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    elevatedButtonTheme: elevatedButtonTheme,
    scaffoldBackgroundColor: Palette.white,
    brightness: Brightness.light,
    appBarTheme: appBarTHemeLight,
    inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Palette.black,
          fontSize: 16.sp,
        ),
        fillColor: Palette.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Palette.grey_C6C6C6)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Palette.black)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Palette.darkRed)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Palette.darkRed)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Palette.grey_C6C6C6))),
    primaryColor: Palette.primaryColor,
    secondaryHeaderColor: Palette.black,
    fontFamily: "OpenSans",

    cardColor: Palette.white,
    primaryColorDark: Palette.lightBlack,
    shadowColor: Colors.grey,
    disabledColor: Colors.grey,
    colorScheme: const ColorScheme.light(
      primary: Palette.primaryColor,
    ),
    //colorSchemeSeed: null,
    // dialogBackgroundColor: Colors.white,
    // dividerColor: Colors.grey,
    // focusColor: Colors.blue,
    // highlightColor: Colors.blue[200],
    // hintColor: Colors.grey,
    // hoverColor: Colors.grey[200],
    // indicatorColor: Colors.blue,
    // primaryColorLight: Colors.blue[200],
    // primarySwatch: Colors.blue,
    // splashColor: Colors.blue[200],
    // unselectedWidgetColor: Colors.grey,
    // fontFamilyFallback: ['Arial', 'Helvetica'],
    // iconTheme: const IconThemeData(color: Colors.black),
    // primaryIconTheme: const IconThemeData(color: Colors.blue),
    // primaryTextTheme: const TextTheme(),
    // actionIconTheme: const ActionIconThemeData(),
    // badgeTheme: const BadgeThemeData(),
    // bannerTheme: const MaterialBannerThemeData(),
    // bottomAppBarTheme: const BottomAppBarTheme(),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Palette.grey_F4F6F7,
      unselectedItemColor: Palette.black,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: Palette.primaryColor,
      type: BottomNavigationBarType.fixed,
      unselectedLabelStyle: TextStyle(
          fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: "OpenSans"),
      selectedLabelStyle: TextStyle(
          fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: "OpenSans"),
    ),
    // bottomSheetTheme: const BottomSheetThemeData(),
    // buttonBarTheme: const ButtonBarThemeData(),
    // buttonTheme: const ButtonThemeData(),
    // cardTheme: const CardTheme(),
    // checkboxTheme: const CheckboxThemeData(),
    // chipTheme: const ChipThemeData(),
    // dataTableTheme: const DataTableThemeData(),
    // datePickerTheme: const DatePickerThemeData(),
    // dialogTheme: const DialogTheme(),
    // dividerTheme: const DividerThemeData(),
    // drawerTheme: const DrawerThemeData(),
    // dropdownMenuTheme: const DropdownMenuThemeData(),
    // elevatedButtonTheme: const ElevatedButtonThemeData(),
    // expansionTileTheme: const ExpansionTileThemeData(),
    // filledButtonTheme: const FilledButtonThemeData(),
    // floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    // iconButtonTheme: const IconButtonThemeData(),
    // listTileTheme: const ListTileThemeData(),
    // menuBarTheme: const MenuBarThemeData(),
    // menuButtonTheme: const MenuButtonThemeData(),
    // menuTheme: const MenuThemeData(),
    // navigationBarTheme: const NavigationBarThemeData(),
    // navigationDrawerTheme: const NavigationDrawerThemeData(),
    // navigationRailTheme: const NavigationRailThemeData(),
    // outlinedButtonTheme: const OutlinedButtonThemeData(),
    // popupMenuTheme: const PopupMenuThemeData(),
    // progressIndicatorTheme: const ProgressIndicatorThemeData(),
    // radioTheme: const RadioThemeData(),
    // searchBarTheme: const SearchBarThemeData(),
    // searchViewTheme: const SearchViewThemeData(),
    // segmentedButtonTheme: const SegmentedButtonThemeData(),
    // sliderTheme: const SliderThemeData(),
    // snackBarTheme: const SnackBarThemeData(),
    // switchTheme: const SwitchThemeData(),
    // tabBarTheme: const TabBarTheme(),
    // textButtonTheme: const TextButtonThemeData(),
    // textSelectionTheme: const TextSelectionThemeData(),
    // timePickerTheme: const TimePickerThemeData(),
    // toggleButtonsTheme: const ToggleButtonsThemeData(),
    // tooltipTheme: const TooltipThemeData(),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: Palette.black,
    brightness: Brightness.dark,
    appBarTheme: appBarTHemeDark,
    primaryColor: Palette.white,
    secondaryHeaderColor: Palette.white,
    inputDecorationTheme: InputDecorationTheme(
        fillColor: Palette.semiLightBlack,
        filled: true,
        hintStyle: TextStyle(
          //   color: Palette.white,
          fontSize: 16.sp,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Palette.darkRed)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Palette.darkRed)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        )),
    fontFamily: "OpenSans",
    cardColor: Palette.semiLightBlack,
    colorScheme: const ColorScheme.dark(
      primary: Palette.primaryColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Palette.semiLightBlack,
      unselectedItemColor: Palette.white,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: Palette.primaryColor,
      type: BottomNavigationBarType.fixed,
      unselectedLabelStyle: TextStyle(
          fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: "OpenSans"),
      selectedLabelStyle: TextStyle(
          fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: "OpenSans"),
    ),
  );

  // *****************
  // Icon
  // *****************

  // *****************
  // Text Style - light
  // *****************

  static Color? inDarkMode(BuildContext context, {Color? light, Color? dark}) {
    if (Theme.of(context).brightness == Brightness.dark) return dark;
    return light;
  }

  static bool isDarkMode(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return true;
    }
    return false;
  }
}
