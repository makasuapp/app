class WeightUnit {
  final double toG;
  final String short;
  final String long;
  final String nextLevel;

  WeightUnit(this.short, this.long, this.toG, this.nextLevel);
}

class VolumeUnit {
  final double toML;
  final String short;
  final String long;
  final String nextLevel;

  VolumeUnit(this.short, this.long, this.toML, this.nextLevel);
}

final weightUnits = {
  "oz": WeightUnit("oz", "ounce", 28.35, "lb"),
  "g": WeightUnit("g", "gram", 1, "kg"),
  "kg": WeightUnit("kg", "kilograms", 1000, null),
  "lb": WeightUnit("lb", "pound", 453.6, null)
};

final volumeUnits = {
  "tsp": VolumeUnit("tsp", "teaspoon", 4.929, "tbsp"),
  "tbsp": VolumeUnit("tbsp", "tablespoon", 14.787, "cup"),
  "cup": VolumeUnit("cup", "cup", 237, "qt"),
  "mL": VolumeUnit("mL", "millilitre", 1, "L"),
  "L": VolumeUnit("L", "litre", 1000, null),
  "gal": VolumeUnit("gal", "gallon", 3785, null),
  "qt": VolumeUnit("qt", "quart", 946, "gal")
};

class UnitConverter {
  static double _convertUp(double qty, String inputUnit, String outputUnit) {
    if (inputUnit != null && outputUnit != null) {
      final converted =
          convert(qty, inputUnit: inputUnit, outputUnit: outputUnit);
      if (converted > 1) {
        return converted;
      }
    }

    return null;
  }

  static String qtyWithUnit(double qty, String unit) {
    var currQty = qty;
    var shownUnit = unit;

    if (weightUnits.containsKey(shownUnit)) {
      final nextLevel = weightUnits[shownUnit].nextLevel;
      final converted = _convertUp(currQty, shownUnit, nextLevel);
      if (converted != null && converted > 1) {
        currQty = converted;
        shownUnit = nextLevel;
      }
    } else if (volumeUnits.containsKey(shownUnit)) {
      var nextLevel;
      var converted;
      do {
        nextLevel = volumeUnits[shownUnit].nextLevel;
        converted = _convertUp(currQty, shownUnit, nextLevel);

        if (converted != null && converted > 1) {
          currQty = converted;
          shownUnit = nextLevel;
        }
      } while (nextLevel != null && converted != null && converted > 1);
    }

    final isInteger = currQty == currQty.toInt();
    final shownQty =
        isInteger ? currQty.toInt().toString() : currQty.toStringAsPrecision(2);

    if (unit == null) {
      return shownQty;
    } else {
      return "$shownQty $shownUnit";
    }
  }

  static String stringifySec(int seconds) {
    int hours = seconds ~/ 3600;
    int mins = (seconds % 3600) ~/ 60;
    int secs = (seconds % 3600) % 60;

    String convertedString = ((hours > 0) ? "$hours hour(s) " : "") +
        ((mins > 0) ? "$mins min(s) " : "") +
        ((secs > 0) ? "$secs sec(s)" : "");
    return convertedString.trim();
  }

  static bool canConvert(String inputUnit, String outputUnit,
      {double volumeWeightRatio}) {
    final inputIsV = volumeUnits.containsKey(inputUnit);
    final inputIsW = weightUnits.containsKey(inputUnit);
    final outputIsV = volumeUnits.containsKey(outputUnit);
    final outputIsW = weightUnits.containsKey(outputUnit);

    return (inputUnit == outputUnit) ||
        (inputIsV && outputIsV) ||
        (inputIsW && outputIsW) ||
        (((inputIsV && outputIsW) || (inputIsW && outputIsV)) &&
            volumeWeightRatio != null);
  }

  static double convert(double inputQty,
      {String inputUnit, String outputUnit, double volumeWeightRatio}) {
    if (inputUnit == outputUnit) {
      return inputQty;
    } else if (canConvert(inputUnit, outputUnit,
        volumeWeightRatio: volumeWeightRatio)) {
      final inputV = volumeUnits[inputUnit];
      final inputW = weightUnits[inputUnit];
      final outputV = volumeUnits[outputUnit];
      final outputW = weightUnits[outputUnit];

      if (inputV != null && outputV != null) {
        return inputQty * inputV.toML / outputV.toML;
      } else if (inputW != null && outputW != null) {
        return inputQty * inputW.toG / outputW.toG;
      } else if (volumeWeightRatio != null) {
        if (inputV != null && outputW != null) {
          return inputQty * (inputV.toML / outputW.toG) * volumeWeightRatio;
        } else if (inputW != null && outputV != null) {
          return inputQty * (inputW.toG / outputV.toML) / volumeWeightRatio;
        }
      }
    }

    throw Exception(
        "Can't convert between these units. input=$inputUnit, output=$outputUnit, volume_weight_ratio=$volumeWeightRatio");
  }
}
