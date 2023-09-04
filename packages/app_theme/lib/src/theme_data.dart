import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

/// {@template appTheme.themeData}
/// A class to hold a [AppTheme] and to be able to create a [ThemeData] which is
/// usable by [MaterialApp].
/// {@endtemplate}
class AppThemeData {
  /// {@macro appTheme.themeData}
  AppThemeData({
    required this.theme,
  });

  /// The [AppTheme] of the application
  final AppTheme theme;

  /// You may want to modify [ThemeData] to your liking based on [AppTheme]. You
  /// may also want the modifications to be the same for light and dark mode,
  /// with the exception that the [AppColors] are different. This callback
  /// allows you to define the [ThemeData] modifications once, and then pass in
  /// the [AppColors] explicitly to not have to redefine the modifications twice
  /// for light and dark mode.
  ThemeData createThemeData(
    ThemeData Function(ThemeData themeData, AppColors colors) createFunc,
  ) =>
      createFunc(themeData, theme.colors);

  /// The [ThemeData] that is usable by [MaterialApp]
  ThemeData get themeData {
    return ThemeData(
      brightness: theme.isDarkTheme ? Brightness.dark : Brightness.light,
      textTheme: TextTheme(
        displayLarge: theme.typographies.displayLarge,
        displayMedium: theme.typographies.displayLarge,
        displaySmall: theme.typographies.displaySmall,
        headlineLarge: theme.typographies.headlineLarge,
        headlineMedium: theme.typographies.headlineMedium,
        headlineSmall: theme.typographies.headlineSmall,
        titleLarge: theme.typographies.titleLarge,
        titleMedium: theme.typographies.titleMedium,
        titleSmall: theme.typographies.titleSmall,
        bodyLarge: theme.typographies.bodyLarge,
        bodyMedium: theme.typographies.bodyMedium,
        bodySmall: theme.typographies.bodySmall,
        labelLarge: theme.typographies.labelLarge,
        labelMedium: theme.typographies.labelMedium,
        labelSmall: theme.typographies.labelSmall,
      ),
      extensions: [
        theme,
      ],
    );
  }
}
