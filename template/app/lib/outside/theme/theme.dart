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

final _materialThemeData_light = ThemeData(
  useMaterial3: true,
  extensions: const [_tokenExtensions],
  scaffoldBackgroundColor: _foruiThemeData_light.scaffoldStyle.backgroundColor,
);

final _materialThemeData_dark = _materialThemeData_light.copyWith(
  scaffoldBackgroundColor: _foruiThemeData_dark.scaffoldStyle.backgroundColor,
);

final _foruiThemeData_light = FThemes.zinc.light.copyWith(
  textFieldStyle: FThemes.zinc.light.textFieldStyle.copyWith(),
);

final _foruiThemeData_dark = FThemes.zinc.dark.copyWith(
  textFieldStyle: FThemes.zinc.dark.textFieldStyle.copyWith(),
);
