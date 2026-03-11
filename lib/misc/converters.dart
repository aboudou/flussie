class Converters {
  static double milesToKm(double? miles) {
    if (miles == null) return 0;
    return miles * 1.60934;
  }
}