import 'package:kitchen/services/unit_converter.dart';
import 'package:test/test.dart';

void main() {
  group('test stringifySec', () {
    test('output hours minutes and seconds', () {
      final seconds = 4325;
      final result = UnitConverter.stringifySec(seconds);

      expect(result, equals('1 hour(s) 12 min(s) 5 sec(s)'));
    });

    test('if no hours, output minutes and seconds', () {
      final seconds = 725;
      final result = UnitConverter.stringifySec(seconds);

      expect(result, equals('12 min(s) 5 sec(s)'));
    });

    test('if no minutes, output hours and seconds', () {
      final seconds = 3605;
      final result = UnitConverter.stringifySec(seconds);

      expect(result, equals('1 hour(s) 5 sec(s)'));
    });

    test('if no seconds, output hours and minutes', () {
      final seconds = 4320;
      final result = UnitConverter.stringifySec(seconds);

      expect(result, equals('1 hour(s) 12 min(s)'));
    });

    test('if no hours and minutes, output seconds', () {
      final seconds = 5;
      final result = UnitConverter.stringifySec(seconds);

      expect(result, equals('5 sec(s)'));
    });

    test('if no hours and seconds, output minutes', () {
      final seconds = 720;
      final result = UnitConverter.stringifySec(seconds);

      expect(result, equals('12 min(s)'));
    });

    test('if no seconds and minutes, output hours', () {
      final seconds = 3600;
      final result = UnitConverter.stringifySec(seconds);

      expect(result, equals('1 hour(s)'));
    });

    test('if seconds are 0, no input', () {
      final seconds = 0;
      final result = UnitConverter.stringifySec(seconds);

      expect(result, equals(""));
    });
  });
}
