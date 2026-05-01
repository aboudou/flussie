import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flussie/misc/app_router.dart';
import 'package:flussie/misc/constants.dart';
import 'package:flussie/viewmodels/drive_list_vm.dart';
import 'package:flussie/widgets/battery.dart';
import 'package:flussie/widgets/filters_panel.dart';
import 'package:flussie/widgets/info_row.dart';

class DriveListView extends StatefulWidget {
  const DriveListView({super.key, required this.viewModel});

  final DriveListViewModel viewModel;

  void refresh() {
    viewModel.refresh();
  }

  @override
  State<DriveListView> createState() => _DriveListViewState();
}

class _DriveListViewState extends State<DriveListView> {

  static const _iconSizeRegular = 25.0;
  static const _iconSizeSmall = 16.0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: 
            widget.viewModel.driveList.value.results.isEmpty
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.0,
              children: [
                _filtersPanel(),
                Text(widget.viewModel.errorMessage.isEmpty ? 'drive_list_empty'.tr : widget.viewModel.errorMessage.value),
                Spacer(),
              ],
            ) 
            : ListView.builder(
                itemCount: widget.viewModel.driveList.value.results.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                      // return the header
                      return _filtersPanel();
                  }
                  index -= 1;

                  final drive = widget.viewModel.driveList.value.results[index];
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
                      onTap: () async {
                        final coordinates = await widget.viewModel.getDriveCoordinates(drive);
                        AppRouter.toDriveDetails(drive: drive, vin: widget.viewModel.vin, coordinates: coordinates);
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
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 0.0,
                                      children: [
                                        InfoRow(
                                          icon: Battery(level: drive.startingBattery ?? 0, size: _iconSizeRegular), 
                                          title: widget.viewModel.getDriveStartLocation(drive), 
                                          text: '${widget.viewModel.getStartBatteryLevel(drive)} • ${widget.viewModel.getStartDate(drive)}',
                                          titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                          textStyle: TextStyle(color: Constants.darkGreyColor),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: (_iconSizeRegular - _iconSizeSmall) / 2),
                                          child: Icon(Icons.more_vert, size: _iconSizeSmall, color: Constants.darkGreyColor,),
                                        ),

                                        InfoRow(
                                          icon: Battery(level: drive.endingBattery ?? 0, size: _iconSizeRegular), 
                                          title: widget.viewModel.getDriveEndLocation(drive), 
                                          text: '${widget.viewModel.getEndBatteryLevel(drive)} • ${widget.viewModel.getEndDate(drive)}',
                                          titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                          textStyle: TextStyle(color: Constants.darkGreyColor),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: 16.0,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 4.0,
                                          children: [
                                            Icon(Icons.add_road, color: Constants.darkGreyColor, size: _iconSizeSmall),
                                            Text(widget.viewModel.getDriveDistance(drive), style: TextStyle(color: Constants.darkGreyColor),),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 4.0,
                                          children: [
                                            Icon(Icons.schedule, color: Constants.darkGreyColor, size: _iconSizeSmall),
                                            Text(widget.viewModel.getDriveDuration(drive), style: TextStyle(color: Constants.darkGreyColor),),
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
    );
  }
}
