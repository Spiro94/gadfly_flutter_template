part of '../theme.dart';

const _radiusTokens = ThemeRadiusTokens(
  zero: 0,
  small: 4,
  medium: 8,
  rounded: 400,
);

class ThemeRadiusTokens extends ThemeExtension<ThemeRadiusTokens>
    with EquatableMixin {
  const ThemeRadiusTokens({
    required this.zero,
    required this.small,
    required this.medium,
    required this.rounded,
  });

  /// No spacing
  final double zero;

  /// Default: 4
  final double small;

  /// Default: 8
  final double medium;

  /// Default: 400
  final double rounded;

  @override
  ThemeExtension<ThemeRadiusTokens> copyWith({
    double? zero,
    double? small,
    double? medium,
    double? rounded,
  }) {
    return ThemeRadiusTokens(
      zero: zero ?? this.zero,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      rounded: rounded ?? this.rounded,
    );
  }

  /// Linear interpolation of [ThemeRadiusTokens]
  @override
  ThemeRadiusTokens lerp(ThemeRadiusTokens? other, double t) {
    if (other is! ThemeRadiusTokens) return this;
    return ThemeRadiusTokens(
      zero: lerpDouble(zero, other.zero, t)!,
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      rounded: lerpDouble(rounded, other.rounded, t)!,
    );
  }

  @override
  List<Object?> get props => [zero, small, medium, rounded];
}
