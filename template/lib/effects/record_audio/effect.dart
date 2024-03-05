// coverage:ignore-file

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:record/record.dart' as r;
import 'platform_methods/mobile.dart'
    if (dart.library.html) 'platform_methods/web.dart' as platform_methods;

class RecordAudioEffect {
  RecordAudioEffect() : _recorder = r.AudioRecorder();

  final r.AudioRecorder _recorder;
  StreamSubscription<r.RecordState>? _subscription;

  final log = Logger('record_audio_effect');

  Stream<r.RecordState> onStateChangedStream() {
    return _recorder.onStateChanged();
  }

  Future<void> _cancelSubscription() async {
    if (_subscription != null) {
      await _subscription!.cancel();
    }
  }

  Future<void> start() async {
    log.fine('start');
    await _cancelSubscription();

    if (await _recorder.hasPermission()) {
      await platform_methods.recordAudioEffect_start(_recorder);
    }
  }

  Future<void> pause() async {
    log.fine('pause');
    return _recorder.pause();
  }

  Future<void> resume() async {
    log.fine('resume');
    return _recorder.resume();
  }

  Future<String?> stop() async {
    log.fine('stop');
    return _recorder.stop();
  }

  Future<Uint8List> getFileBytes({
    required String recordingPath,
  }) async {
    return platform_methods.recordAudioEffect_getFileBytes(recordingPath);
  }

  Future<void> dispose() async {
    log.finer('dispose');
    await _cancelSubscription();
    await _recorder.dispose();
  }
}
