class WeightUnit {
  final String short;
  final String long;
  final double toG;

  WeightUnit(this.short, this.long, this.toG);
}

class VolumeUnit {
  final String short;
  final String long;
  final double toML;

  VolumeUnit(this.short, this.long, this.toML);
}

final weightUnits = {
  "oz": WeightUnit("oz", "ounce", 28.35),
  "g": WeightUnit("g", "gram", 1),
  "kg": WeightUnit("kg", "kilograms", 1000),
  "lb": WeightUnit("lb", "pound", 453.6)
};

final volumeUnits = {
  "tsp": VolumeUnit("tsp", "teaspoon", 4.929),
  "tbsp": VolumeUnit("tbsp", "tablespoon", 14.787),
  "cup": VolumeUnit("cup", "cup", 237),
  "mL": VolumeUnit("mL", "millilitre", 1),
  "L": VolumeUnit("L", "litre", 1000),
  "gal": VolumeUnit("gal", "gallon", 3785),
  "qt": VolumeUnit("qt", "quart", 946)
};

class UnitConverter {
  static String qtyWithUnit(double qty, String unit) {
    final isInteger = qty == qty.toInt();
    final shownQty =
        isInteger ? qty.toInt().toString() : qty.toStringAsPrecision(2);

    if (unit == null) {
      return shownQty;
    } else {
      return "$shownQty $unit";
    }
  }

  static String stringifySec(int seconds) {
    int hours = seconds ~/ 3600;
    int mins = (seconds % 3600) ~/ 60;
    int secs = (seconds % 3600) % 60;

    String convertedString = ((hours > 0) ? "$hours hour(s) " : "") +
        ((mins > 0) ? "$mins min(s) " : "") +
        ((secs > 0) ? "$secs sec(s)" : "");
   /* if (convertedString.length > 0 &&
        convertedString[convertedString.length - 1] == ' ') {
      return convertedString.substring(0, convertedString.length - 1);
    } */
    return convertedString.trim();
  }

  static bool canConvert(String inputUnit, String outputUnit, {double volumeWeightRatio}) {
    final inputIsV = volumeUnits.containsKey(inputUnit);
    final inputIsW = weightUnits.containsKey(inputUnit);
    final outputIsV = volumeUnits.containsKey(outputUnit);
    final outputIsW = weightUnits.containsKey(outputUnit);

    return (inputUnit == outputUnit) || 
      (inputIsV && outputIsV) || (inputIsW && outputIsW) ||
      (((inputIsV && outputIsW) || (inputIsW && outputIsV)) && volumeWeightRatio != null);
  }

  static double convert(double inputQty,  
    {String inputUnit, String outputUnit, double volumeWeightRatio}) {

    if (inputUnit == outputUnit) {
      return inputQty;
    } else if (canConvert(inputUnit, outputUnit, volumeWeightRatio: volumeWeightRatio)) {
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

    throw Exception("Can't convert between these units. input=$inputUnit, output=$outputUnit, volume_weight_ratio=$volumeWeightRatio");
  }
}
