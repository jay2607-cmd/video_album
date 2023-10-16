import 'package:shared_preferences/shared_preferences.dart';

class DbProvider {
  final Future<SharedPreferences> _passcodeAuthentication =
      SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefRandom = SharedPreferences.getInstance();

  final Future<SharedPreferences> _hideCreationDate =
      SharedPreferences.getInstance();

  final Future<SharedPreferences> _doubleTap = SharedPreferences.getInstance();

  final Future<SharedPreferences> _hideEmptyCategoriesPref =
      SharedPreferences.getInstance();

  // for hide the creation date
  void saveDoubleTap(bool status) async {
    final instance = await _doubleTap;

    instance.setBool("hideCreationDate", status);
  }

  // for hide the creation date
  Future<bool> getDoubleTap() async {
    final instance = await _doubleTap;
    if (instance.containsKey("hideCreationDate")) {
      final value = instance.getBool("hideCreationDate");
      return value!;
    } else {
      return false;
    }
  }

  // for authentication setting
  void saveAuthState(bool status) async {
    final instance = await _passcodeAuthentication;

    instance.setBool("status", status);
  }

  // for authentication setting
  Future<bool> getAuthState() async {
    final instance = await _passcodeAuthentication;
    if (instance.containsKey("status")) {
      final value = instance.getBool("status");

      return value!;
    } else {
      return false;
    }
  }

  // for sharing notes
  void saveRandomState(bool status) async {
    final instance = await _prefRandom;
    instance.setBool("SharingNotes", status);
  }

  // for sharing notes
  Future<bool> getRandomState() async {
    final instance = await _prefRandom;
    if (instance.containsKey("SharingNotes")) {
      final value = instance.getBool("SharingNotes");
      return value!;
    } else {
      return false;
    }
  }

  // for hide the creation date
  void saveHideCreationDateStatus(bool status) async {
    final instance = await _hideCreationDate;

    instance.setBool("hideCreationDate", status);
  }

  // for hide the creation date
  Future<bool> getHideCreationDateStatus() async {
    final instance = await _hideCreationDate;
    if (instance.containsKey("hideCreationDate")) {
      final value = instance.getBool("hideCreationDate");
      return value!;
    } else {
      return false;
    }
  }

  // for hide the empty category
  void saveEmptyCategories(bool status) async {
    final instance = await _hideEmptyCategoriesPref;

    instance.setBool("hideEmptyCategories", status);
  }

  // for hide the empty category
  Future<bool> getEmptyCategories() async {
    final instance = await _hideEmptyCategoriesPref;
    if (instance.containsKey("hideEmptyCategories")) {
      final value = instance.getBool("hideEmptyCategories");
      return value!;
    } else {
      return false;
    }
  }
}
