import 'dart:async';

import '../../shared/mixins/logging.dart';

abstract class Base_EffectProvider<T> with SharedMixin_Logging {
  FutureOr<T> getEffect();

  Future<void> init();
}
