import 'package:hive/hive.dart';
import 'package:kitchen/services/hive_db.dart';
import 'package:test/test.dart';

void main() {
  Hive.init(".dart_tool/test/tmp/test_hive_dir");
  const key = "key";

  test("get() when key has null value returns null", () async {
    HiveDb db = HiveDb("box1");

    expect(await db.get(key), null);
  });

  test("add() overwrites value at key", () async {
    HiveDb db = HiveDb("box2");
    await db.add(key, 1);

    expect(await db.get(key), 1);

    await db.add(key, 2);

    expect(await db.get(key), 2);
  });
}
