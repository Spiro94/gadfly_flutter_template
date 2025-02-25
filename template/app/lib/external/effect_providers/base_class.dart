import 'dart:async';

import '../util/abstracts/base_provider.dart';

abstract class Base_EffectProvider<T>
    extends ExternalUtilAbstract_BaseProvider {
  FutureOr<T> getEffect();
}
