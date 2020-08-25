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
    this.box.put(keyName, null);
  }

  void add(Map<String, dynamic> value) async{
    await Hive.openBox(name);
    if(this.box.get(keyName) != null){
      this.box.get(keyName).add(value);
    }
    else{
      this.box.put(keyName, value);
    }
  }

  void addAll(List<Map<String, dynamic>> values) async{
    await Hive.openBox(name);
    if(this.box.get(keyName) != null){
      this.box.get(keyName).addAll(values);
    }
    else{
      this.box.put(keyName, values);
    }
  }

  Future<List<Map<String,dynamic>>> get() async{
    await Hive.openBox(name);
    return (this.box.get(keyName) != null) ? this.box.get(keyName).toList().cast<Map<String, dynamic>>() : null;
     //return List.castthis.box.get(keyName);
  }

}