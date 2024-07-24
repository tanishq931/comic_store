import 'package:hive/hive.dart';

class LocalStorage {
  static Box? _box;

  static Future<void> initHive() async {
    _box = await Hive.openBox('myBox');
  }

  static Future<void> storeList(String key, List<dynamic> list) async {
    await _box?.put(key, list);
  }

  static List<dynamic>? retrieveList(String key) {
    return _box?.get(key) as List<dynamic>?;
  }
}