part of '../theme.dart';

const _spacingTokens = ThemeSpacingTokens(
  zero: 0,
  xxxxSmall: 1,
  xxxSmall: 2,
  xxSmall: 4,
  xSmall: 8,
  small: 12,
  medium: 16,
  large: 24,
  xLarge: 32,
  xxLarge: 40,
  xxxLarge: 48,
  xxxxLarge: 64,
);

class ThemeSpacingTokens extends ThemeExtension<ThemeSpacingTokens>
    with EquatableMixin {
  const ThemeSpacingTokens({
    required this.zero,
    required this.xxxxSmall,
    required this.xxxSmall,
    required this.xxSmall,
    required this.xSmall,
    required this.small,
    required this.medium,
    required this.large,
    required this.xLarge,
    required this.xxLarge,
    required this.xxxLarge,
    required this.xxxxLarge,
  });

  /// No spacing
  final double zero;

  /// Default: 1
  final double xxxxSmall;

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

  /// Default: 64
  final double xxxxLarge;

  @override
  ThemeExtension<ThemeSpacingTokens> copyWith({
    double? zero,
    double? xxxxSmall,
    double? xxxSmall,
    double? xxSmall,
    double? xSmall,
    double? small,
    double? medium,
    double? large,
    double? xLarge,
    double? xxLarge,
    double? xxxLarge,
    double? xxxxLarge,
  }) {
    return ThemeSpacingTokens(
      zero: zero ?? this.zero,
      xxxxSmall: xxxxSmall ?? this.xxxxSmall,
      xxxSmall: xxxSmall ?? this.xxxSmall,
      xxSmall: xxSmall ?? this.xxSmall,
      xSmall: xSmall ?? this.xSmall,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      xLarge: xLarge ?? this.xLarge,
      xxLarge: xxLarge ?? this.xxLarge,
      xxxLarge: xxxLarge ?? this.xxxLarge,
      xxxxLarge: xxxxLarge ?? this.xxxxLarge,
    );
  }

  /// Linear interpolation of [ThemeSpacingTokens]
  @override
  ThemeSpacingTokens lerp(ThemeSpacingTokens? other, double t) {
    if (other is! ThemeSpacingTokens) return this;
    return ThemeSpacingTokens(
      zero: lerpDouble(zero, other.zero, t)!,
      xxxxSmall: lerpDouble(xxxxSmall, other.xxxxSmall, t)!,
      xxxSmall: lerpDouble(xxxSmall, other.xxxSmall, t)!,
      xxSmall: lerpDouble(xxSmall, other.xxSmall, t)!,
      xSmall: lerpDouble(xSmall, other.xSmall, t)!,
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      large: lerpDouble(large, other.large, t)!,
      xLarge: lerpDouble(xLarge, other.xLarge, t)!,
      xxLarge: lerpDouble(xxLarge, other.xxLarge, t)!,
      xxxLarge: lerpDouble(xxxLarge, other.xxxLarge, t)!,
      xxxxLarge: lerpDouble(xxxxLarge, other.xxxxLarge, t)!,
    );
  }

  @override
  List<Object?> get props => [
    zero,
    xxxxSmall,
    xxxSmall,
    xxSmall,
    xSmall,
    small,
    medium,
    large,
    xLarge,
    xxLarge,
    xxxLarge,
    xxxxLarge,
  ];
}
