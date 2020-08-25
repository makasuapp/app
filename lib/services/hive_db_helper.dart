import 'package:hive/hive.dart';

class HiveDbValues{
  static final String unsavedUpdatesBox = "unsavedUpdatesBox";
  static final String unsavedIngredientUpdates = "unsavedIngredientUpdates";
  static final  String unsavedPrepUpates = "unsavedPrepUpdates";
}

class HiveDbs{
  static HiveDbHelper hivePrepUpdates = HiveDbHelper("HivePrepUpdatesBox", "updates");

}

class HiveDbHelper{

  var box;
  final name;
  final keyName;

  HiveDbHelper(this.name, this.keyName){
    initBox();
  }

  initBox() async{
    this.box = await Hive.openBox(name);
  }

  void add(Map<String, dynamic> value) async{
    await Hive.openBox(name);
    this.box.get(keyName).add(value);
  }

  Future<List<Map<String,dynamic>>> get() async{
    await Hive.openBox(name);
    return this.box.get(keyName).toList().cast<Map<String, dynamic>>();
     //return List.castthis.box.get(keyName);
  }

}