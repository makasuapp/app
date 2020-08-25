import 'dart:convert';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:kitchen/services/hive_db_helper.dart';
import 'package:test/test.dart';

void main(){
  Hive.init(".dart_tool/test/tmp/test_hive_dir");
  final String boxName = "mockBox";
  final String keyName = "mockKey";

  test("Creating a HiveDbHelper object and calling init opens box with key as null", () async{
    HiveDbHelper helper = HiveDbHelper(boxName, keyName);
    await helper.initBox();
    
    expect(helper.box, isNotNull);
    expect(await helper.box.get(keyName), isNull);
  });

  test("using get() when key has null value returns null", () async{
    HiveDbHelper helper = HiveDbHelper(boxName, keyName);

    expect(await helper.get(), null);
  });

  test("using get() when key has non null value returns a List", () async{
    var box = await Hive.openBox(boxName);
    List<Map<String, dynamic>> value = [{"key2" : "value2"}];
    box.put(keyName, value);
    HiveDbHelper helper = HiveDbHelper(boxName, keyName, box: box);

    print(await helper.box.get(keyName)); //prints non null value

    expect(await helper.get(), isNotNull); //but over here shows as null
    expect(await helper.get(), value);
  });

  test("using add() when key has null value adds to box", () async{
    final boxName2 = "mockBox2";
    final keyName2 = "mockKey2";
    HiveDbHelper helper = HiveDbHelper(boxName2, keyName2);
    await helper.initBox();
    List<Map<String, dynamic>> value = [{"key3" : "value3"}];
    helper.add(value[0]);

    expect(await helper.get(), isNotNull);
    expect(await helper.get(), value);
  });

  test("using add() when key has non null value adds to box with length 2", () async{
    final boxName2 = "mockBox2";
    final keyName2 = "mockKey2";
    HiveDbHelper helper = HiveDbHelper(boxName2, keyName2);
    await helper.initBox();
    List<Map<String, dynamic>> value = [{"key4" : "value4"}];
    helper.add(value[0]);

    expect(await helper.get(), isNotNull);
    expect((await helper.get()).length, equals(2));
    expect(await helper.get(), value);
  });

  test("using addAll() when key has null value adds to box", () async{
    final boxName3 = "mockBox3";
    final keyName3 = "mockKey3";
    HiveDbHelper helper = HiveDbHelper(boxName3, keyName3);
    await helper.initBox();
    List<Map<String, dynamic>> value = [{"key5" : "value5"}];
    helper.addAll(value);

    expect(await helper.get(), isNotNull);
    expect(await helper.get(), value);
  });

  test("using addAll() when key has non null value adds to box with length 2", () async{
    final boxName3 = "mockBox3";
    final keyName3 = "mockKey3";
    HiveDbHelper helper = HiveDbHelper(boxName3, keyName3);
    await helper.initBox();
    List<Map<String, dynamic>> value = [{"key6" : "value6"}];
    helper.addAll(value);

    expect(await helper.get(), isNotNull);
    expect((await helper.get()).length, equals(2));
    expect(await helper.get(), value);
  });
  /*test("Adding a value when the key has null value creates a new value in the key", (){
    final value = {"key":"value"};
    helper.add(value);

    //expect(he)
  }); */
}