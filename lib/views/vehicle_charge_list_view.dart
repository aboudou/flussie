import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flussie/misc/constants.dart';
import 'package:flussie/viewmodels/vehicle_charge_list_vm.dart';

class VehicleChargeListView extends StatefulWidget {
  const VehicleChargeListView({super.key, required this.viewModel});

  final VehicleChargeListViewModel viewModel;

  void refresh() {
    viewModel.refresh();
  }

  @override
  State<VehicleChargeListView> createState() => _VehicleChargeListViewState();
}

class _VehicleChargeListViewState extends State<VehicleChargeListView> {

  static const _iconSizeRegular = 25.0;
  static const _iconSizeSmall = 16.0;

  String _formatDate(int epochSeconds) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
    return DateFormat.yMd(Get.deviceLocale?.toString() ?? 'en_US').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: 
            widget.viewModel.chargeList.value.results.isEmpty
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.0,
              children: [
                _filtersPanel(),
                Text(widget.viewModel.errorMessage.isEmpty ? 'No charge found.' : widget.viewModel.errorMessage.value),
                Spacer(),
              ],
            ) 
            : ListView.builder(
                itemCount: widget.viewModel.chargeList.value.results.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                      // return the header
                      return _filtersPanel();
                  }
                  index -= 1;

                  final charge = widget.viewModel.chargeList.value.results[index];
                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    shadowColor: Colors.black54,
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        // Get.to(() => VehicleTabView(viewModel: VehicleTabViewModel(vin: vin, name: name)));
                        // TODO: Navigate to charge details view
                      },
                      child: 
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            spacing: 8.0,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 8.0,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: 4.0,
                                      children: [
                                        Icon(Icons.flash_on, color: widget.viewModel.getChargeTypeColor(charge), size: _iconSizeRegular),
                                        Flexible( 
                                          fit: FlexFit.loose,
                                          child: Text(widget.viewModel.getChargeLocation(charge), style: TextStyle(fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    ),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 0.0,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 4.0,
                                          children: [
                                            widget.viewModel.getStartBatteryIcon(charge, _iconSizeRegular),
                                            Text(widget.viewModel.getStartBatteryLevel(charge), style: TextStyle(color: Constants.darkGreyColor),),
                                            Text('•', style: TextStyle(color: Constants.darkGreyColor),),
                                            Text(widget.viewModel.getStartDate(charge), style: TextStyle(color: Constants.darkGreyColor),),
                                          ],
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: (_iconSizeRegular - _iconSizeSmall) / 2),
                                          child: Icon(Icons.more_vert, size: _iconSizeSmall, color: Constants.darkGreyColor,),
                                        ),

                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 4.0,
                                          children: [
                                            widget.viewModel.getEndBatteryIcon(charge, _iconSizeRegular),
                                            Text(widget.viewModel.getEndBatteryLevel(charge), style: TextStyle(color: Constants.darkGreyColor),),
                                            Text('•', style: TextStyle(color: Constants.darkGreyColor),),
                                            Text(widget.viewModel.getEndDate(charge), style: TextStyle(color: Constants.darkGreyColor),),
                                          ],
                                        ),
                                      ],
                                    ),

                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: 16.0,
                                      children: [
                                        Text(widget.viewModel.getCost(charge), style: TextStyle(color: Colors.blue),),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 4.0,
                                          children: [
                                            Icon(Icons.ev_station, color: Constants.darkGreyColor, size: _iconSizeSmall),
                                            Text(widget.viewModel.getEnergyAdded(charge), style: TextStyle(color: Constants.darkGreyColor),),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 4.0,
                                          children: [
                                            Icon(Icons.schedule, color: Constants.darkGreyColor, size: _iconSizeSmall),
                                            Text(widget.viewModel.getDuration(charge), style: TextStyle(color: Constants.darkGreyColor),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                    ),
                  );
                },
              ),
        ),
      );
    });
  }

  Widget _filtersPanel() {
    return Obx(() {
      if (!widget.viewModel.showFilters.value) {

        return TextButton(
          onPressed: () {
            widget.viewModel.showFilters.value = true;
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 4.0,
            children: [
              Icon(Icons.filter_list_alt, color: Constants.darkGreyColor, size: 16,),
              Text('Filters', style: TextStyle(color: Constants.darkGreyColor),),
            ],
          ),
        );

      } else {

        return Column(
          spacing: 0.0,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('From'),
                TextButton(
                  onPressed: () async {
                    final initial = DateTime.fromMillisecondsSinceEpoch(widget.viewModel.startDate * 1000);
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initial,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        widget.viewModel.startDate = picked.millisecondsSinceEpoch ~/ 1000;
                      });
                    }
                  },
                  child: Text(_formatDate(widget.viewModel.startDate)),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('To'),
                TextButton(
                  onPressed: () async {
                    final initial = DateTime.fromMillisecondsSinceEpoch(  widget.viewModel.endDate * 1000);
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initial,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        widget.viewModel.endDate = picked.millisecondsSinceEpoch ~/ 1000;
                      });
                    }
                  },
                  child: Text(_formatDate(widget.viewModel.endDate)),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Superchargers only'),
                Checkbox(
                  value: widget.viewModel.superchargersOnly,
                  onChanged: (value) {
                    setState(() {
                      widget.viewModel.superchargersOnly = value!;
                    });
                  },
                ),
              ],
            ),

            TextButton(
              onPressed: () {
                widget.viewModel.refresh();
                widget.viewModel.showFilters.value = false;
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Icon(Icons.done, color: Constants.darkGreyColor, size: 16,),
                  Text('Apply', style: TextStyle(color: Constants.darkGreyColor),),
                ],
              ),
            )
          ],
        );
        

      }
    });
  }
}
