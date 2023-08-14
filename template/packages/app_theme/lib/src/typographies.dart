import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// {@template appTheme.typographies}
/// The typographies for the theme
/// {@endtemplate}
class AppTypographies extends Equatable {
  /// {@macro appTheme.typographies}
  const AppTypographies({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  /// h1
  final TextStyle displayLarge;

  /// h2
  final TextStyle displayMedium;

  /// h3
  final TextStyle displaySmall;

  /// h4
  final TextStyle headlineLarge;

  /// h5
  final TextStyle headlineMedium;

  /// h6
  final TextStyle headlineSmall;

  /// title large
  final TextStyle titleLarge;

  /// title medium
  final TextStyle titleMedium;

  /// title small
  final TextStyle titleSmall;

  /// body large
  final TextStyle bodyLarge;

  /// body medium
  final TextStyle bodyMedium;

  /// body small
  final TextStyle bodySmall;

  /// label large
  final TextStyle labelLarge;

  /// label medium
  final TextStyle labelMedium;

  /// label small
  final TextStyle labelSmall;

  /// Linear interpolation for [AppTypographies]
  AppTypographies lerp(
    AppTypographies? other,
    double t,
  ) {
    if (other is! AppTypographies) return this;
    return AppTypographies(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t)!,
      displaySmall: TextStyle.lerp(displaySmall, other.displaySmall, t)!,
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t)!,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t)!,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
    );
  }

  @override
  List<Object?> get props => [
        displayLarge,
        displayMedium,
        displaySmall,
        headlineLarge,
        headlineMedium,
        headlineSmall,
        titleLarge,
        titleMedium,
        titleSmall,
        bodyLarge,
        bodyMedium,
        bodySmall,
        labelLarge,
        labelMedium,
        labelSmall,
      ];
}
