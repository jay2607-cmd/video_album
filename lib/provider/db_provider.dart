import 'package:shared_preferences/shared_preferences.dart';

class DbProvider {
  final Future<SharedPreferences> _unmute = SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefRandom = SharedPreferences.getInstance();

  final Future<SharedPreferences> _doubleTap = SharedPreferences.getInstance();

  void saveUnMuteState(bool status) async {
    final instance = await _unmute;

    instance.setBool("unmute", status);
  }

  Future<bool> getUnMuteState() async {
    final instance = await _unmute;
    if (instance.containsKey("unmute")) {
      final value = instance.getBool("unmute");

      return value!;
    } else {
      return false;
    }
  }

  void saveRandomState(bool status) async {
    final instance = await _prefRandom;
    instance.setBool("random", status);
  }

  Future<bool> getRandomState() async {
    final instance = await _prefRandom;
    if (instance.containsKey("random")) {
      final value = instance.getBool("random");
      return value!;
    } else {
      return false;
    }
  }

  void saveDoubleTap(bool status) async {
    final instance = await _doubleTap;

    instance.setBool("doubleTap", status);
  }

  Future<bool> getDoubleTap() async {
    final instance = await _doubleTap;
    if (instance.containsKey("doubleTap")) {
      final value = instance.getBool("doubleTap");
      return value!;
    } else {
      return false;
    }
  }
}
