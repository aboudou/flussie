import 'dart:math';

import 'package:flutter/material.dart';

class ImageUIService {

  static final ImageUIService _instance = ImageUIService._internal();

  ImageUIService._internal();

  factory ImageUIService() {
    return _instance;
  }

  Container rotatedIcon (Icon icon, double angle, {double size = 25, Color bgColor = Colors.transparent}) {
    return Container(
      width: size,
      height: size,
      color: bgColor,
      transformAlignment: Alignment.center,
      transform: Matrix4.rotationZ(
        angle * pi / 180,
      ),
      child:  icon
    );
  }

}