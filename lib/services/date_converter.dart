class DateConverter {
  static DateTime fromServer(int dateSec) {
    return DateTime.fromMillisecondsSinceEpoch(dateSec * 1000);
  }

  static int toServer(DateTime date) {
    if (date == null) {
      return null;
    } else {
      return date.millisecondsSinceEpoch ~/ 1000;
    }
  }
}
