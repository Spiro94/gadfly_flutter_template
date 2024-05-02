// coverage:ignore-file
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';

final _log = Logger('play_audio_effect.mobile');

Future<void> playAudioEffect_setUrl({
  required AudioPlayer player,
  required String url,
}) async {
  _log.fine('url:\n$url');

  await player.setUrl(url);
}
