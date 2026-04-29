import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flussie/viewmodels/vehicle_list_vm.dart';
import 'package:flussie/viewmodels/vehicle_tab_view_vm.dart';
import 'package:flussie/views/token_setter_view.dart';
import 'package:flussie/views/vehicle_tab_view.dart';
import 'package:flussie/widgets/battery.dart';

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
    // disposeListen = vehicleListViewModel.addListener((){ });
    // vehicleListViewModel.listenToken((value){
    //   _refreshToken(); 
    // });
    _refreshToken();

    return Obx(() {
      if (!vehicleListViewModel.isLoggedIn.value) {
        // No token found, show button to set token
        return Scaffold(
          appBar: AppBar(
            title: Text('vehicle_list_title'.tr),
          ),

          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text('vehicle_list_no_token'.tr),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('vehicle_list_set_token'.tr),
                    onPressed: () {
                      Get.to(() => const TokenSetterView())
                          ?.then((_) => vehicleListViewModel.getToken());
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
            title: Text('vehicle_list_title'.tr),
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
      tooltip: 'vehicle_list_clear_token_tooltip'.tr,
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('confirm'.tr),
            content: Text('vehicle_list_clear_token_confirm'.tr),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('cancel'.tr),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('vehicle_list_clear_token'.tr),
              ),
            ],
          ),
        );
        if (confirmed != true) return;

        vehicleListViewModel.deleteToken();
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('vehicle_list_token_cleared'.tr)),
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
              ? Text(vehicleListViewModel.errorMessage.isEmpty ? 'vehicle_list_empty'.tr : vehicleListViewModel.errorMessage.value)
              : ListView.builder(
                  itemCount: vehicleListViewModel.vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicleListViewModel.vehicles[index].vehicle;
                    final vin = vehicle?.vin ?? '';
                    final name = vehicle?.displayName ?? 'vehicle_unknown'.tr;
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
                                Obx(() => 
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.memory(
                                      vehicleListViewModel.mapImageBytes.value,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.transparent,
                                          child: const Icon(Icons.location_off, size: 50, color: Colors.red),
                                        );
                                      },
                                    ),
                                  ),
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
                                    Battery(level: batteryLevel ?? 0),
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