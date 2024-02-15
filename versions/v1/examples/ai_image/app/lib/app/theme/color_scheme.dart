part of 'theme.dart';

const _brightness = Brightness.light;

final _colors = <int>[
  ..._toTonalPalette(const Color(0xFF48853C).value).asList,
  ..._toTonalPalette(const Color(0xFF6C7B65).value).asList,
  ..._toTonalPalette(const Color(0xFF517F82).value).asList,
  ..._toTonalPalette(const Color(0xFF767872).value).asList,
  ..._toTonalPalette(const Color(0xFF73796E).value).asList,
].toList();

final corePalette = CorePalette.fromList(_colors);

final _colorScheme = CorePaletteToColorScheme(corePalette)
    .toColorScheme(brightness: _brightness)
    .copyWith(background: Colors.white);

TonalPalette _toTonalPalette(int value) {
  final color = Hct.fromInt(value);
  return TonalPalette.of(color.hue, color.chroma);
}
