import 'package:hive/hive.dart';

class HiveDb {
  Box box;
  String boxName;

  HiveDb(this.boxName, {this.box});

  //better way to construct + init together
  static Future<HiveDb> init(String boxName) async {
    final db = HiveDb(boxName);
    await db.initBox();
    return db;
  }

  //can construct and init separately if want
  Future<void> initBox() async {
    if (this.box == null) {
      this.box = await Hive.openBox(this.boxName);
    }
  }

  void add<T>(String keyName, T value) async {
    return this.box.put(keyName, value);
  }

  void addAll(Map<String, dynamic> valuesMap) async {
    return this.box.putAll(valuesMap);
  }

  T get<T>(String keyName) {
    return this.box.get(keyName);
  }

  void delete(String keyName) async {
    return this.box.delete(keyName);
  }
}
