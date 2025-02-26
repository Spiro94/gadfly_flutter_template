import 'package:gadfly_flutter_template/outside/effect_providers/mixpanel/effect.dart';

import 'auth_change_effect.dart';

class AllMockedEffects {
  AllMockedEffects({
    required this.authChangeEffect,
    required this.mixpanelEffect,
  });

  final MockAuthChangeEffect authChangeEffect;
  final MixpanelEffect mixpanelEffect;
}
