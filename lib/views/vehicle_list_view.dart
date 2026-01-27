import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flussie/viewmodels/vehicle_list_vm.dart';
import 'package:flussie/viewmodels/vehicle_tab_view_vm.dart';
import 'package:flussie/views/token_setter_view.dart';
import 'package:flussie/views/vehicle_tab_view.dart';

class VehiculeListView extends StatefulWidget {
  const VehiculeListView({super.key});

  @override
  State<VehiculeListView> createState() => _VehiculeListViewState();
}

class _VehiculeListViewState extends State<VehiculeListView> {
  // String _token = '';
  final VehiculeListViewModel vehicleListViewModel = VehiculeListViewModel();
  Function? disposeListen;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    disposeListen?.call();
    super.dispose();
  }

  void _refreshToken() {
    setState(() {
      vehicleListViewModel.getToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Token listener
    disposeListen = vehicleListViewModel.addListener((){ });
    vehicleListViewModel.listenToken((value){
      _refreshToken(); 
    });
    _refreshToken();

    return Obx(() {
      if (vehicleListViewModel.token.isEmpty) {
        // No token found, show button to set token
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your vehicules'),
          ),

          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const Text('No Tessie API Token is set.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Set API token'),
                    onPressed: () {
                      Get.to(() => const TokenSetterView());
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        // Token found, show vehicule list
        vehicleListViewModel.refreshVehiclesList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Your vehicules'),
            actions: [
              _logoutIcon(context),
            ],
          ),

          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _vehiculeList(context),
            ),
          ),
        );
      }
    });
  }

  // Logout icon button to clear the token
  Widget _logoutIcon(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Clear API token',
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Do you want to clear the API token?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Clear'),
              ),
            ],
          ),
        );
        if (confirmed != true) return;

        vehicleListViewModel.deleteToken();

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('API token cleared')),
        );
        setState(() {});
      },
    );    
  }

  // Vehicule list
  Widget _vehiculeList(BuildContext context) {
    return Column(
      children: [
        Obx(() => 
          Expanded(
            child: 
              vehicleListViewModel.vehicles.isEmpty
              ? Text(vehicleListViewModel.errorMessage.isEmpty ? 'No vehicle found.' : vehicleListViewModel.errorMessage.value)
              : ListView.builder(
                  itemCount: vehicleListViewModel.vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicleListViewModel.vehicles[index].vehicle;
                    final vin = vehicle?.vin ?? '';
                    final name = vehicle?.displayName ?? 'Unknown Vehicle';
                    final batteryLevel = vehicle?.chargeState?.batteryLevel;

                    vehicleListViewModel.refreshVehicle(vin);

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
                          Get.to(() => VehicleTabView(viewModel: VehicleTabViewModel(vin: vin, name: name)));
                        },
                        child: 
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              spacing: 8.0,
                              children: [
                                // Map image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Obx(() => vehicleListViewModel.mapImage.value),
                                ),

                                // Name and details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Obx(() => Text("${vehicleListViewModel.location}")),
                                    ],
                                  ),
                                ),

                                // Battery level
                                Column(
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      color: Colors.transparent,
                                      transformAlignment: Alignment.center,
                                      transform: Matrix4.rotationZ(
                                        90 * pi / 180,
                                      ),
                                      child: _batteryIcon(batteryLevel),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${batteryLevel ?? 'N/A'}%',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ),
                    );
                  },
                ),
          )
        )
      ],
    );
  }

  Icon _batteryIcon(int? batteryLevel) {
    if (batteryLevel == null) {
      return const Icon(Icons.battery_unknown, size: 25, color: Colors.black);
    }

    // Treat clearly invalid values as alert (keep existing alert behavior)
    if (batteryLevel < 0 || batteryLevel > 100) {
      return const Icon(Icons.battery_alert, size: 25, color: Colors.red);
    }

    // Color by ranges: 0-5 red, 6-20 orange, 21-100 green
    final Color color;
    if (batteryLevel <= 5) {
      color = Colors.red;
    } else if (batteryLevel <= 20) {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }

    // Map percentage 0..100 to bar index 0..6
    int bar = ((batteryLevel * 6) / 100).round();
    if (bar < 0) bar = 0;
    if (bar > 6) bar = 6;

    IconData iconData;
    switch (bar) {
      case 0:
        iconData = Icons.battery_0_bar;
        break;
      case 1:
        iconData = Icons.battery_1_bar;
        break;
      case 2:
        iconData = Icons.battery_2_bar;
        break;
      case 3:
        iconData = Icons.battery_3_bar;
        break;
      case 4:
        iconData = Icons.battery_4_bar;
        break;
      case 5:
        iconData = Icons.battery_5_bar;
        break;
      case 6:
      default:
        iconData = Icons.battery_6_bar;
        break;
    }

    return Icon(iconData, size: 25, color: color);
  }

}