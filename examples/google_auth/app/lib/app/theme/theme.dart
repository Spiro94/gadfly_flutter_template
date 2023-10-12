import 'dart:ui';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:material_color_utilities/material_color_utilities.dart';

part 'color_scheme.dart';

part 'spacings.dart';
part 'typography.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _colorScheme,
  extensions: const [_spacings],
  typography: _typography,
);

extension AppSpacingsBuildContext on BuildContext {
  AppSpacings get spacings => Theme.of(this).extension<AppSpacings>()!;
}
