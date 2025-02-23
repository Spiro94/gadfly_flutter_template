import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class FTTester<M> {
  FTTester({
    required FTDescriptionsRecord<M> storiesRecord,
    required FTConfig<M> config,
    required FTMockedApp<M> mockedApp,
    required WidgetTester testerAction,
    required bool printTesterLogs,
    required int tripCount,
  })  : _storiesRecord = storiesRecord,
        _config = config,
        _mockedApp = mockedApp,
        _testerAction = testerAction,
        _arrange = FTArrange(mockedApp: mockedApp),
        _printTesterLogs = printTesterLogs,
        _tripCount = tripCount;

  final FTDescriptionsRecord<M> _storiesRecord;
  final FTConfig<M> _config;
  final FTMockedApp<M> _mockedApp;

  final WidgetTester _testerAction;
  final FTArrange<M> _arrange;

  final bool _printTesterLogs;
  final int _tripCount;

  Device get _activeDevice {
    return _config.device ?? defaultGoldenDevice;
  }

  Future<void> setUp({
    Future<void> Function(FTArrange<M> arrange)? arrangeBeforePumpApp,
    Future<void> Function(FTWarp<M> warp)? warp,
  }) async {
    await arrangeBeforePumpApp?.call(_arrange);

    await _testerAction.binding.runWithDeviceOverrides(
      _activeDevice,
      body: () async {
        await _testerAction.pumpWidget(
          await _mockedApp.appBuilder(),
        );
      },
    );

    if (warp != null) {
      await warp(
        FTWarp(
          mockedApp: _mockedApp,
          userAction: FTUserAction(
            widgetTester: _testerAction,
            userActionRecords: [], // ignoring
          ),
          testerAction: _testerAction,
        ),
      );
      _mockedApp.events.clear();
      _mockedApp.records.clear();
    }
  }

  Future<void> screenshot({
    required String description,
    void Function(FTArrange<M> arrange)? arrangeBeforeActions,
    Future<void> Function(FTAction<M> actions)? actions,
    void Function(FTArrange<M> arrange)? arrangeAfterActions,
    void Function(FTExpectations<M> expectations)? expectations,
    List<Object> expectedEvents = const [],
  }) async {
    final _screenshotRecord = FTScreenshotRecord<M>(
      description: description,
      totalTripCount: _config.mockedApps.length,
      deviceName: _activeDevice.name,
      storiesRecord: _storiesRecord,
      resolvedCounter: _mockedApp.resolvedCounter,
      config: _config,
    );

    arrangeBeforeActions?.call(_arrange);

    await _testerAction.binding.runWithDeviceOverrides(
      _activeDevice,
      body: () async {
        await actions?.call(
          FTAction(
            mockedApp: _mockedApp,
            userAction: FTUserAction(
              widgetTester: _testerAction,
              userActionRecords: _screenshotRecord.userActionRecords,
            ),
            testerAction: _testerAction,
          ),
        );
      },
    );

    arrangeAfterActions?.call(_arrange);

    await _takeScreenshot();

    expectations?.call(
      FTExpectations(
        mockedApp: _mockedApp,
        expectationRecords: _screenshotRecord.expectationRecords,
      ),
    );
    expect(_mockedApp.events, expectedEvents);

    for (final _event in _mockedApp.events) {
      _screenshotRecord.eventRecords.add(
        FTEventRecord(
          description: _event.toString(),
        ),
      );
    }

    _mockedApp.records.add(_screenshotRecord);
    _mockedApp.events.clear();

    if (_printTesterLogs) {
      // printing is intentional here
      // ignore: avoid_print
      print(_screenshotRecord.toPrint());
    }

    /// Increment screenshot counter
    _mockedApp.screenshotCounter++;
  }

  Future<void> _takeScreenshot() async {
    final screenshotPath = _storiesRecord.screenshotPath(
      resolvedCounter: _mockedApp.resolvedCounter,
      tripCount: _tripCount,
    );

    /// Take Screenshot
    await multiScreenGolden(
      _testerAction,
      screenshotPath,
      devices: [_activeDevice],
      // don't pump
      customPump: (wt) async {},
    );
  }
}
