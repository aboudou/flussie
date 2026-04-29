import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flussie/misc/constants.dart';
import 'package:flussie/viewmodels/drive_details_vm.dart';
import 'package:flussie/viewmodels/drive_list_vm.dart';
import 'package:flussie/views/drive_details_view.dart';
import 'package:flussie/widgets/battery.dart';
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
                        Get.to(() => DriveDetailsView(viewModel: DriveDetailsViewModel(drive: drive, vin: widget.viewModel.vin, coordinates: coordinates)));
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
              Text('filters'.tr, style: TextStyle(color: Constants.darkGreyColor),),
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
                Text('filter_from'.tr),
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
                Text('filter_to'.tr),
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
                  Text('filter_apply'.tr, style: TextStyle(color: Constants.darkGreyColor),),
                ],
              ),
            )
          ],
        );
      }
    });
  }
}
