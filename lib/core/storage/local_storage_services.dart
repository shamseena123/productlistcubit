import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageServices {
  //SAVE BOOL

  Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  //GET BOOL

  Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key);
  }

  // SAVE STRING
  Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // GET STRING
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  //REMOVE DATA
  Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(key);
  }
}
