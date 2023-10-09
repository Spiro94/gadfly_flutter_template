import 'package:flow_test/flow_test.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocked_app.dart';

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
    await _mockAmplitude();
    return super.init();
  }

  void _mockLogger() {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(
      (record) {
        mockedApp.events.add(
          '''${record.level.name}: [${record.loggerName}] ${record.message}''',
        );
      },
    );
  }

  Future<void> _mockAmplitude() async {
    // Track
    when(
      () => mockedApp.mocks.amplitudeRepository.track(
        event: any(named: 'event'),
        properties: any(named: 'properties'),
      ),
    ).thenAnswer((invocation) async {
      final name = invocation.namedArguments[const Symbol('event')];
      mockedApp.events.add('Track: $name');
      return;
    });

    // Page
    when(
      () => mockedApp.mocks.amplitudeRepository.page(
        event: any(named: 'event'),
        properties: any(named: 'properties'),
        popped: any(named: 'popped'),
      ),
    ).thenAnswer((invocation) async {
      final name = invocation.namedArguments[const Symbol('event')] as String;

      if (name.contains('_Routes')) {
        return;
      }

      final nameSanitized = name.replaceAll('_Route', '');
      if (invocation.namedArguments[const Symbol('popped')] as bool) {
        mockedApp.events.add('Page popped: $nameSanitized');
      } else {
        mockedApp.events.add('Page: $nameSanitized');
      }
      return;
    });
  }
}
