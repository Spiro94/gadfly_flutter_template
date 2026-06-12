import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

part 'tokens/icon_size.dart';
part 'tokens/extensions.dart';
part 'tokens/radius.dart';
part 'tokens/spacing.dart';

class OutsideTheme {
  OutsideTheme({required this.materialThemeData, required this.foruiThemeData});

  final ThemeData materialThemeData;
  final FThemeData foruiThemeData;
}

class OutsideThemes {
  static OutsideTheme get lightTheme => OutsideTheme(
    materialThemeData: _materialThemeData_light,
    foruiThemeData: _foruiThemeData_light,
  );
  static OutsideTheme get darkTheme => OutsideTheme(
    materialThemeData: _materialThemeData_dark,
    foruiThemeData: _foruiThemeData_dark,
  );
}

final _foruiThemeData_light = FThemes.zinc.light.desktop;

final _foruiThemeData_dark = FThemes.zinc.dark.desktop;

final _materialThemeData_light = _foruiThemeData_light
    .toApproximateMaterialTheme()
    .copyWith(extensions: const [_tokenExtensions]);

final _materialThemeData_dark = _foruiThemeData_dark
    .toApproximateMaterialTheme()
    .copyWith(extensions: const [_tokenExtensions]);
