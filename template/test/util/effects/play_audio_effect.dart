import 'dart:async';
import 'package:gadfly_flutter_template/effects/play_audio/effect.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';

class MockPlayAudioEffect extends Mock implements PlayAudioEffect {
  MockPlayAudioEffect({
    required this.debugLabel,
  });

  final String debugLabel;

  @override
  final log = Logger('play_audio_effect');

  StreamController<PlayerState>? streamController;
  StreamSubscription<PlayerState>? _subscription;

  @override
  Stream<PlayerState> playerStateStream() {
    streamController = StreamController<PlayerState>();
    final stream = streamController!.stream;
    streamController!.add(PlayerState(false, ProcessingState.idle));
    return stream;
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    if (!(streamController?.isClosed ?? true)) {
      await streamController?.close();
    }
  }
}
