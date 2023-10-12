// ignore_for_file: public_member_api_docs
import 'package:flow_test/src/mocked_app.dart';
import 'package:flow_test/src/user_action.dart';
import 'package:flutter_test/flutter_test.dart';

class FTAction<M> {
  FTAction({
    required FTMockedApp<M> mockedApp,
    required this.userAction,
    required this.testerAction,
  }) : extras = mockedApp.extras;

  final Map<String, dynamic> extras;
  final FTUserAction userAction;
  final WidgetTester testerAction;

  /// If you are doing appium automation testing, then you should consider only
  /// using these finders in your tests, so that they can match Appium
  ///
  /// https://github.com/appium-userland/appium-flutter-driver
  final appiumFinders = AppiumFinders();
}

class AppiumFinders {
  final ancesror = find.ancestor;
  final bySemanticsLabel = find.bySemanticsLabel;
  final byTooltip = find.byTooltip;
  final byType = find.byType;
  final byKey = find.byKey;
  final text = find.text;
  final descendant = find.descendant;
}
