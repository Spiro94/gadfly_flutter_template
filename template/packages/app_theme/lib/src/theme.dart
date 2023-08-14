import 'package:app_theme/src/colors/colors.dart';
import 'package:app_theme/src/spacings.dart';
import 'package:app_theme/src/typographies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// {@template appTheme.themeExtension}
/// This attached `theme` to [BuildContext] to make it easy to access your
/// [AppTheme].
/// {@endtemplate}
extension AppThemeBuildContext on BuildContext {
  /// The name of the method to access the [AppTheme] from [BuildContext]
  AppTheme get theme => Theme.of(this).extension<AppTheme>()!;
}

/// {@template appTheme.theme}
/// Your [AppTheme] which includes colors, typographies, and spacings.
/// {@endtemplate}
class AppTheme extends ThemeExtension<AppTheme> with EquatableMixin {
  /// {@macro appTheme.theme}
  AppTheme({
    required this.isDarkTheme,
    required this.colors,
    required this.typographies,
    required this.spacings,
  });

  /// Whether or not the theme is intended for dark mode
  final bool isDarkTheme;

  /// The colors for the theme
  final AppColors colors;

  /// The typographies for the theme
  final AppTypographies typographies;

  /// The spacings for the theme
  final AppSpacings spacings;

  @override
  ThemeExtension<AppTheme> copyWith({
    bool? isDarkTheme,
    AppColors? colors,
    AppTypographies? typographies,
    AppSpacings? spacings,
  }) {
    return AppTheme(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      colors: colors ?? this.colors,
      typographies: typographies ?? this.typographies,
      spacings: spacings ?? this.spacings,
    );
  }

  @override
  AppTheme lerp(ThemeExtension<AppTheme>? other, double t) {
    if (other is! AppTheme) return this;
    return AppTheme(
      isDarkTheme: other.isDarkTheme,
      colors: colors.lerp(other.colors, t),
      typographies: typographies.lerp(other.typographies, t),
      spacings: spacings.lerp(other.spacings, t),
    );
  }

  @override
  List<Object?> get props => [
        isDarkTheme,
        colors,
        typographies,
        spacings,
      ];
}
