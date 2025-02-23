import 'dart:async';
import 'dart:ui';

import 'package:golden_toolkit/golden_toolkit.dart';

/// In your test directory, you will need to create a file called
/// `flutter_test_config.dart` and define a function called `testExecutable`:
///
/// ```dart
/// import 'package:flow_test/flow_test.dart';
///
/// const testExecutable = flowTestExecutable;
/// ```

final defaultGoldenDevice =
    Device.tabletLandscape.copyWith(name: 'web', size: const Size(1600, 900));

/// See https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html.
Future<void> flowTestExecutable(FutureOr<void> Function() testMain) async {
  // From the CLI, you can use `dart-define createScreenshots=true` to
  // create screenshots when updating golden images.
  var createScreenshots = false;
  try {
    createScreenshots = const bool.fromEnvironment('createScreenshots');
  } catch (_) {}

  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      enableRealShadows: true,
      defaultDevices: [defaultGoldenDevice],
      skipGoldenAssertion: () => !createScreenshots,
      deviceFileNameFactory: (name, device) {
        return 'screenshots/$name.${device.name}.png';
      },
    ),
  );
}
