import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flussie/misc/constants.dart';
import 'package:flussie/services/ui_service.dart';
import 'package:flussie/viewmodels/drive_details_vm.dart';
import 'package:flussie/widgets/grid_builder.dart';
import 'package:flussie/widgets/info_row.dart';

class DriveDetailsView extends StatelessWidget {
  const DriveDetailsView({super.key, required this.viewModel});

  static const _iconSize = 25.0;

  final DriveDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('drive_details_title'.tr),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    initialCameraFit: CameraFit.bounds(
                      bounds: LatLngBounds.fromPoints(viewModel.coordinates),
                      padding: EdgeInsets.all(20.0),
                    ),
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
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: viewModel.coordinates,
                          strokeWidth: 4.0,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: viewModel.coordinates.first,
                          width: _iconSize,
                          height: _iconSize,
                          child: Icon(Icons.location_on, size: _iconSize, color: Constants.darkGreyColor),
                          alignment: Alignment.topCenter,
                        ),
                        Marker(
                          point: viewModel.coordinates.last,
                          width: _iconSize,
                          height: _iconSize,
                          child: Icon(Icons.location_on, size: _iconSize, color: Colors.red),
                          alignment: Alignment.topCenter,
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 0.0,
                    children: [
                      InfoRow(icon: Icon(Icons.location_on, size: _iconSize, color: Constants.darkGreyColor), title: "${viewModel.startDriveDate} • ${viewModel.startBatteryLevel}", text: viewModel.startLocation),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: (_iconSize - _iconSize) / 2),
                        child: Icon(Icons.more_vert, size: _iconSize, color: Constants.darkGreyColor,),
                      ),

                      InfoRow(icon: Icon(Icons.location_on, size: _iconSize, color: Colors.red), title: "${viewModel.endDriveDate} • ${viewModel.endBatteryLevel}", text: viewModel.endLocation),

                      SizedBox(height: 16.0),
                      GridBuilder(
                        items: [
                          InfoRow(icon: Icon(Icons.speed, size: _iconSize, color: Constants.darkGreyColor), title: 'drive_distance'.tr, text: viewModel.driveDistance),
                          InfoRow(icon: Icon(Icons.schedule, size: _iconSize, color: Constants.darkGreyColor), title: 'drive_duration'.tr, text: viewModel.driveDuration),
                        ],
                      ),


                      SizedBox(height: 16.0),
                      GridBuilder(
                        items: [
                          InfoRow(icon: UIService().rotatedIcon(Icon(Icons.battery_3_bar, size: _iconSize, color: Constants.darkGreyColor), 90), title: 'drive_energy_used'.tr, text: viewModel.energyUsed),
                          InfoRow(icon: Icon(Icons.eco_outlined, size: _iconSize, color: Constants.darkGreyColor), title: 'drive_average_energy'.tr, text: viewModel.energyUsedPerKm),
                        ],
                      ),

                      SizedBox(height: 16.0),
                      GridBuilder(
                        items: [
                          InfoRow(icon: Icon(Icons.speed, size: _iconSize, color: Constants.darkGreyColor), title: 'drive_average_speed'.tr, text: viewModel.averageSpeed),
                          InfoRow(icon: Icon(Icons.speed_outlined, size: _iconSize, color: Constants.darkGreyColor), title: 'drive_max_speed'.tr, text: viewModel.maxSpeed),
                        ],
                      ),

                    ],
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }

}