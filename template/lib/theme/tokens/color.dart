// coverage:ignore-file

part of '../theme.dart';

const _brightness = Brightness.light;

final _primaryPalette = _toTonalPalette(const Color(0xFF48853C).value);
final _secondaryPalette =
    _toTonalPalette(const Color.fromARGB(255, 181, 48, 202).value);
final _tertiaryPalette =
    _toTonalPalette(const Color.fromARGB(255, 64, 186, 194).value);
final _successPalette =
    _toTonalPalette(const Color.fromARGB(255, 93, 239, 76).value);
final _warningPalette =
    _toTonalPalette(const Color.fromARGB(255, 213, 144, 53).value);
final _errorPalette = TonalPalette.of(25, 84);
final _neutralPalette = _toTonalPalette(const Color(0xFF767872).value);
final _neutralVariantPalette = _toTonalPalette(const Color(0xFF73796E).value);

final _colors = <int>[
  ..._primaryPalette.asList,
  ..._secondaryPalette.asList,
  ..._tertiaryPalette.asList,
  ..._neutralPalette.asList,
  ..._neutralVariantPalette.asList,
].toList();

final _corePalette = CorePalette.fromList(_colors);

final _colorScheme = CorePaletteToColorScheme(_corePalette)
    .toColorScheme(brightness: _brightness)
    .copyWith(background: Colors.white);

TonalPalette _toTonalPalette(int value) {
  final color = Hct.fromInt(value);
  return TonalPalette.of(color.hue, color.chroma);
}

final _colorTokens = ThemeColorTokens(
  primary: ThemeColorVariations(
    none: Color(_primaryPalette.get(100)),
    nearestNone: Color(_primaryPalette.get(99)),
    nearNone: Color(_primaryPalette.get(95)),
    lowest: Color(_primaryPalette.get(90)),
    lower: Color(_primaryPalette.get(80)),
    low: Color(_primaryPalette.get(70)),
    midLow: Color(_primaryPalette.get(60)),
    mid: Color(_primaryPalette.get(50)),
    midHigh: Color(_primaryPalette.get(40)),
    high: Color(_primaryPalette.get(30)),
    higher: Color(_primaryPalette.get(20)),
    highest: Color(_primaryPalette.get(10)),
    all: Color(_primaryPalette.get(0)),
  ),
  secondary: ThemeColorVariations(
    none: Color(_secondaryPalette.get(100)),
    nearestNone: Color(_secondaryPalette.get(99)),
    nearNone: Color(_secondaryPalette.get(95)),
    lowest: Color(_secondaryPalette.get(90)),
    lower: Color(_secondaryPalette.get(80)),
    low: Color(_secondaryPalette.get(70)),
    midLow: Color(_secondaryPalette.get(60)),
    mid: Color(_secondaryPalette.get(50)),
    midHigh: Color(_secondaryPalette.get(40)),
    high: Color(_secondaryPalette.get(30)),
    higher: Color(_secondaryPalette.get(20)),
    highest: Color(_secondaryPalette.get(10)),
    all: Color(_secondaryPalette.get(0)),
  ),
  success: ThemeColorVariations(
    none: Color(_successPalette.get(100)),
    nearestNone: Color(_successPalette.get(99)),
    nearNone: Color(_successPalette.get(95)),
    lowest: Color(_successPalette.get(90)),
    lower: Color(_successPalette.get(80)),
    low: Color(_successPalette.get(70)),
    midLow: Color(_successPalette.get(60)),
    mid: Color(_successPalette.get(50)),
    midHigh: Color(_successPalette.get(40)),
    high: Color(_successPalette.get(30)),
    higher: Color(_successPalette.get(20)),
    highest: Color(_successPalette.get(10)),
    all: Color(_successPalette.get(0)),
  ),
  error: ThemeColorVariations(
    none: Color(_errorPalette.get(100)),
    nearestNone: Color(_errorPalette.get(99)),
    nearNone: Color(_errorPalette.get(95)),
    lowest: Color(_errorPalette.get(90)),
    lower: Color(_errorPalette.get(80)),
    low: Color(_errorPalette.get(70)),
    midLow: Color(_errorPalette.get(60)),
    mid: Color(_errorPalette.get(50)),
    midHigh: Color(_errorPalette.get(40)),
    high: Color(_errorPalette.get(30)),
    higher: Color(_errorPalette.get(20)),
    highest: Color(_errorPalette.get(10)),
    all: Color(_errorPalette.get(0)),
  ),
  info: ThemeColorVariations(
    none: Color(_tertiaryPalette.get(100)),
    nearestNone: Color(_tertiaryPalette.get(99)),
    nearNone: Color(_tertiaryPalette.get(95)),
    lowest: Color(_tertiaryPalette.get(90)),
    lower: Color(_tertiaryPalette.get(80)),
    low: Color(_tertiaryPalette.get(70)),
    midLow: Color(_tertiaryPalette.get(60)),
    mid: Color(_tertiaryPalette.get(50)),
    midHigh: Color(_tertiaryPalette.get(40)),
    high: Color(_tertiaryPalette.get(30)),
    higher: Color(_tertiaryPalette.get(20)),
    highest: Color(_tertiaryPalette.get(10)),
    all: Color(_tertiaryPalette.get(0)),
  ),
  warning: ThemeColorVariations(
    none: Color(_warningPalette.get(100)),
    nearestNone: Color(_warningPalette.get(99)),
    nearNone: Color(_warningPalette.get(95)),
    lowest: Color(_warningPalette.get(90)),
    lower: Color(_warningPalette.get(80)),
    low: Color(_warningPalette.get(70)),
    midLow: Color(_warningPalette.get(60)),
    mid: Color(_warningPalette.get(50)),
    midHigh: Color(_warningPalette.get(40)),
    high: Color(_warningPalette.get(30)),
    higher: Color(_warningPalette.get(20)),
    highest: Color(_warningPalette.get(10)),
    all: Color(_warningPalette.get(0)),
  ),
  neutral: ThemeColorVariations(
    none: Color(_neutralPalette.get(100)),
    nearestNone: Color(_neutralPalette.get(99)),
    nearNone: Color(_neutralPalette.get(95)),
    lowest: Color(_neutralPalette.get(90)),
    lower: Color(_neutralPalette.get(80)),
    low: Color(_neutralPalette.get(70)),
    midLow: Color(_neutralPalette.get(60)),
    mid: Color(_neutralPalette.get(50)),
    midHigh: Color(_neutralPalette.get(40)),
    high: Color(_neutralPalette.get(30)),
    higher: Color(_neutralPalette.get(20)),
    highest: Color(_neutralPalette.get(10)),
    all: Color(_neutralPalette.get(0)),
  ),
  neutralVariant: ThemeColorVariations(
    none: Color(_neutralVariantPalette.get(100)),
    nearestNone: Color(_neutralVariantPalette.get(99)),
    nearNone: Color(_neutralVariantPalette.get(95)),
    lowest: Color(_neutralVariantPalette.get(90)),
    lower: Color(_neutralVariantPalette.get(80)),
    low: Color(_neutralVariantPalette.get(70)),
    midLow: Color(_neutralVariantPalette.get(60)),
    mid: Color(_neutralVariantPalette.get(50)),
    midHigh: Color(_neutralVariantPalette.get(40)),
    high: Color(_neutralVariantPalette.get(30)),
    higher: Color(_neutralVariantPalette.get(20)),
    highest: Color(_neutralVariantPalette.get(10)),
    all: Color(_neutralVariantPalette.get(0)),
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
    required this.neutralVariant,
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
  final ThemeColorVariations neutral;

  /// This color set is used for texture and is considered to have neutral
  /// semantic meaning
  final ThemeColorVariations neutralVariant;

  @override
  ThemeExtension<ThemeColorTokens> copyWith({
    ThemeColorVariations? primary,
    ThemeColorVariations? secondary,
    ThemeColorVariations? success,
    ThemeColorVariations? error,
    ThemeColorVariations? info,
    ThemeColorVariations? warning,
    ThemeColorVariations? neutral,
    ThemeColorVariations? neutralVariant,
  }) {
    return ThemeColorTokens(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      success: success ?? this.success,
      error: error ?? this.error,
      info: info ?? this.info,
      warning: warning ?? this.warning,
      neutral: neutral ?? this.neutral,
      neutralVariant: neutralVariant ?? this.neutralVariant,
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
      neutralVariant: neutralVariant.lerp(other.neutralVariant, t),
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
        neutralVariant,
      ];
}

/// The color variations range from none to all. These names are meant to be
/// agnostic to whether you are using light or dark mode.
class ThemeColorVariations extends Equatable {
  const ThemeColorVariations({
    required this.none,
    required this.nearestNone,
    required this.nearNone,
    required this.lowest,
    required this.lower,
    required this.low,
    required this.midLow,
    required this.mid,
    required this.midHigh,
    required this.high,
    required this.higher,
    required this.highest,
    required this.all,
  });

  /// 100
  final Color none;

  /// 99
  final Color nearestNone;

  /// 95
  final Color nearNone;

  /// 90
  final Color lowest;

  /// 80
  final Color lower;

  /// 70
  final Color low;

  /// 60
  final Color midLow;

  /// 50
  final Color mid;

  /// 40
  final Color midHigh;

  /// 30
  final Color high;

  /// 20
  final Color higher;

  /// 10
  final Color highest;

  /// 0
  final Color all;

  /// linear interpolation of [ThemeColorVariations]
  ThemeColorVariations lerp(ThemeColorVariations? other, double t) {
    if (other is! ThemeColorVariations) return this;
    return ThemeColorVariations(
      none: Color.lerp(none, other.none, t)!,
      nearestNone: Color.lerp(nearestNone, other.nearestNone, t)!,
      nearNone: Color.lerp(nearNone, other.nearNone, t)!,
      lowest: Color.lerp(lowest, other.lowest, t)!,
      lower: Color.lerp(lower, other.lower, t)!,
      low: Color.lerp(low, other.low, t)!,
      midLow: Color.lerp(midLow, other.midLow, t)!,
      mid: Color.lerp(mid, other.mid, t)!,
      midHigh: Color.lerp(midHigh, other.midHigh, t)!,
      high: Color.lerp(high, other.high, t)!,
      higher: Color.lerp(higher, other.higher, t)!,
      highest: Color.lerp(highest, other.highest, t)!,
      all: Color.lerp(all, other.all, t)!,
    );
  }

  @override
  List<Object?> get props => [
        none,
        nearestNone,
        nearNone,
        lowest,
        lower,
        low,
        midLow,
        mid,
        midHigh,
        high,
        higher,
        highest,
        all,
      ];
}
