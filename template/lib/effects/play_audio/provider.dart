// coverage:ignore-file

import 'effect.dart';

class PlayAudioEffectProvider {
  /// Note: the [debugLabel] is a convenience for testing
  PlayAudioEffect getEffect({
    required String debugLabel,
  }) {
    return PlayAudioEffect();
  }
}
