import 'dart:ui';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:material_color_utilities/material_color_utilities.dart';

part 'tokens/color.dart';
part 'tokens/icon_size.dart';
part 'tokens/extensions.dart';
part 'tokens/radius.dart';
part 'tokens/spacing.dart';
part 'typography.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _colorScheme,
  extensions: [_tokenExtensions],
  typography: _typography,
);
