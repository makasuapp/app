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
}
