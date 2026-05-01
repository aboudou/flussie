import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flussie/misc/constants.dart';
import 'package:flussie/misc/converters.dart';

class FiltersPanel extends StatelessWidget {
  const FiltersPanel({
    super.key,
    required this.showFilters,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onApply,
    this.superchargersOnly,
    this.onSuperchargersOnlyChanged,
  });

  final RxBool showFilters;
  final int startDate;
  final int endDate;
  final void Function(int) onStartDateChanged;
  final void Function(int) onEndDateChanged;
  final VoidCallback onApply;
  final bool? superchargersOnly;
  final void Function(bool)? onSuperchargersOnlyChanged;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!showFilters.value) {
        return TextButton(
          onPressed: () => showFilters.value = true,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 4.0,
            children: [
              Icon(Icons.filter_list_alt, color: Constants.darkGreyColor, size: 16),
              Text('filters'.tr, style: TextStyle(color: Constants.darkGreyColor)),
            ],
          ),
        );
      }

      return Column(
        spacing: 0.0,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('filter_from'.tr),
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.fromMillisecondsSinceEpoch(startDate * 1000),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) onStartDateChanged(picked.millisecondsSinceEpoch ~/ 1000);
                },
                child: Text(Converters.formatShortDate(startDate)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('filter_to'.tr),
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.fromMillisecondsSinceEpoch(endDate * 1000),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) onEndDateChanged(picked.millisecondsSinceEpoch ~/ 1000);
                },
                child: Text(Converters.formatShortDate(endDate)),
              ),
            ],
          ),
          if (superchargersOnly != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('charge_filter_superchargers_only'.tr),
                Checkbox(
                  value: superchargersOnly,
                  onChanged: (value) {
                    if (value != null) onSuperchargersOnlyChanged?.call(value);
                  },
                ),
              ],
            ),
          TextButton(
            onPressed: () {
              onApply();
              showFilters.value = false;
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 4.0,
              children: [
                Icon(Icons.done, color: Constants.darkGreyColor, size: 16),
                Text('filter_apply'.tr, style: TextStyle(color: Constants.darkGreyColor)),
              ],
            ),
          ),
        ],
      );
    });
  }
}
