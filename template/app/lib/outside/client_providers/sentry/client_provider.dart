import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_logging/sentry_logging.dart';

import '../../../shared/util/redact.dart';
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
        // The LoggingIntegration forwards log records to Sentry, so scrub
        // anything token-like before it leaves the device.
        ..sendDefaultPii = false
        ..beforeSend = _scrubEvent
        ..beforeBreadcrumb = _scrubBreadcrumb
        ..addIntegration(LoggingIntegration());
    });
    await setSessionId(sessionId: initialSessionId);
  }

  SentryEvent? _scrubEvent(SentryEvent event, Hint hint) {
    final message = event.message;
    SentryMessage? scrubbedMessage;
    if (message != null) {
      scrubbedMessage = message.copyWith(
        formatted: SharedUtil_Redact.scrub(message.formatted),
      );
    }

    return event.copyWith(
      message: scrubbedMessage,
      breadcrumbs:
          event.breadcrumbs
              ?.map((breadcrumb) => _scrubBreadcrumb(breadcrumb, hint))
              .nonNulls
              .toList(),
    );
  }

  Breadcrumb? _scrubBreadcrumb(Breadcrumb? breadcrumb, Hint hint) {
    final message = breadcrumb?.message;
    if (breadcrumb == null || message == null) {
      return breadcrumb;
    }

    return breadcrumb.copyWith(message: SharedUtil_Redact.scrub(message));
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
