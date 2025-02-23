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
    required this.sessionId,
    required this.configuration,
  });

  final String sessionId;
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
    log.info('sessionId: $sessionId');

    if (configuration.token != null && configuration.token!.isNotEmpty) {
      _mixpanel = await Mixpanel.init(
        configuration.token!,
        trackAutomaticEvents: true,
      );

      log.info('environment: ${configuration.environment}');

      await _mixpanel!.registerSuperProperties({
        'environment': configuration.environment,
        'session_id': sessionId,
      });
    }
  }
}
