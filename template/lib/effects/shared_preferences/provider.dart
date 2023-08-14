import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesEffectProvider {
  SharedPreferencesEffectProvider({
    required String prefix,
  }) : _prefix = prefix;

  final String _prefix;
  late SharedPreferences _sharedPreferences;

  // coverage:ignore-start
  Future<void> init() async {
    SharedPreferences.setPrefix(_prefix);
    _sharedPreferences = await SharedPreferences.getInstance();
  }
  // coverage:ignore-end

  @visibleForTesting
  Future<void> setMockIntialValue(Map<String, Object> initialValues) async {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues(initialValues);
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  SharedPreferences getEffect() {
    return _sharedPreferences;
  }
}
