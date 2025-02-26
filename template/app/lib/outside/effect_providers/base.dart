import 'dart:async';

import '../../shared/mixins/logging.dart';

abstract class EffectProvider_Base<T> with SharedMixin_Logging {
  const EffectProvider_Base();
  Future<void> init();
  FutureOr<T> getEffect();
}
