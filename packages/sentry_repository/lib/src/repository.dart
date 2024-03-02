import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_logging/sentry_logging.dart';
import 'package:sentry_repository/sentry_repository.dart';

/// {@template sentryRepository.repository}
/// A repository that wraps [Sentry](https://pub.dev/packages/sentry_flutter)
/// {@endtemplate}
class SentryRepository {
  /// {@macro sentryRepository.repository}
  SentryRepository({
    required this.configuration,
    required this.appRunner,
  });

  /// {@macro sentryRepository.configuration}
  final SentryRepositoryConfiguration configuration;

  /// The function that is run to start the app
  final AppRunner appRunner;

  /// Initializes Sentry with device information.
  Future<void> init() async {
    // initializae sentry and the application
    await Sentry.init(
      (options) {
        options
          ..dsn = configuration.sentryDSN
          ..environment = configuration.sentryEnvironment
          ..tracesSampleRate = 1.0
          ..addIntegration(LoggingIntegration());
      },
      appRunner: appRunner,
    );
  }

  /// Sets the sessionId.
  static void setSessionId(String sessionId) {
    Sentry.configureScope((scope) {
      scope.setTag('sessionId', sessionId);
    });
  }

  /// Set the device information
  static Future<void> setDeviceInfo({
    required Map<String, String?> deviceInfo,
    required bool isIOS,
  }) async {
    late SentryDevice sentryDevice;
    late SentryOperatingSystem sentryOs;

    if (isIOS) {
      sentryDevice = SentryDevice(
        name: deviceInfo['name'],
        model: deviceInfo['model'],
        simulator: deviceInfo['isPhysicalDevice'] != 'true',
      );

      sentryOs = SentryOperatingSystem(
        name: deviceInfo['systemName'],
        version: deviceInfo['systemVersion'],
      );
    } else {
      sentryDevice = SentryDevice(
        name: deviceInfo['product'],
        arch: deviceInfo['hardware'],
        brand: deviceInfo['brand'],
        manufacturer: deviceInfo['manufacturer'],
        model: deviceInfo['model'],
        simulator: deviceInfo['isPhysicalDevice'] != 'true',
      );
      sentryOs = SentryOperatingSystem(
        name: deviceInfo['versionCodename'],
        build: deviceInfo['versionBaseOS'],
        kernelVersion: deviceInfo['versionSdkInt'],
        version: deviceInfo['versionRelease'],
      );
    }

    Sentry.configureScope((scope) {
      // Configure Sentry Context
      // https://docs.sentry.io/platforms/flutter/enriching-events/context/
      scope
        ..setContexts(SentryDevice.type, sentryDevice)
        ..setContexts(SentryOperatingSystem.type, sentryOs);

      // Configure Sentry Tags
      // https://docs.sentry.io/platforms/flutter/enriching-events/tags/
      deviceInfo.forEach((key, value) {
        scope.setTag(key, value ?? '');
      });
    });
  }
}
