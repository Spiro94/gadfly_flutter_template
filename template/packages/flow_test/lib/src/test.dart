import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:meta/meta.dart';

@isTest
void flowTest<M>(
  String testDescription, {
  required List<FTDescription> descriptions,
  required FTConfig<M> config,
  required Future<void> Function(FTTester<M> tester) test,
  bool skip = false,
}) {
  // From the CLI, you can use `--dart-define createScreenshots=true` to create
  // screenshots when you update golens.
  var createScreenshots = false;
  try {
    createScreenshots = const bool.fromEnvironment('createScreenshots');
  } catch (_) {}

  // From the CLI, you can use `--dart-define silenceLogs=true` to prevent any
  // logs from printing
  var silenceLogs = false;
  try {
    silenceLogs = const bool.fromEnvironment('silenceLogs');
  } catch (_) {}

  testGoldens(
    // summary.shortDescription,
    testDescription,
    skip: skip,
    (tester) async {
      // Ensure everything is initialized and ready to be tested.
      TestWidgetsFlutterBinding.ensureInitialized();

      // We will take a test 'trip' for every mockedApp in our list. We will do
      // certain things only on the first trip, so we need to keep track of
      // which trip we are on.
      var tripCount = 0;

      await Future.forEach(config.mockedApps, (FTMockedApp<M> mockedApp) async {
        // Keep track if this is the first trip or not.
        final isFirstTrip = tripCount == 0;

        // Only print if a) printTesterLogs is true, b) is the first trip, and
        // c) logs are not silenced
        //
        // ignore: lines_longer_than_80_chars
        final _printTesterLogs =
            config.printTesterLogs && isFirstTrip && !silenceLogs;

        // Create the test's bloc observer
        if (config.createBlocObserver != null) {
          final blocObserver = config.createBlocObserver!.call(mockedApp);
          Bloc.observer = blocObserver;
          await blocObserver.init();
        }

        // The [_descriptionsRecord] is used by our gallery to let us know the
        // big picture of our test.
        final _descriptionsRecord = FTDescriptionsRecord<M>(
          descriptions: descriptions,
          config: config,
        );

        if (_printTesterLogs) {
          // printing is intentional here
          // ignore: avoid_print
          print(_descriptionsRecord.toPrint());
        }

        //
        // Testing sequence
        //

        final flowTester = FTTester<M>(
          storiesRecord: _descriptionsRecord,
          config: config,
          mockedApp: mockedApp,
          testerAction: tester,
          printTesterLogs: _printTesterLogs,
          tripCount: tripCount,
        );

        await test(flowTester);

        // If a) golden test are being updated, b) this is our first trip and c)
        // we are creating screenshot images, then we will create a markdown
        // file.
        if (autoUpdateGoldenFiles && isFirstTrip && createScreenshots) {
          await tester.runAsync(
            () async {
              // Create markdown file
              //
              final markdownFile = await File(
                'test/gallery/${_descriptionsRecord.markdownFilePath}.md',
              ).create(recursive: true);
              final markdownSink = markdownFile.openWrite();

              markdownSink.write(_descriptionsRecord.toMarkdown());

              for (final record in mockedApp.records) {
                markdownSink.write(record.toMarkdown());
              }
              await markdownSink.close();
            },
          );
        }

        // Increment trip count
        tripCount++;
      });
    },
  );
}
