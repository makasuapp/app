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
}
