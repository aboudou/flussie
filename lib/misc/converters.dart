import 'dart:ui';

import 'package:get/get.dart';

class Converters {
  static double milesToKm(double? miles) {
    if (miles == null) return 0;
    return miles * 1.60934;
  }

  static Locale get deviceLocale => Get.deviceLocale ?? const Locale('en', 'US');
}
