// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:recase/recase.dart';

import '../flutter_test_config.dart';
import 'mocked_app.dart';
import 'test_bloc_observer.dart';

typedef OtherActions = Future<void> Function();
typedef PumpApp = Future<void> Function({OtherActions? otherActions});
typedef Setup = Future<void> Function(
  WidgetTester tester,
  MocksContainer mocks,
  PumpApp pumpApp,
);
typedef Arrange = void Function(MocksContainer mocks);
typedef Act = Future<void> Function(WidgetTester tester);
typedef Assert = void Function();

typedef ActionTester = Future<void> Function(
  String actionDescription, {
  Arrange? arrange,
  Act? act,
  Assert? assertion,
  List<Object>? expectedEvents,
  bool expectedEventsInOrder,
});

typedef FlowTester = Future<void> Function(
  ActionTester testAction,
);

@isTest
void testFlow(
  String description, {
  required Setup setup,
  required FlowTester test,
}) {
  /// Counter that keeps track of how many screenshots there are
  var screenshotCounter = 0;

  /// Note: This is a method inside a method.
  /// Returns a file name based on the current [screenshotCounter].
  String _getScreenshotFileName(String name) {
    screenshotCounter++;
    final counterString = '$screenshotCounter'.padLeft(2, '0');
    final sanitizedDirectoryName = description.snakeCase;
    final sanitizedName = name.snakeCase;

    return '$sanitizedDirectoryName/$counterString.$sanitizedName';
  }

  testGoldens(
    description,
    (widgetTester) async {
      final app = MockedApp(MocksContainer());

      final testBlocObserver =
          TestBlocObserver(amplitudeRepository: app.mocks.amplitudeRepository);
      Bloc.observer = testBlocObserver;
      await testBlocObserver.init();

      await widgetTester.binding.runWithDeviceOverrides(
        deviceWeb,
        body: () async {
          await setup(
            widgetTester,
            app.mocks,
            ({OtherActions? otherActions}) async {
              await mockNetworkImages(() async {
                await widgetTester.pumpWidget(await app.mockedAppBuilder());
                await widgetTester.pumpAndSettle();

                await otherActions?.call();

                testBlocObserver.getAndResetObservedEvents();
              });
            },
          );
        },
      );

      await test(
        (
          actionDescription, {
          act,
          arrange,
          assertion,
          expectedEvents = const [],
          expectedEventsInOrder = true,
        }) async {
          arrange?.call(app.mocks);

          await widgetTester.binding.runWithDeviceOverrides(
            deviceWeb,
            body: () async {
              await mockNetworkImages(() async {
                await act?.call(widgetTester);
              });
            },
          );

          await multiScreenGolden(
            widgetTester,
            _getScreenshotFileName(actionDescription),
            devices: [deviceWeb],
            customPump: (p0) async {},
          );

          assertion?.call();

          final actualEvents = testBlocObserver.getAndResetObservedEvents();
          final _expectedEvents = expectedEvents ?? [];

          if (expectedEventsInOrder) {
            if (!actualEvents.equals(_expectedEvents)) {
              debugPrint(
                '\nExpected Events: \n\n${actualEvents.join(",\n")},\n',
              );
            }
            expect(
              actualEvents,
              _expectedEvents,
              reason:
                  '''expected events should contain all actual events in the same order''',
            );
          } else {
            final containsInAnyOrder =
                actualEvents.every(_expectedEvents.contains);
            if (!containsInAnyOrder) {
              debugPrint(
                '\nExpected Events: \n\n${actualEvents.join(",\n")},\n',
              );
            } else {
              debugPrint(
                '''\nWARNING: using expectedEventsInOrder = false. Should only be used for flaky event ordering. Description: [$actionDescription]\n''',
              );
            }

            expect(
              containsInAnyOrder,
              isTrue,
              reason:
                  '''expected events should contain all actual events in any order''',
            );
          }
        },
      );
    },
  );
}
