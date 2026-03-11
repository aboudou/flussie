import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flussie/misc/constants.dart';
import 'package:flussie/services/ui_service.dart';
import 'package:flussie/viewmodels/charge_details_vm.dart';
import 'package:flussie/widgets/battery.dart';
import 'package:flussie/widgets/grid_builder.dart';
import 'package:flussie/widgets/info_row.dart';

class ChargeDetailsView extends StatelessWidget {
  const ChargeDetailsView({super.key, required this.viewModel});

  static const _gridRowHeight = 45.0;
  static const _iconSize = 25.0;

  final ChargeDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Charge details'),
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
                    initialCenter: viewModel.coordinates,
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
                          point: viewModel.coordinates,
                          width: 80,
                          height: 80,
                          child: _stationIcon(UIService().getChargeTypeColor(viewModel.stationType), 30),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4.0,
                    children: [
                      Icon(Icons.bolt, color: UIService().getChargeTypeColor(viewModel.stationType), size: _iconSize),
                      Flexible( 
                        fit: FlexFit.loose,
                        child: Text(viewModel.location, style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 0.0,
                    children: [
                      Container(
                        constraints: BoxConstraints(minHeight: _gridRowHeight, maxHeight: _gridRowHeight),
                        child: InfoRow(icon: Battery(level: viewModel.startingBattery, size: _iconSize), title: viewModel.startBatteryDate, text: viewModel.startBatteryLevel),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: (_iconSize - _iconSize) / 2),
                        child: Icon(Icons.more_vert, size: _iconSize, color: Constants.darkGreyColor,),
                      ),

                      Container(
                        constraints: BoxConstraints(minHeight: _gridRowHeight, maxHeight: _gridRowHeight),
                        child: InfoRow(icon: Battery(level: viewModel.endingBattery, size: _iconSize), title: viewModel.endBatteryDate, text: viewModel.endBatteryLevel),
                      ),

                      SizedBox(height: 16.0),
                      Container(
                        constraints: BoxConstraints(minHeight: _gridRowHeight, maxHeight: _gridRowHeight),
                        child: InfoRow(icon: Icon(Icons.attach_money, size: _iconSize, color: Constants.darkGreyColor), title: "Cost", text: viewModel.cost),
                      ),


                      SizedBox(height: 16.0),
                      GridBuilder(
                        items: [
                          InfoRow(icon: Icon(Icons.speed, size: _iconSize, color: Constants.darkGreyColor), title: "Odometer", text: viewModel.odometer),
                          InfoRow(icon: Icon(Icons.add_road, size: _iconSize, color: Constants.darkGreyColor), title: "Since last charge", text: viewModel.distanceSinceLastCharge),
                        ],
                        rowHeight: _gridRowHeight,
                      ),

                      SizedBox(height: 16.0),
                      GridBuilder(
                        items: [
                          InfoRow(icon: Icon(Icons.ev_station, size: _iconSize, color: Constants.darkGreyColor), title: "Energy used", text: viewModel.energyUsed),
                          InfoRow(icon: UIService().rotatedIcon(Icon(Icons.battery_6_bar, size: _iconSize, color: Constants.darkGreyColor), 90, size: _iconSize), title: "Energy added", text: viewModel.energyAdded),
                        ],
                        rowHeight: _gridRowHeight,
                      ),

                      Container(
                        constraints: BoxConstraints(minHeight: _gridRowHeight, maxHeight: _gridRowHeight),
                        child: InfoRow(icon: Icon(Icons.energy_savings_leaf, size: _iconSize, color: Constants.darkGreyColor), title: "Efficiency", text: viewModel.efficiency),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stationIcon(Color color, double size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),

        Container(
          width: size - 5,
          height: size - 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),

        Icon(
          Icons.bolt, 
          size: size - 10, 
          color: Colors.white),
      ],
    );
  }
    
}
