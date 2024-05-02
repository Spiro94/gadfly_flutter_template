import 'dart:async';
import 'package:gadfly_flutter_template/effects/record_audio/effect.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';

class MockRecordAudioEffect extends Mock implements RecordAudioEffect {
  @override
  final log = Logger('record_audio_effect');

  StreamController<RecordState>? streamController;
  StreamSubscription<RecordState>? _subscription;

  @override
  Stream<RecordState> onStateChangedStream() {
    streamController = StreamController<RecordState>();
    final stream = streamController!.stream;
    streamController!.add(RecordState.stop);
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
