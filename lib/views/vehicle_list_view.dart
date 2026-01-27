import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flussie/services/battery_service.dart';
import 'package:flussie/services/image_service.dart';
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
                    final batteryData = BatteryService().getBatteryIcon(batteryLevel);

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
                                  child: vehicleListViewModel.mapImage.value,
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
                                    ImageService().rotatedIcon(
                                      Icon(batteryData.$1, size: batteryData.$2, color: batteryData.$3),
                                      90,
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
}