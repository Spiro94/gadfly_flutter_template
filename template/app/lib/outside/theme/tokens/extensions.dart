part of '../theme.dart';

const _tokenExtensions = ThemeTokenExtensions(
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
    required this.iconSize,
    required this.radius,
    required this.spacing,
  });

  final ThemeIconSizeTokens iconSize;
  final ThemeRadiusTokens radius;
  final ThemeSpacingTokens spacing;

  @override
  ThemeExtension<ThemeTokenExtensions> copyWith({
    ThemeIconSizeTokens? iconSize,
    ThemeRadiusTokens? radius,
    ThemeSpacingTokens? spacing,
  }) {
    return ThemeTokenExtensions(
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
      iconSize: iconSize.lerp(other.iconSize, t),
      radius: radius.lerp(other.radius, t),
      spacing: spacing.lerp(other.spacing, t),
    );
  }

  @override
  List<Object?> get props => [iconSize, radius, spacing];
}
