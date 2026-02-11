import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flussie/services/ui_service.dart';
import 'package:flussie/viewmodels/vehicle_details_vm.dart';
import 'package:flussie/widgets/battery.dart';
import 'package:flussie/widgets/grid_builder.dart';
import 'package:flussie/widgets/info_row.dart';

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
                          child: UIService().rotatedIcon(
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

                  GridBuilder(
                    rowHeight: _gridRowHeight,
                    items: [
                      InfoRow(icon: Icon(Icons.drive_eta, size: _iconSize), title: 'State', text: widget.viewModel.state.value),
                      InfoRow(icon: Icon(Icons.outlet, size: _iconSize), title: 'Charge Port', text: widget.viewModel.chargePortState.value),
                    ]
                  ),

                  Container(
                    constraints: BoxConstraints(minHeight: _gridRowHeight, maxHeight: _gridRowHeight + 20),
                    child: InfoRow(icon: Icon(Icons.location_on, size: _iconSize), title: 'Location', text: widget.viewModel.location.value),
                  ),

                  GridBuilder(
                    rowHeight: _gridRowHeight,
                    items: [
                      InfoRow(icon: Icon(Icons.speed, size: _iconSize), title: 'Odometer', text: widget.viewModel.odometer.value),
                    ]
                  ),


                  // Battery section
                  SizedBox(height: 8.0),
                  Text(
                    'Battery',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),

                  GridBuilder(
                    rowHeight: _gridRowHeight,
                    items: [
                      InfoRow(icon: Battery(level: widget.viewModel.batteryLevel.value), title: 'Level', text: '${widget.viewModel.batteryLevel.value}%'),
                      InfoRow(icon: Battery(level: widget.viewModel.batteryLevel.value), title: 'Energy', text: widget.viewModel.remainingEnergy.value),

                      InfoRow(icon: Icon(Icons.add_road, size: _iconSize), title: 'Range', text: '${widget.viewModel.batteryRange.value} km'),
                      InfoRow(icon: Container(), title: '', text: ''),

                      InfoRow(icon: Icon(Icons.monitor_heart, size: _iconSize), title: 'Battery health', text: widget.viewModel.batteryHealth.value,),
                      InfoRow(icon: Icon(Icons.monitor_heart, size: _iconSize), title: 'Degradation', text: widget.viewModel.batteryDegradation.value),
                  ]),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}