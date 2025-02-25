// coverage:ignore-file

import 'dart:async';

import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import '../../../shared/mixins/logging.dart';
import '../base_class.dart';
import 'configuration.dart';
import 'effect.dart';
import 'effect_fake.dart';

class MixpanelEffectProvider extends Base_EffectProvider<MixpanelEffect>
    with SharedMixin_Logging {
  MixpanelEffectProvider({
    required this.initialSessionId,
    required this.configuration,
  });

  final String initialSessionId;
  final MixpanelEffectProviderConfiguration configuration;
  late final Mixpanel? _mixpanel;

  @override
  MixpanelEffect getEffect() {
    if (configuration.sendEvents &&
        configuration.token != null &&
        configuration.token!.isNotEmpty) {
      return MixpanelEffect(
        mixpanel: _mixpanel!,
      );
    }

    return MixpanelEffect_Fake();
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
    await _mixpanel!.registerSuperProperties({
      'session_id': sessionId,
    });
  }
}
