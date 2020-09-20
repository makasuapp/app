import 'dart:convert';
import 'package:test/test.dart';
import 'package:kitchen/api/input_update.dart';

void main() {
  test('input_update to JSON', () {
    var updates = List<InputUpdate>();
    updates.add(InputUpdate(1, 1.2, 12345));
    updates.add(InputUpdate(2, 1.5, 12346));

    final updatesJson = jsonEncode({'updates': updates});
    expect(
        updatesJson,
        equals(
            '{"updates":[{"id":1,"had_qty":1.2,"time_sec":12345},{"id":2,"had_qty":1.5,"time_sec":12346}]}'));
  });
}
