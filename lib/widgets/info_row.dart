import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  const InfoRow(
    {
      super.key,
      required this.icon,
      required this.title,
      required this.text,
    }
  );

  final Widget icon;
  final String title;
  final String text;

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
              Text(title, style: TextStyle(color: Colors.grey[700])),
              Spacer(),
              Text(text, softWrap: true, overflow: TextOverflow.fade,),
            ],
          ),
        ),
      ]
    );
  }
}