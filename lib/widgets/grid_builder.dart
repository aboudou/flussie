import 'package:flutter/material.dart';

class GridBuilder extends StatelessWidget {
  const GridBuilder({
    super.key,
    required this.items,
  });

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: items[i]),
          const SizedBox(width: 16.0),
          Expanded(child: i + 1 < items.length ? items[i + 1] : const SizedBox()),
        ],
      ));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: rows,
    );
  }
}
