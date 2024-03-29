import 'package:kitchen/services/unit_converter.dart';
import 'package:test/test.dart';

void main() {
  group('qtyWithUnit', () {
    test('null unit shows no unit', () {
      expect(UnitConverter.qtyWithUnit(1.5, null), equals("1.50"));
    });

    test('non-convertable shows unit as is', () {
      expect(UnitConverter.qtyWithUnit(1.512345, "lb"), equals("1.51 lb"));
      expect(UnitConverter.qtyWithUnit(1, "g"), equals("1 g"));
      expect(UnitConverter.qtyWithUnit(3, "L"), equals("3 L"));
      expect(UnitConverter.qtyWithUnit(1.5, "tbsp"), equals("1.50 tbsp"));
      expect(UnitConverter.qtyWithUnit(2.5, "handful"), equals("2.50 handful"));
    });

    test('converts up', () {
      expect(UnitConverter.qtyWithUnit(1500, "g"), equals("1.50 kg"));
      expect(UnitConverter.qtyWithUnit(32, "oz"), equals("2 lb"));
      expect(UnitConverter.qtyWithUnit(1500, "mL"), equals("1.50 L"));
      expect(UnitConverter.qtyWithUnit(998.4, "tsp"), equals("1.30 gal"));
      expect(UnitConverter.qtyWithUnit(3, "tsp"), equals("1 tbsp"));
    });
  });

  group('test(stringifySec', () {
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

  group("canConvert", () {
    test("is true when both null", () {
      expect(UnitConverter.canConvert(null, null), isTrue);
    });

    test("is true when both not weight/volume", () {
      expect(UnitConverter.canConvert("handful", "handful"), isTrue);
    });

    test("is false when one has units and other, doesn't", () {
      expect(UnitConverter.canConvert("tbsp", null), isFalse);
      expect(UnitConverter.canConvert(null, "tbsp"), isFalse);
    });

    test("is true when both volume or weight", () {
      expect(UnitConverter.canConvert("tbsp", "tsp"), isTrue);
      expect(UnitConverter.canConvert("lb", "kg"), isTrue);
    });

    test("is false when not both volume/weight", () {
      expect(UnitConverter.canConvert("tbsp", "kg"), isFalse);
      expect(UnitConverter.canConvert("handful", "tbsp"), isFalse);
    });

    test("is true when volume <-> weight volumeWeightRatio", () {
      expect(UnitConverter.canConvert("tbsp", "kg", volumeWeightRatio: 1.5),
          isTrue);
      expect(UnitConverter.canConvert("lb", "tsp", volumeWeightRatio: 1.5),
          isTrue);
    });
  });

  group("convert", () {
    test("with no units just returns qty", () {
      expect(UnitConverter.convert(1.5), equals(1.5));
    });

    test("with one unit errors", () {
      expect(
          () => UnitConverter.convert(1.5, outputUnit: "g"), throwsException);
      expect(() => UnitConverter.convert(1.5, inputUnit: "g"), throwsException);
    });

    test("of weight", () {
      expect(UnitConverter.convert(16, inputUnit: "oz", outputUnit: "lb"),
          equals(1));
    });

    test("of volume", () {
      expect(UnitConverter.convert(1.5, inputUnit: "tbsp", outputUnit: "tsp"),
          equals(4.5));
    });

    test("of volume to weight", () {
      expect(
          UnitConverter.convert(2,
              inputUnit: "gal", outputUnit: "kg", volumeWeightRatio: 1.5),
          equals(11.355));
    });

    test("of weight to volume", () {
      expect(
          UnitConverter.convert(15,
              inputUnit: "lb", outputUnit: "L", volumeWeightRatio: 1.4),
          equals(4.86));
    });
  });
}
