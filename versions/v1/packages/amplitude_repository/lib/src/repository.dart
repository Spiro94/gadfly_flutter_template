import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_repository/src/configuration.dart';
import 'package:logging/logging.dart';

/// {@template amplitudeRepository.repository}
/// A repository to interact with Amplitude, an analytics service
/// {@endtemplate}
class AmplitudeRepository {
  /// {@macro amplitudeRepository.repository}
  AmplitudeRepository({
    required this.configuration,
  });

  /// The configuration for this repository
  final AmplitudeRepositoryConfiguration configuration;

  /// A reference to Amplitude once it has been initialized
  Amplitude? amplitude;

  /// Anytime a [track] or [page] analytic event is fired, it will also send a
  /// [Logger] event that is namespaced as `amplitude`
  final log = Logger('amplitude');

  /// An initialization function for Amplitude
  Future<void> init({
    Map<String, String?> deviceInfo = const {},
  }) async {
    if (configuration.sendEvents) {
      // Set local instance of Amplitude to global instance
      amplitude = Amplitude.getInstance();

      // Follow Coppa rules
      try {
        await amplitude?.enableCoppaControl();
        log.finest('Coppa Control enabled');
      } catch (_) {
        log.warning('Failed: Coppa Control enabled');
      }

      // Initialize Amplitude
      try {
        await amplitude?.init(configuration.apiKey);
        log.finest('Amplitude initialized');
      } catch (_) {
        log.warning('Failed: Amplitude initialized');
      }

      // Track user sessions
      try {
        await amplitude?.trackingSessionEvents(true);
        log.finest('Tracking session events');
      } catch (_) {
        log.warning('Failed: Tracking session events');
      }

      // Setup user properties based on certain device info, but don't use
      // anything that doesn't follow Coppa
      try {
        await amplitude?.setUserProperties(deviceInfo);
        log.finest('Set user properties');
      } catch (_) {
        log.warning('Failed: Set user properties');
      }
    }
  }

  /// Sending an analytic event that you want to track
  Future<void> track({
    required String event,
    Map<String, dynamic>? properties,
  }) async {
    log.info(event);
    if (configuration.sendEvents) {
      try {
        await amplitude?.logEvent(event, eventProperties: properties);
      } catch (_) {
        log.warning('Failed: Track event: $event');
      }
    }
  }

  /// Sending an analytic event for the current page of the application
  Future<void> page({
    required String event,
    required bool popped,
    Map<String, dynamic>? properties,
  }) async {
    log.info(event);
    if (configuration.sendEvents) {
      if (popped) {
        try {
          await amplitude?.logEvent(
            'Page popped: $event',
            eventProperties: properties,
          );
        } catch (_) {
          log.warning('Failed: Track event: Page popped $event');
        }
      } else {
        try {
          await amplitude?.logEvent(
            'Page: $event',
            eventProperties: properties,
          );
        } catch (_) {
          log.warning('Failed: Track event: Page $event');
        }
      }
    }
  }
}
