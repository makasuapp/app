import 'package:hive/hive.dart';

class HiveDbValues {
  static final String unsavedUpdatesBox = "unsavedUpdatesBox";
  static final String unsavedIngredientUpdates = "unsavedIngredientUpdates";
  static final String unsavedPrepUpates = "unsavedPrepUpdates";
}

class HiveDbs {
  static HiveDbHelper hivePrepUpdates =
      HiveDbHelper("HivePrepUpdatesBox", "updates");
  static HiveDbHelper hiveIngredientUpdates = HiveDbHelper("HiveIngredientUpdatesBox", "updates");
}

class HiveDbHelper {
  var box;
  String name;
  String keyName;

  HiveDbHelper(this.name, this.keyName, {this.box});

  Future<void> initBox() async {
    if(this.box == null){
      this.box = await Hive.openBox(name);
    }
    this.box.put(keyName, null);
  }

  void add(Map<String, dynamic> value) async {
    await initBox();
    if (this.box.get(keyName) != null) {
      this.box.get(keyName).add(value);
    } else {
      this.box.put(keyName, value);
    }
  }

  void addAll(List<Map<String, dynamic>> values) async {
    await initBox();
    if (this.box.get(keyName) != null) {
      this.box.get(keyName).addAll(values);
    } else {
      this.box.put(keyName, values);
    }
  }

  Future<List<Map<String, dynamic>>> get() async {
    await initBox();
    return ((await this.box.get(keyName)) != null)
        ? (await this.box.get(keyName)).toList().cast<Map<String, dynamic>>()
        : null;
    //return List.castthis.box.get(keyName);
  }
}
