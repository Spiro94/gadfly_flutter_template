// coverage:ignore-file

import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';
import 'platform_methods/mobile.dart'
    if (dart.library.html) 'platform_methods/web.dart' as platform_methods;

class PlayAudioEffect {
  PlayAudioEffect() : _player = AudioPlayer();

  final AudioPlayer _player;

  String? playerUrl;

  final log = Logger('play_audio_effect');

  Future<void> setUrl({
    required String url,
  }) async {
    log.fine('setUrl: $url');

    await platform_methods.playAudioEffect_setUrl(
      player: _player,
      url: url,
    );
    playerUrl = url;
  }

  Future<void> play() async {
    log.fine('play');
    await _player.play();
  }

  Future<void> replay() async {
    log.fine('replay');
    await setUrl(url: playerUrl!);
    await _player.play();
  }

  Future<void> pause() async {
    log.fine('pause');
    await _player.pause();
  }

  Stream<PlayerState> playerStateStream() {
    return _player.playerStateStream;
  }

  Future<void> dispose() async {
    log.finer('dispose');
    await _player.dispose();
  }
}
