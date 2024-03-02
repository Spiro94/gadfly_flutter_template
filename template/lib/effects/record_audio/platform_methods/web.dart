// coverage:ignore-file
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:record/record.dart' as r;

Future<void> recordAudioEffect_start(r.AudioRecorder recorder) async {
  await recorder.start(
    const r.RecordConfig(
      encoder: r.AudioEncoder.wav,
    ),
    // Note: for web, we don't pass in a path
    path: '',
  );
}

Future<(String, Uint8List)> recordAudioEffect_getFileNameAndBytes(
  String recordingPath,
) async {
  final recordingResponse = await http.get(Uri.parse(recordingPath));
  final recordingBytes = recordingResponse.bodyBytes;
  return (
    // Note: the recording path is a blob, so we need to add the extension
    // (unlike for mobile)
    '${recordingPath.split('/').last}.wav',
    recordingBytes,
  );
}
