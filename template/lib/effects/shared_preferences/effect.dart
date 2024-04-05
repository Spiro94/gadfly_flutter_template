// coverage:ignore-file

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesEffect {
  SharedPreferencesEffect({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  final _log = Logger('shared_preferences_effect');

  Future<bool> clear() async {
    final response = await _sharedPreferences.clear();
    _log.fine('clear\n$response');
    return response;
  }

  bool containsKey(String key) {
    final response = _sharedPreferences.containsKey(key);
    _log.fine('containsKey\n$key\n$response');
    return response;
  }

  Object? get(String key) {
    final response = _sharedPreferences.get(key);
    _log.fine('get\n$key\n$response');
    return response;
  }

  bool? getBool(String key) {
    final response = _sharedPreferences.getBool(key);
    _log.fine('getBool\n$key\n$response');
    return response;
  }

  double? getDouble(String key) {
    final response = _sharedPreferences.getDouble(key);
    _log.fine('getDouble\n$key\n$response');
    return response;
  }

  int? getInt(String key) {
    final response = _sharedPreferences.getInt(key);
    _log.fine('getInt\n$key\n$response');
    return response;
  }

  Set<String> getKeys() {
    final response = _sharedPreferences.getKeys();
    _log.fine('getKeys\n$response');
    return response;
  }

  String? getString(String key) {
    final response = _sharedPreferences.getString(key);
    _log.fine('getString\n$key\n$response');
    return response;
  }

  List<String>? getStringList(String key) {
    final response = _sharedPreferences.getStringList(key);
    _log.fine('getStringList\n$key\n$response');
    return response;
  }

  Future<void> reload() async {
    _log.fine('reload');
    return _sharedPreferences.reload();
  }

  Future<bool> remove(String key) async {
    final response = await _sharedPreferences.remove(key);
    _log.fine('remove\n$key\n$response');
    return response;
  }

  // ignore: avoid_positional_boolean_parameters
  Future<bool> setBool(String key, bool value) async {
    final response = await _sharedPreferences.setBool(key, value);
    _log.fine('setBool\n$key\n$value\n$response');
    return response;
  }

  Future<bool> setDouble(String key, double value) async {
    final response = await _sharedPreferences.setDouble(key, value);
    _log.fine('setDouble\n$key\n$value\n$response');
    return response;
  }

  Future<bool> setInt(String key, int value) async {
    final response = await _sharedPreferences.setInt(key, value);
    _log.fine('setInt\n$key\n$value\n$response');
    return response;
  }

  Future<bool> setString(String key, String value) async {
    final response = await _sharedPreferences.setString(key, value);
    _log.fine('setString\n$key\n$value\n$response');
    return response;
  }

  Future<bool> setStringList(String key, List<String> value) async {
    final response = await _sharedPreferences.setStringList(key, value);
    _log.fine('setStringList\n$key\n$value\n$response');
    return response;
  }
}
