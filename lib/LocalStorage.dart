import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final Future<SharedPreferences> store = SharedPreferences.getInstance();

  Future<List<String>> getStringList(String key) async {
    try {
      return (await store).getStringList(key) ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> getBool(String key) async {
    try {
      return (await store).getBool(key) ?? true;
    } catch (e) {
      return true;
    }
  }

  void saveStringList(String key, List<String> value) async {
    (await store).setStringList(key, value);
  }

  void addToList(String key, String item) async {
    List<String> list = await getStringList(key);
    list.add(item);
    saveStringList(key, list);
  }

  void saveBool(String key, bool value) async {
    (await store).setBool(key, value);
  }
}
