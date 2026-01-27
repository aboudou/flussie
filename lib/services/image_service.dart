import 'dart:math';

import 'package:flutter/material.dart';

class ImageService {

  static final ImageService _instance = ImageService._internal();

  ImageService._internal();

  factory ImageService() {
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