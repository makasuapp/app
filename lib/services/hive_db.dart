import 'package:hive/hive.dart';

class HiveDb {
  Box box;
  String boxName;

  HiveDb(this.boxName, {this.box});

  Future<void> _initBox() async {
    if (this.box == null) {
      this.box = await Hive.openBox(this.boxName);
    }
  }

  Future<void> add<T>(String keyName, T value) async {
    await _initBox();
    return this.box.put(keyName, value);
  }

  Future<void> addAll(Map<String, dynamic> valuesMap) async {
    await _initBox();
    return this.box.putAll(valuesMap);
  }

  Future<T> get<T>(String keyName) async {
    await _initBox();
    return this.box.get(keyName);
  }

  Future<void> delete(String keyName) async {
    await _initBox();
    return this.box.delete(keyName);
  }
}
