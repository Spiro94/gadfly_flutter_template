part of '../theme.dart';

const _iconSizeTokens = ThemeIconSizeTokens(
  xSmall: 12,
  small: 16,
  medium: 24,
  large: 36,
  xLarge: 48,
);

class ThemeIconSizeTokens extends ThemeExtension<ThemeIconSizeTokens>
    with EquatableMixin {
  const ThemeIconSizeTokens({
    required this.xSmall,
    required this.small,
    required this.medium,
    required this.large,
    required this.xLarge,
  });

  /// Default: 12
  final double xSmall;

  /// Default: 16
  final double small;

  /// Default: 24
  final double medium;

  /// Default: 36
  final double large;

  /// Default 48
  final double xLarge;

  @override
  ThemeExtension<ThemeIconSizeTokens> copyWith({
    double? xSmall,
    double? small,
    double? medium,
    double? large,
    double? xLarge,
  }) {
    return ThemeIconSizeTokens(
      xSmall: xSmall ?? this.xSmall,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      xLarge: xLarge ?? this.xLarge,
    );
  }

  /// Linear interpolation of [ThemeIconSizeTokens]
  @override
  ThemeIconSizeTokens lerp(ThemeIconSizeTokens? other, double t) {
    if (other is! ThemeIconSizeTokens) return this;
    return ThemeIconSizeTokens(
      xSmall: lerpDouble(xSmall, other.xSmall, t)!,
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      large: lerpDouble(large, other.large, t)!,
      xLarge: lerpDouble(xLarge, other.xLarge, t)!,
    );
  }

  @override
  List<Object?> get props => [xSmall, small, medium, large, xLarge];
}
