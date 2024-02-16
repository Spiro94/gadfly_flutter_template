// coverage:ignore-file

part of '../theme.dart';

final _tokenExtensions = ThemeTokenExtensions(
  color: _colorTokens,
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
    required this.color,
    required this.iconSize,
    required this.radius,
    required this.spacing,
  });

  final ThemeColorTokens color;
  final ThemeIconSizeTokens iconSize;
  final ThemeRadiusTokens radius;
  final ThemeSpacingTokens spacing;

  @override
  ThemeExtension<ThemeTokenExtensions> copyWith({
    ThemeColorTokens? color,
    ThemeIconSizeTokens? iconSize,
    ThemeRadiusTokens? radius,
    ThemeSpacingTokens? spacing,
  }) {
    return ThemeTokenExtensions(
      color: color ?? this.color,
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
      color: color.lerp(other.color, t),
      iconSize: iconSize.lerp(other.iconSize, t),
      radius: radius.lerp(other.radius, t),
      spacing: spacing.lerp(other.spacing, t),
    );
  }

  @override
  List<Object?> get props => [
        color,
        iconSize,
        radius,
        spacing,
      ];
}
