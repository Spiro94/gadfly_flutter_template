// coverage:ignore-file

part of '../theme.dart';

const _breakpointTokens = ThemeBreakpointTokens(
  xSmall: 576,
  small: 768,
  medium: 992,
  large: 1200,
  xLarge: 1400,
);

class ThemeBreakpointTokens extends ThemeExtension<ThemeBreakpointTokens>
    with EquatableMixin {
  const ThemeBreakpointTokens({
    required this.xSmall,
    required this.small,
    required this.medium,
    required this.large,
    required this.xLarge,
  });

  /// Default: 576
  final double xSmall;

  /// Default: 768
  final double small;

  /// Default: 992
  final double medium;

  /// Default: 1200
  final double large;

  /// Default: 1400
  final double xLarge;

  @override
  ThemeExtension<ThemeBreakpointTokens> copyWith({
    double? xSmall,
    double? small,
    double? medium,
    double? large,
    double? xLarge,
  }) {
    return ThemeBreakpointTokens(
      xSmall: xSmall ?? this.xSmall,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      xLarge: xLarge ?? this.xLarge,
    );
  }

  /// Linear interpolation of [ThemeBreakpointTokens]
  @override
  ThemeBreakpointTokens lerp(ThemeBreakpointTokens? other, double t) {
    if (other is! ThemeBreakpointTokens) return this;
    return ThemeBreakpointTokens(
      xSmall: lerpDouble(xSmall, other.xSmall, t)!,
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      large: lerpDouble(large, other.large, t)!,
      xLarge: lerpDouble(xLarge, other.xLarge, t)!,
    );
  }

  @override
  List<Object?> get props => [
        xSmall,
        small,
        medium,
        large,
        xLarge,
      ];
}
