import 'package:flow_test/src/mocked_app.dart';
import 'package:flow_test/src/user_action.dart';
import 'package:flutter_test/flutter_test.dart';

class FTWarp<M> {
  FTWarp({
    required FTMockedApp<M> mockedApp,
    required this.userAction,
    required this.testerAction,
  })  : extras = mockedApp.extras,
        mocks = mockedApp.mocks;

  final Map<String, dynamic> extras;
  final FTUserAction userAction;
  final WidgetTester testerAction;
  final M mocks;
}
