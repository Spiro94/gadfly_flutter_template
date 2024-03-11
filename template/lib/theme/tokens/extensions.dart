// coverage:ignore-file

part of '../theme.dart';

final _tokenExtensions = ThemeTokenExtensions(
  breakpoint: _breakpointTokens,
  color: _colorTokens,
  colorRaw: _colorRawTokens,
  iconSize: _iconSizeTokens,
  radius: _radiusTokens,
  spacing: _spacingTokens,
);

extension ThemeTokensBuildContext on BuildContext {
  ThemeTokenExtensions get tokens =>
      Theme.of(this).extension<ThemeTokenExtensions>()!;
}

class ThemeTokenExtensions extends ThemeExtension<ThemeTokenExtensions>
    with EquatableMixin {
  const ThemeTokenExtensions({
    required this.breakpoint,
    required this.color,
    required this.colorRaw,
    required this.iconSize,
    required this.radius,
    required this.spacing,
  });

  final ThemeBreakpointTokens breakpoint;
  final ThemeColorTokens color;
  final ThemeColorRawTokens colorRaw;
  final ThemeIconSizeTokens iconSize;
  final ThemeRadiusTokens radius;
  final ThemeSpacingTokens spacing;

  @override
  ThemeExtension<ThemeTokenExtensions> copyWith({
    ThemeBreakpointTokens? breakpoint,
    ThemeColorTokens? color,
    ThemeColorRawTokens? colorRaw,
    ThemeIconSizeTokens? iconSize,
    ThemeRadiusTokens? radius,
    ThemeSpacingTokens? spacing,
  }) {
    return ThemeTokenExtensions(
      breakpoint: breakpoint ?? this.breakpoint,
      color: color ?? this.color,
      colorRaw: colorRaw ?? this.colorRaw,
      iconSize: iconSize ?? this.iconSize,
      radius: radius ?? this.radius,
      spacing: spacing ?? this.spacing,
    );
  }

  @override
  ThemeExtension<ThemeTokenExtensions> lerp(
    covariant ThemeExtension<ThemeTokenExtensions>? other,
    double t,
  ) {
    if (other is! ThemeTokenExtensions) return this;
    return ThemeTokenExtensions(
      breakpoint: breakpoint.lerp(other.breakpoint, t),
      color: color.lerp(other.color, t),
      colorRaw: colorRaw.lerp(other.colorRaw, t),
      iconSize: iconSize.lerp(other.iconSize, t),
      radius: radius.lerp(other.radius, t),
      spacing: spacing.lerp(other.spacing, t),
    );
  }

  @override
  List<Object?> get props => [
        breakpoint,
        color,
        colorRaw,
        iconSize,
        radius,
        spacing,
      ];
}
