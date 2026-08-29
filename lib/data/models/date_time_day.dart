class DateTimeDay {
  String dateTimeOfDayFun() {
    final now = DateTime.now();
    if (now.hour >= 6 && now.hour < 12) {
      return "Goog Morning";
    } else if (now.hour >= 12 && now.hour < 18) {
      return "Good afternoon";
    } else if (now.hour >= 18 && now.hour < 24) {
      return "Good evening";
    } else {
      return "Good tonight";
    }
  }
}
