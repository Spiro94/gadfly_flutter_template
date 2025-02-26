import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_logging/sentry_logging.dart';

import '../../util/abstracts/base_provider.dart';
import 'configuration.dart';

class SentryClientProvider extends OutsideUtilAbstract_BaseProvider {
  SentryClientProvider({
    required this.initialSessionId,
    required this.configuration,
  });

  final String initialSessionId;
  final SentryClientProviderConfiguration? configuration;

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
