import 'package:flutter/material.dart';

import 'package:flussie/misc/constants.dart';

class InfoRow extends StatelessWidget {
  const InfoRow(
    {
      super.key,
      required this.icon,
      required this.title,
      required this.text,
      this.titleStyle = const TextStyle(color: Constants.darkGreyColor),
      this.textStyle = const TextStyle(color: Colors.black),
    }
  );

  final Widget icon;
  final String title;
  final String text;
  final TextStyle titleStyle;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8.0,
      children: [
        icon,
        Flexible( 
          fit: FlexFit.loose,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 0.0,
            children: [
              Text(title, style: titleStyle),
              Text(text, style: textStyle, softWrap: true, overflow: TextOverflow.fade,),
            ],
          ),
        ),
      ]
    );
  }
}