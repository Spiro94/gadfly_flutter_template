// coverage:ignore-file

part of '../theme.dart';

final _colorTokens = ThemeColorTokens(
  primary: ThemeColorVariations(
    color: Color(_primaryPalette.get(40)),
    onColor: Color(_primaryPalette.get(100)),
    container: Color(_primaryPalette.get(90)),
    onContainer: Color(_primaryPalette.get(10)),
    inverse: Color(_primaryPalette.get(80)),
  ),
  secondary: ThemeColorVariations(
    color: Color(_secondaryPalette.get(40)),
    onColor: Color(_secondaryPalette.get(100)),
    container: Color(_secondaryPalette.get(90)),
    onContainer: Color(_secondaryPalette.get(10)),
    inverse: Color(_secondaryPalette.get(80)),
  ),
  success: ThemeColorVariations(
    color: Color(_successPalette.get(40)),
    onColor: Color(_successPalette.get(100)),
    container: Color(_successPalette.get(90)),
    onContainer: Color(_successPalette.get(10)),
    inverse: Color(_successPalette.get(80)),
  ),
  error: ThemeColorVariations(
    color: Color(_errorPalette.get(40)),
    onColor: Color(_errorPalette.get(100)),
    container: Color(_errorPalette.get(90)),
    onContainer: Color(_errorPalette.get(10)),
    inverse: Color(_errorPalette.get(80)),
  ),
  info: ThemeColorVariations(
    color: Color(_tertiaryPalette.get(40)),
    onColor: Color(_tertiaryPalette.get(100)),
    container: Color(_tertiaryPalette.get(90)),
    onContainer: Color(_tertiaryPalette.get(10)),
    inverse: Color(_tertiaryPalette.get(80)),
  ),
  warning: ThemeColorVariations(
    color: Color(_warningPalette.get(40)),
    onColor: Color(_warningPalette.get(100)),
    container: Color(_warningPalette.get(90)),
    onContainer: Color(_warningPalette.get(10)),
    inverse: Color(_warningPalette.get(80)),
  ),
  neutral: ThemeColorNeutral(
    background: Color(_neutralPalette.get(100)),
    onBackground: Color(_neutralPalette.get(10)),
    surface: Color(_neutralPalette.get(99)),
    onSurface: Color(_neutralPalette.get(10)),
    surfaceVariant: Color(_neutralVariantPalette.get(90)),
    onSurfaceVariant: Color(_neutralVariantPalette.get(30)),
    outline: Color(_neutralVariantPalette.get(50)),
    outlineVariant: Color(_neutralVariantPalette.get(80)),
    shadow: Color(_neutralPalette.get(0)),
    scrim: Color(_neutralPalette.get(0)),
    inverseSurface: Color(_neutralPalette.get(20)),
    onInverseSurface: Color(_neutralPalette.get(80)),
  ),
);

/// The complete set of [ThemeColorVariations].
class ThemeColorTokens extends ThemeExtension<ThemeColorTokens>
    with EquatableMixin {
  const ThemeColorTokens({
    required this.primary,
    required this.secondary,
    required this.success,
    required this.error,
    required this.info,
    required this.warning,
    required this.neutral,
  });

  /// This color set is the primary accent
  final ThemeColorVariations primary;

  /// This color set is the secondary accent
  final ThemeColorVariations secondary;

  /// This color set is used to indicate a success
  final ThemeColorVariations success;

  /// This color set is used to indicate an error
  final ThemeColorVariations error;

  /// This color set is used to indicate information
  final ThemeColorVariations info;

  /// This color set is used to warnings
  final ThemeColorVariations warning;

  /// This color set is used for texture and is considered to have neutral
  /// semantic meaning
  final ThemeColorNeutral neutral;

  @override
  ThemeExtension<ThemeColorTokens> copyWith({
    ThemeColorVariations? primary,
    ThemeColorVariations? secondary,
    ThemeColorVariations? success,
    ThemeColorVariations? error,
    ThemeColorVariations? info,
    ThemeColorVariations? warning,
    ThemeColorNeutral? neutral,
  }) {
    return ThemeColorTokens(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      success: success ?? this.success,
      error: error ?? this.error,
      info: info ?? this.info,
      warning: warning ?? this.warning,
      neutral: neutral ?? this.neutral,
    );
  }

  /// Linear interpolation of [ThemeColorTokens]
  @override
  ThemeColorTokens lerp(ThemeColorTokens? other, double t) {
    if (other is! ThemeColorTokens) return this;
    return ThemeColorTokens(
      primary: primary.lerp(other.primary, t),
      secondary: secondary.lerp(other.secondary, t),
      success: success.lerp(other.success, t),
      error: error.lerp(other.error, t),
      info: info.lerp(other.info, t),
      warning: warning.lerp(other.warning, t),
      neutral: neutral.lerp(other.neutral, t),
    );
  }

  @override
  List<Object?> get props => [
        primary,
        secondary,
        success,
        error,
        info,
        warning,
        neutral,
      ];
}

/// The color variations range from none to all. These names are meant to be
/// agnostic to whether you are using light or dark mode.
class ThemeColorVariations extends Equatable {
  const ThemeColorVariations({
    required this.color,
    required this.onColor,
    required this.container,
    required this.onContainer,
    required this.inverse,
  });

  /// 40
  final Color color;

  /// 100
  final Color onColor;

  /// 90
  final Color container;

  /// 10
  final Color onContainer;

  /// 80
  final Color inverse;

  /// linear interpolation of [ThemeColorVariations]
  ThemeColorVariations lerp(ThemeColorVariations? other, double t) {
    if (other is! ThemeColorVariations) return this;
    return ThemeColorVariations(
      color: Color.lerp(color, other.color, t)!,
      onColor: Color.lerp(onColor, other.onColor, t)!,
      container: Color.lerp(container, other.container, t)!,
      onContainer: Color.lerp(onContainer, other.onContainer, t)!,
      inverse: Color.lerp(inverse, other.inverse, t)!,
    );
  }

  @override
  List<Object?> get props => [
        color,
        onColor,
        container,
        onContainer,
        inverse,
      ];
}

class ThemeColorNeutral extends Equatable {
  const ThemeColorNeutral({
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.onInverseSurface,
  });

  // neutral 100
  final Color background;
  // neutral 10
  final Color onBackground;
  // neutral 99
  final Color surface;
  // neutral 10
  final Color onSurface;
  // neutral variant 90
  final Color surfaceVariant;
  // neutral variant 30
  final Color onSurfaceVariant;
  // neutral variant 50
  final Color outline;
  // neutral variant 80
  final Color outlineVariant;
  // neutral 0
  final Color shadow;
  // neutral 0
  final Color scrim;
  // neutral 20
  final Color inverseSurface;
  // neutral 80
  final Color onInverseSurface;

  /// linear interpolation of [ThemeColorNeutral]
  ThemeColorNeutral lerp(ThemeColorNeutral? other, double t) {
    if (other is! ThemeColorNeutral) return this;
    return ThemeColorNeutral(
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      onSurfaceVariant:
          Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      inverseSurface: Color.lerp(inverseSurface, other.inverseSurface, t)!,
      onInverseSurface:
          Color.lerp(onInverseSurface, other.onInverseSurface, t)!,
    );
  }

  @override
  List<Object?> get props => [
        background,
        onBackground,
        surface,
        onSurface,
        surfaceVariant,
        onSurfaceVariant,
        outline,
        outlineVariant,
        shadow,
        scrim,
        inverseSurface,
        onInverseSurface,
      ];
}
