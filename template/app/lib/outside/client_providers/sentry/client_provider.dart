import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_logging/sentry_logging.dart';

import '../base.dart';
import 'client_provider_configuration.dart';

class Sentry_ClientProvider extends ClientProvider_Base {
  Sentry_ClientProvider({
    required this.initialSessionId,
    required this.configuration,
  });

  final String initialSessionId;
  final Sentry_ClientProvider_Configuration? configuration;

  @override
  Future<void> init() async {
    if (configuration == null) return;

    await Sentry.init((options) {
      options
        ..dsn = configuration!.dsn
        ..environment = configuration!.environment
        ..tracesSampleRate = configuration!.tracesSampleRate
        ..addIntegration(LoggingIntegration());
    });
    await setSessionId(sessionId: initialSessionId);
  }

  Future<void> setSessionId({required String sessionId}) async {
    if (configuration == null) return;

    await Sentry.configureScope((scope) {
      scope.setTag('sessionId', sessionId);
    });
  }

  Future<void> setUserId({required String? userId}) async {
    if (configuration == null) return;

    await Sentry.configureScope((scope) {
      scope.setUser(userId != null ? SentryUser(id: userId) : null);
    });
  }
}
