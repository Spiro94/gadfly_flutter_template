// coverage:ignore-file
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final _log = Logger('play_audio_effect.mobile');

Future<void> playAudioEffect_setUrl({
  required AudioPlayer player,
  required String url,
}) async {
  _log.fine('url:\n$url');

  if (Platform.isAndroid) {
    await player.setUrl(url);
    return;
  }

  final savePath = await _createFilePath();
  _log.fine('recording path:\n$savePath');

  final dio = Dio();
  await dio.download(url, savePath);
  final file = File(savePath);

  await player.setFilePath(file.path);
}

Future<String> _createFilePath() async {
  final dir = await getApplicationDocumentsDirectory();
  final path = p.join(
    dir.path,
    'recording_${DateTime.now().toIso8601String()}.wav',
  );
  return path;
}
