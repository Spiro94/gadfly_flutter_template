import 'dart:ui';

import 'package:equatable/equatable.dart';

/// {@template appTheme.spacings}
/// The standardizes spacings to be used throughout the app. The intent is to be
/// an abstraction on top of explicit pixels to make changing spacing easier to
/// refactor in the future.
/// {@endtemplate}
class AppSpacings extends Equatable {
  /// {@macro appTheme.spacings}
  const AppSpacings({
    required this.none,
    required this.xxxSmall,
    required this.xxSmall,
    required this.xSmall,
    required this.small,
    required this.medium,
    required this.large,
    required this.xLarge,
    required this.xxLarge,
    required this.xxxLarge,
  });

  /// This provides opt-in defaults to set the spacings
  static AppSpacings withDefaults() {
    return const AppSpacings(
      none: 0,
      xxxSmall: 2,
      xxSmall: 4,
      xSmall: 8,
      small: 12,
      medium: 16,
      large: 24,
      xLarge: 32,
      xxLarge: 40,
      xxxLarge: 48,
    );
  }

  /// No spacing
  final double none;

  /// Default: 2
  final double xxxSmall;

  /// Default: 4
  final double xxSmall;

  /// Default: 8
  final double xSmall;

  /// Default: 12
  final double small;

  /// Default: 16
  final double medium;

  /// Default: 24
  final double large;

  /// Default: 32
  final double xLarge;

  /// Default: 40
  final double xxLarge;

  /// Default: 48
  final double xxxLarge;

  /// Linear interpolation of [AppSpacings]
  AppSpacings lerp(AppSpacings? other, double t) {
    if (other is! AppSpacings) return this;
    return AppSpacings(
      none: lerpDouble(none, other.none, t)!,
      xxxSmall: lerpDouble(xxxSmall, other.xxxSmall, t)!,
      xxSmall: lerpDouble(xxSmall, other.xxSmall, t)!,
      xSmall: lerpDouble(xSmall, other.xSmall, t)!,
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      large: lerpDouble(large, other.large, t)!,
      xLarge: lerpDouble(xLarge, other.xLarge, t)!,
      xxLarge: lerpDouble(xxLarge, other.xxLarge, t)!,
      xxxLarge: lerpDouble(xxxLarge, other.xxxLarge, t)!,
    );
  }

  @override
  List<Object?> get props => [
        none,
        xxxSmall,
        xxSmall,
        xSmall,
        small,
        medium,
        large,
        xLarge,
        xxLarge,
        xxxLarge,
      ];
}
