import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flussie/misc/app_router.dart';
import 'package:flussie/misc/constants.dart';
import 'package:flussie/services/ui_service.dart';
import 'package:flussie/viewmodels/charge_list_vm.dart';
import 'package:flussie/widgets/battery.dart';
import 'package:flussie/widgets/filters_panel.dart';

class ChargeListView extends StatefulWidget {
  const ChargeListView({super.key, required this.viewModel});

  final ChargeListViewModel viewModel;

  void refresh() {
    viewModel.refresh();
  }

  @override
  State<ChargeListView> createState() => _ChargeListViewState();
}

class _ChargeListViewState extends State<ChargeListView> {

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
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.0,
              children: [
                _filtersPanel(),
                Text(widget.viewModel.errorMessage.isEmpty ? 'charge_list_empty'.tr : widget.viewModel.errorMessage.value),
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
                        AppRouter.toChargeDetails(charge);
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
                                        Icon(Icons.bolt, color: UIService().getChargeTypeColor(widget.viewModel.getStationType(charge)), size: _iconSizeRegular),
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
                                            Battery(level: charge.startingBattery ?? 0, size: _iconSizeRegular),
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
                                            Battery(level: charge.endingBattery ?? 0, size: _iconSizeRegular),
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
    return FiltersPanel(
      showFilters: widget.viewModel.showFilters,
      startDate: widget.viewModel.startDate,
      endDate: widget.viewModel.endDate,
      onStartDateChanged: (v) => setState(() => widget.viewModel.startDate = v),
      onEndDateChanged: (v) => setState(() => widget.viewModel.endDate = v),
      onApply: widget.viewModel.refresh,
      superchargersOnly: widget.viewModel.superchargersOnly,
      onSuperchargersOnlyChanged: (v) => setState(() => widget.viewModel.superchargersOnly = v),
    );
  }
}
