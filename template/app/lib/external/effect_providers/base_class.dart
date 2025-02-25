import 'dart:async';

import '../util/abstracts/base_provider.dart';

abstract class Base_EffectProvider<T> extends UtilAbstract_BaseProvider {
  FutureOr<T> getEffect();
}
