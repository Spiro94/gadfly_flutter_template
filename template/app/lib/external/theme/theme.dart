import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

part 'tokens/icon_size.dart';
part 'tokens/extensions.dart';
part 'tokens/radius.dart';
part 'tokens/spacing.dart';

final materialThemeData_light = ThemeData(
  useMaterial3: true,
  extensions: const [_tokenExtensions],
  scaffoldBackgroundColor: foruiThemeData_light.scaffoldStyle.backgroundColor,
);

final materialThemeData_dark = materialThemeData_light.copyWith(
  scaffoldBackgroundColor: foruiThemeData_dark.scaffoldStyle.backgroundColor,
);

final foruiThemeData_light = FThemes.zinc.light.copyWith(
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

final foruiThemeData_dark = FThemes.zinc.dark.copyWith(
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
