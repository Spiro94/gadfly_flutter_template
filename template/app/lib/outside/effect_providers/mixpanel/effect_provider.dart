import 'dart:async';

import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import '../../../shared/mixins/logging.dart';
import '../base.dart';
import 'effect.dart';
import 'effect_fake.dart';
import 'effect_provider_configuration.dart';

class Mixpanel_EffectProvider extends EffectProvider_Base<Mixpanel_Effect>
    with SharedMixin_Logging {
  Mixpanel_EffectProvider({
    required this.initialSessionId,
    required this.configuration,
  });

  final String initialSessionId;
  final Mixpanel_EffectProvider_Configuration configuration;
  late final Mixpanel? _mixpanel;

  @override
  Mixpanel_Effect getEffect() {
    if (configuration.sendEvents &&
        configuration.token != null &&
        configuration.token!.isNotEmpty) {
      return Mixpanel_Effect(mixpanel: _mixpanel!);
    }

    return Effect_Mixpanel_Fake();
  }

  @override
  Future<void> init() async {
    log.info('sessionId: $initialSessionId');

    if (configuration.token != null && configuration.token!.isNotEmpty) {
      _mixpanel = await Mixpanel.init(
        configuration.token!,
        trackAutomaticEvents: true,
      );

      log.info('environment: ${configuration.environment}');

      await _mixpanel!.registerSuperProperties({
        'environment': configuration.environment,
      });
      await setSessionId(sessionId: initialSessionId);
    }
  }

  Future<void> setSessionId({required String sessionId}) async {
    await _mixpanel!.registerSuperProperties({'session_id': sessionId});
  }
}
