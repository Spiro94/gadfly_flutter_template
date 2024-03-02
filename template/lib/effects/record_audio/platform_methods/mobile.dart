// coverage:ignore-file
import 'dart:io';
import 'dart:typed_data';
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart' as r;

final _log = Logger('record_audio_effect.mobile');

Future<void> recordAudioEffect_start(r.AudioRecorder recorder) async {
  final dir = await getApplicationDocumentsDirectory();
  final path = p.join(
    dir.path,
    'recording_${DateTime.now().toIso8601String()}.wav',
  );

  _log.fine('recording path:\n$path');

  await recorder.start(
    const r.RecordConfig(
      encoder: r.AudioEncoder.wav,
    ),
    path: path,
  );
}

Future<(String, Uint8List)> recordAudioEffect_getFileNameAndBytes(
  String recordingPath,
) async {
  final recordingBytes = await File(recordingPath).readAsBytes();
  return (
    recordingPath.split('/').last,
    recordingBytes,
  );
}
