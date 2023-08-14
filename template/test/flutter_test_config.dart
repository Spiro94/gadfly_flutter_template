import 'dart:async';
import 'dart:ui';

import 'package:golden_toolkit/golden_toolkit.dart';

final deviceWeb =
    Device.tabletLandscape.copyWith(name: 'web', size: const Size(1600, 900));

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  var createScreenshots = false;
  try {
    createScreenshots = const bool.fromEnvironment('createScreenshots');
  } catch (_) {
    // Do nothing
  }

  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      enableRealShadows: true,
      defaultDevices: [deviceWeb],
      skipGoldenAssertion: () => !createScreenshots,
    ),
  );
}
