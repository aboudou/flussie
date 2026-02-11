import 'package:flutter/material.dart';

class GridBuilder extends StatelessWidget {
  const GridBuilder(
    {
      super.key,
      required this.items,
      required this.rowHeight,
    }
  );

  final List<Widget> items;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: rowHeight,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 16.0,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }
}