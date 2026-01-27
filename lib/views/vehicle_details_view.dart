import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flussie/services/battery_service.dart';
import 'package:flussie/services/image_service.dart';
import 'package:flussie/viewmodels/vehicle_details_vm.dart';

class VehicleDetailsView extends StatefulWidget {
  const VehicleDetailsView({super.key, required this.viewModel});

  final VehicleDetailsViewModel viewModel;

  @override  State<VehicleDetailsView> createState() => _VehicleDetailsViewState();
}

class _VehicleDetailsViewState extends State<VehicleDetailsView> {
  static const _gridRowHeight = 45.0;
  static const _iconSize = 25.0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final batteryData = BatteryService().getBatteryIcon(widget.viewModel.batteryLevel.value, size: _iconSize);
      final batteryIcon = ImageService().rotatedIcon(Icon(batteryData.$1, size: batteryData.$2, color: batteryData.$3), 90, size: _iconSize);

      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // Top map image
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: widget.viewModel.mapImage.value,
              ),
            ),

            Container(
              padding: EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: [
                  // Status section
                  Text(
                    'Status',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),

                  _gridBuilder([
                    _infoRow(Icon(Icons.drive_eta, size: _iconSize), 'State', widget.viewModel.state.value),
                    _infoRow(Icon(Icons.outlet, size: _iconSize), 'Charge Port', widget.viewModel.chargePortState.value),
                  ]),

                  Container(
                    constraints: BoxConstraints(minHeight: _gridRowHeight, maxHeight: _gridRowHeight + 20),
                    child: _infoRow(Icon(Icons.location_on, size: _iconSize), 'Location', widget.viewModel.location.value),
                  ),
                  

                  // Battery section
                  SizedBox(height: 8.0),
                  Text(
                    'Battery',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),

                  _gridBuilder([
                      _infoRow(batteryIcon, 'Level', '${widget.viewModel.batteryLevel.value}%',),
                      _infoRow(batteryIcon, 'Energy', '${widget.viewModel.remainingEnergy.value} kWh'),

                      _infoRow(Icon(Icons.add_road, size: _iconSize), 'Range (estimated)', '${widget.viewModel.batteryRangeIdeal.value} mi'),
                      _infoRow(Icon(Icons.add_road, size: _iconSize), 'Range (real)', '${widget.viewModel.batteryRange.value} mi'),

                      // TODO: Battery health info when available
                  ]),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _infoRow(Widget icon, String title, String text) {
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

  Widget _gridBuilder(List<Widget> items) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: _gridRowHeight,
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