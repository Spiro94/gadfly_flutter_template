import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

part 'tokens/icon_size.dart';
part 'tokens/extensions.dart';
part 'tokens/radius.dart';
part 'tokens/spacing.dart';

class ExternalTheme {
  ExternalTheme({
    required this.materialThemeData,
    required this.foruiThemeData,
  });

  final ThemeData materialThemeData;
  final FThemeData foruiThemeData;
}

class ExternalThemes {
  static ExternalTheme get lightTheme => ExternalTheme(
        materialThemeData: _materialThemeData_light,
        foruiThemeData: _foruiThemeData_light,
      );
  static ExternalTheme get darkTheme => ExternalTheme(
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
  textFieldStyle: FThemes.zinc.light.textFieldStyle.copyWith(
    errorStyle: FThemes.zinc.light.textFieldStyle.errorStyle.copyWith(
      labelTextStyle:
          FThemes.zinc.light.textFieldStyle.enabledStyle.labelTextStyle,
      errorTextStyle:
          FThemes.zinc.light.textFieldStyle.errorStyle.errorTextStyle.copyWith(
        fontWeight: FontWeight.normal,
      ),
    ),
  ),
);

final _foruiThemeData_dark = FThemes.zinc.dark.copyWith(
  textFieldStyle: FThemes.zinc.dark.textFieldStyle.copyWith(
    errorStyle: FThemes.zinc.dark.textFieldStyle.errorStyle.copyWith(
      labelTextStyle:
          FThemes.zinc.dark.textFieldStyle.enabledStyle.labelTextStyle,
      errorTextStyle:
          FThemes.zinc.dark.textFieldStyle.errorStyle.errorTextStyle.copyWith(
        fontWeight: FontWeight.normal,
      ),
    ),
  ),
);
