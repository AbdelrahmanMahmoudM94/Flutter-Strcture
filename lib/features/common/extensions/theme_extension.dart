import "package:flutter/material.dart";

/// A collection of convenience methods to access theme from a [BuildContext]
extension ThemeExtension on BuildContext {
  /// Returns the [ThemeData] from the current [Theme]
  ThemeData get theme => Theme.of(this);

  /// Returns the [TextTheme] from the current [Theme]
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Returns the [ColorScheme] from the current [Theme]
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// True if the current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// True if the current theme is light
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;
}
