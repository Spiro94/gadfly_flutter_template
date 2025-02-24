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
}
