import 'package:flow_test/flow_test.dart';
import 'package:logging/logging.dart';
import 'package:recase/recase.dart';

import 'mocks/effects/mixpanel_effect.dart';
import 'mocks/mocked_app.dart';

TestBlocObserver createTestBlocObserver(FTMockedApp<MocksContainer> mockedApp) {
  return TestBlocObserver(
    mockedApp: mockedApp,
  );
}

class TestBlocObserver extends FTBlocObserver<MocksContainer> {
  TestBlocObserver({
    required super.mockedApp,
  });

  @override
  Future<void> init() async {
    _mockLogger();
    return super.init();
  }

  void _mockLogger() {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(
      (record) {
        if (record.loggerName ==
            Effect_Mixpanel_Fake().runtimeType.toString().snakeCase) {
          mockedApp.events.add(
            '''[ANALYTIC] ${record.message}''',
          );
          return;
        }

        mockedApp.events.add(
          '''[${record.loggerName}] ${record.level}: ${record.message}''',
        );
      },
    );
  }
}
