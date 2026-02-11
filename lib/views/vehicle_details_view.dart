import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flussie/services/image_ui_service.dart';
import 'package:flussie/viewmodels/vehicle_details_vm.dart';
import 'package:flussie/widgets/battery.dart';

class VehicleDetailsView extends StatefulWidget {
  const VehicleDetailsView({super.key, required this.viewModel});

  final VehicleDetailsViewModel viewModel;

  void refresh() {
    viewModel.refresh();
  }

  @override  State<VehicleDetailsView> createState() => _VehicleDetailsViewState();
}

class _VehicleDetailsViewState extends State<VehicleDetailsView> {
  static const _gridRowHeight = 45.0;
  static const _iconSize = 25.0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                child: FlutterMap(
                  mapController: MapController(),
                  options: MapOptions(
                    initialCenter: widget.viewModel.coordinates.value,
                    initialZoom: 18.0,
                  ),
                  children: [
                    TileLayer( // Bring your own tiles
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'flussie.app',
                      // And many more recommended properties!
                    ),
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () async => await launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: widget.viewModel.coordinates.value,
                          width: 80,
                          height: 80,
                          child: ImageUIService().rotatedIcon(
                            Icon(Icons.navigation, size: 30, color: Colors.blue),
                            widget.viewModel.heading.value,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),  
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

                  _gridBuilder([
                    _infoRow(Icon(Icons.speed, size: _iconSize), 'Odometer', widget.viewModel.odometer.value),
                  ]),


                  // Battery section
                  SizedBox(height: 8.0),
                  Text(
                    'Battery',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),

                  _gridBuilder([
                      _infoRow(Battery(level: widget.viewModel.batteryLevel.value), 'Level', '${widget.viewModel.batteryLevel.value}%',),
                      _infoRow(Battery(level: widget.viewModel.batteryLevel.value), 'Energy', widget.viewModel.remainingEnergy.value),

                      _infoRow(Icon(Icons.add_road, size: _iconSize), 'Range', '${widget.viewModel.batteryRange.value} km'),
                      _infoRow(Container(), '', ''),

                      _infoRow(Icon(Icons.monitor_heart, size: _iconSize), 'Battery health', widget.viewModel.batteryHealth.value,),
                      _infoRow(Icon(Icons.monitor_heart, size: _iconSize), 'Degradation', widget.viewModel.batteryDegradation.value),
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