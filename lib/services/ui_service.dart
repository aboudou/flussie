import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flussie/enums/charge_type.dart';
import 'package:flussie/misc/constants.dart';

class UIService {

  static final UIService _instance = UIService._internal();

  UIService._internal();

  factory UIService() {
    return _instance;
  }

  Container rotatedIcon(Icon icon, double angle, {double size = 25}) {
    return Container(
      width: size,
      height: size,
      transformAlignment: Alignment.center,
      transform: Matrix4.rotationZ(angle * pi / 180),
      child: icon,
    );
  }

  Color getChargeTypeColor(ChargeType stationType) {
    if (stationType == ChargeType.supercharger) {
      return Constants.chargeTypeSuperchargerColor;
    } else if (stationType == ChargeType.fastCharger) {
      return Constants.chargeTypeFastChargerColor ;
    } else {
      return Constants.chargeTypeStandardChargerColor;
    }
  }

}