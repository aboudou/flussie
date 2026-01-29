import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: 
            widget.viewModel.chargeList.value.results.isEmpty
            ? Text(widget.viewModel.errorMessage.isEmpty ? 'No charge found.' : widget.viewModel.errorMessage.value)
            : ListView.builder(
                itemCount: widget.viewModel.chargeList.value.results.length,
                itemBuilder: (context, index) {
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
}
