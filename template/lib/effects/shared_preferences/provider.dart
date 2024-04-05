// coverage:ignore-file
import 'package:shared_preferences/shared_preferences.dart';

import 'effect.dart';

class SharedPreferencesEffectProvider {
  SharedPreferencesEffectProvider({
    required String prefix,
  }) : _prefix = prefix;

  final String _prefix;
  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    SharedPreferences.setPrefix(_prefix);
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  SharedPreferencesEffect getEffect() {
    return SharedPreferencesEffect(sharedPreferences: _sharedPreferences);
  }
}
