import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final _spacings = AppSpacings.withDefaults();

final appThemeDataLight = AppThemeData(
  theme: AppTheme(
    isDarkTheme: false,
    colors: colorsLight,
    typographies: _themeTypographies,
    spacings: _spacings,
  ),
).createThemeData(createThemeData).copyWith(
      appBarTheme: AppBarTheme(
        color: colorsLight.neutral.highest,
        centerTitle: true,
        titleTextStyle: TextStyle(color: colorsLight.neutral.none),
        iconTheme: IconThemeData(
          color: colorsLight.neutral.none,
        ),
      ),
    );

final appThemeDataDark = AppThemeData(
  theme: AppTheme(
    isDarkTheme: true,
    colors: colorsDark,
    typographies: _themeTypographies,
    spacings: _spacings,
  ),
)
    .createThemeData(
      createThemeData,
    )
    .copyWith(
      appBarTheme: AppBarTheme(
        color: colorsDark.neutral.lowest,
        centerTitle: true,
        titleTextStyle: TextStyle(color: colorsDark.neutral.all),
        iconTheme: IconThemeData(
          color: colorsDark.neutral.all,
        ),
      ),
    );

ThemeData createThemeData(ThemeData themeData, AppColors colors) {
  return themeData.copyWith(
    scaffoldBackgroundColor: colors.neutral.nearNone,
    elevatedButtonTheme: createElevatedButtonThemeData(themeData, colors),
  );
}

ElevatedButtonThemeData createElevatedButtonThemeData(
  ThemeData themeData,
  AppColors colors,
) =>
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            _spacings.large,
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: _spacings.medium,
          horizontal: _spacings.medium,
        ),
        backgroundColor: colors.primary.mid,
        foregroundColor: colors.neutral.none,
        disabledBackgroundColor: colors.neutral.low,
        elevation: 1,
        textStyle: _themeTypographies.titleMedium,
      ),
    );

const colorsLight = AppColors(
  primary: AppColorVariations(
    none: Color(0xFFFFFFFF),
    nearNone: Color(0xFFecfdf5),
    lowest: Color(0xFFd1fae5),
    lower: Color(0xFFa7f3d0),
    low: Color(0xFF6ee7b7),
    midLow: Color(0xFF34d399),
    mid: Color(0xFF10b981),
    midHigh: Color(0xFF059669),
    high: Color(0xFF047857),
    higher: Color(0xFF065f46),
    highest: Color(0xFF064e3b),
    all: Color(0xFF000000),
  ),
  secondary: AppColorVariations(
    none: Color(0xFFFFFFFF),
    nearNone: Color(0xFFfefce8),
    lowest: Color(0xFFfef9c3),
    lower: Color(0xFFfef08a),
    low: Color(0xFFfde047),
    midLow: Color(0xFFfacc15),
    mid: Color(0xFFeab308),
    midHigh: Color(0xFFca8a04),
    high: Color(0xFFa16207),
    higher: Color(0xFF854d0e),
    highest: Color(0xFF713f12),
    all: Color(0xFF000000),
  ),
  success: AppColorVariations(
    none: Color(0xFFFFFFFF),
    nearNone: Color(0xFFecfdf5),
    lowest: Color(0xFFd1fae5),
    lower: Color(0xFFa7f3d0),
    low: Color(0xFF6ee7b7),
    midLow: Color(0xFF34d399),
    mid: Color(0xFF10b981),
    midHigh: Color(0xFF059669),
    high: Color(0xFF047857),
    higher: Color(0xFF065f46),
    highest: Color(0xFF064e3b),
    all: Color(0xFF000000),
  ),
  error: AppColorVariations(
    none: Color(0xFFFFFFFF),
    nearNone: Color(0xFFfef2f2),
    lowest: Color(0xFFfee2e2),
    lower: Color(0xFFfecaca),
    low: Color(0xFFfca5a5),
    midLow: Color(0xFFf87171),
    mid: Color(0xFFef4444),
    midHigh: Color(0xffdc2626),
    high: Color(0xFFb91c1c),
    higher: Color(0xFF991b1b),
    highest: Color(0xFF7f1d1d),
    all: Color(0xFF000000),
  ),
  info: AppColorVariations(
    none: Color(0xFFFFFFFF),
    nearNone: Color(0xFFf0f9ff),
    lowest: Color(0xFFe0f2fe),
    lower: Color(0xFFbae6fd),
    low: Color(0xFF7dd3fc),
    midLow: Color(0xFF38bdf8),
    mid: Color(0xFF0ea5e9),
    midHigh: Color(0xFF0284c7),
    high: Color(0xFF0369a1),
    higher: Color(0xFF075985),
    highest: Color(0xFF0c4a6e),
    all: Color(0xFF000000),
  ),
  warning: AppColorVariations(
    none: Color(0xFFFFFFFF),
    nearNone: Color(0xFFfefce8),
    lowest: Color(0xFFfef9c3),
    lower: Color(0xFFfef08a),
    low: Color(0xFFfde047),
    midLow: Color(0xFFfacc15),
    mid: Color(0xFFeab308),
    midHigh: Color(0xFFca8a04),
    high: Color(0xFFa16207),
    higher: Color(0xFF854d0e),
    highest: Color(0xFF713f12),
    all: Color(0xFF000000),
  ),
  neutral: AppColorVariations(
    none: Color(0xFFFFFFFF),
    nearNone: Color(0xFFf8fafc),
    lowest: Color(0xFFf1f5f9),
    lower: Color(0xFFe2e8f0),
    low: Color(0xFFcbd5e1),
    midLow: Color(0xFF94a3b8),
    mid: Color(0xFF64748b),
    midHigh: Color(0xFF475569),
    high: Color(0xFF334155),
    higher: Color(0xFF1e293b),
    highest: Color(0xFF0f172a),
    all: Color(0xFF000000),
  ),
);

const colorsDark = AppColors(
  primary: AppColorVariations(
    all: Color(0xFFFFFFFF),
    highest: Color(0xFFecfdf5),
    higher: Color(0xFFd1fae5),
    high: Color(0xFFa7f3d0),
    midHigh: Color(0xFF6ee7b7),
    mid: Color(0xFF34d399),
    midLow: Color(0xFF10b981),
    low: Color(0xFF059669),
    lower: Color(0xFF047857),
    lowest: Color(0xFF065f46),
    nearNone: Color(0xFF064e3b),
    none: Color(0xFF000000),
  ),
  secondary: AppColorVariations(
    all: Color(0xFFFFFFFF),
    highest: Color(0xFFfefce8),
    higher: Color(0xFFfef9c3),
    high: Color(0xFFfef08a),
    midHigh: Color(0xFFfde047),
    mid: Color(0xFFfacc15),
    midLow: Color(0xFFeab308),
    low: Color(0xFFca8a04),
    lower: Color(0xFFa16207),
    lowest: Color(0xFF854d0e),
    nearNone: Color(0xFF713f12),
    none: Color(0xFF000000),
  ),
  success: AppColorVariations(
    all: Color(0xFFFFFFFF),
    highest: Color(0xFFecfdf5),
    higher: Color(0xFFd1fae5),
    high: Color(0xFFa7f3d0),
    midHigh: Color(0xFF6ee7b7),
    mid: Color(0xFF34d399),
    midLow: Color(0xFF10b981),
    low: Color(0xFF059669),
    lower: Color(0xFF047857),
    lowest: Color(0xFF065f46),
    nearNone: Color(0xFF064e3b),
    none: Color(0xFF000000),
  ),
  error: AppColorVariations(
    all: Color(0xFFFFFFFF),
    highest: Color(0xFFfef2f2),
    higher: Color(0xFFfee2e2),
    high: Color(0xFFfecaca),
    midHigh: Color(0xFFfca5a5),
    mid: Color(0xFFf87171),
    midLow: Color(0xFFef4444),
    low: Color(0xffdc2626),
    lower: Color(0xFFb91c1c),
    lowest: Color(0xFF991b1b),
    nearNone: Color(0xFF7f1d1d),
    none: Color(0xFF000000),
  ),
  info: AppColorVariations(
    all: Color(0xFFFFFFFF),
    highest: Color(0xFFf0f9ff),
    higher: Color(0xFFe0f2fe),
    high: Color(0xFFbae6fd),
    midHigh: Color(0xFF7dd3fc),
    mid: Color(0xFF38bdf8),
    midLow: Color(0xFF0ea5e9),
    low: Color(0xFF0284c7),
    lower: Color(0xFF0369a1),
    lowest: Color(0xFF075985),
    nearNone: Color(0xFF0c4a6e),
    none: Color(0xFF000000),
  ),
  warning: AppColorVariations(
    all: Color(0xFFFFFFFF),
    highest: Color(0xFFfefce8),
    higher: Color(0xFFfef9c3),
    high: Color(0xFFfef08a),
    midHigh: Color(0xFFfde047),
    mid: Color(0xFFfacc15),
    midLow: Color(0xFFeab308),
    low: Color(0xFFca8a04),
    lower: Color(0xFFa16207),
    lowest: Color(0xFF854d0e),
    nearNone: Color(0xFF713f12),
    none: Color(0xFF000000),
  ),
  neutral: AppColorVariations(
    all: Color(0xFFFFFFFF),
    highest: Color(0xFFf8fafc),
    higher: Color(0xFFf1f5f9),
    high: Color(0xFFe2e8f0),
    midHigh: Color(0xFFcbd5e1),
    mid: Color(0xFF94a3b8),
    midLow: Color(0xFF64748b),
    low: Color(0xFF475569),
    lower: Color(0xFF334155),
    lowest: Color(0xFF1e293b),
    nearNone: Color(0xFF0f172a),
    none: Color(0xFF000000),
  ),
);

final _fontFamily = GoogleFonts.montserrat();

final _themeTypographies = AppTypographies(
  displayLarge: _fontFamily.copyWith(
    fontSize: 57,
    height: 64 / 57,
    letterSpacing: -0.25,
  ),
  displayMedium: _fontFamily.copyWith(
    fontSize: 45,
    height: 52 / 45,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
  ),
  displaySmall: _fontFamily.copyWith(
    fontSize: 36,
    height: 44 / 36,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
  ),
  headlineLarge: _fontFamily.copyWith(
    fontSize: 32,
    height: 40 / 32,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
  ),
  headlineMedium: _fontFamily.copyWith(
    fontSize: 28,
    height: 36 / 28,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
  ),
  headlineSmall: _fontFamily.copyWith(
    fontSize: 24,
    height: 32 / 24,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
  ),
  titleLarge: _fontFamily.copyWith(
    fontSize: 22,
    height: 28 / 22,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  ),
  titleMedium: _fontFamily.copyWith(
    fontSize: 18,
    height: 24 / 18,
    letterSpacing: 0.15,
    fontWeight: FontWeight.w600,
  ),
  titleSmall: _fontFamily.copyWith(
    fontSize: 16,
    height: 20 / 16,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w600,
  ),
  bodyLarge: _fontFamily.copyWith(
    fontSize: 18,
    height: 24 / 18,
    letterSpacing: 0.5,
  ),
  bodyMedium: _fontFamily.copyWith(
    fontSize: 16,
    height: 20 / 16,
    letterSpacing: 0.24,
  ),
  bodySmall: _fontFamily.copyWith(
    fontSize: 14,
    height: 16 / 14,
    letterSpacing: 0.4,
  ),
  labelLarge: _fontFamily.copyWith(
    fontSize: 16,
    height: 20 / 16,
    letterSpacing: 0.24,
  ),
  labelMedium: _fontFamily.copyWith(
    fontSize: 14,
    height: 16 / 14,
    letterSpacing: 0.4,
  ),
  labelSmall: _fontFamily.copyWith(
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.4,
  ),
);
