import 'package:gadfly_flutter_template/outside/effect_providers/auth_change/provider.dart';
import 'package:gadfly_flutter_template/outside/effect_providers/mixpanel/provider.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthChangeEffectProvider extends Mock
    implements AuthChangeEffectProvider {}

class MockMixpanelEffectProvider extends Mock
    implements MixpanelEffectProvider {}
