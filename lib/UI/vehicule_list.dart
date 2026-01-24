import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flussie/misc/constants.dart';
import 'package:flussie/models/location.dart';
import 'package:flussie/models/vehicles.dart';
import 'package:flussie/network/api.dart';
import 'package:flussie/ui/token_setter.dart';

class VehiculeList extends StatefulWidget {
  const VehiculeList({super.key});

  @override
  State<VehiculeList> createState() => _VehiculeListState();
}

class _VehiculeListState extends State<VehiculeList> {
  String _token = '';
  final GetStorage box = GetStorage();
  Function? disposeListen;

  late Future<List<VehicleResult>?> _vehicles;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    disposeListen?.call();
    super.dispose();
  }

  void _checkForToken() {
    setState(() {
      _token = box.read(Constants.tokenStorageKey) ?? '';

      if (_token.isNotEmpty) {
        _vehicles = Api().getVehicles();
      }
    });
  }

  Future<void> _deleteToken() async {
    await box.remove(Constants.tokenStorageKey);
    setState(() {
      _token = '';
    });
  }

  @override
  Widget build(BuildContext context) {

    // Token listener
    disposeListen = box.listen((){ });
    box.listenKey(Constants.tokenStorageKey, (value){
      _checkForToken(); 
    });

    _checkForToken();

    if (_token.isEmpty) {

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
                    Get.to(() => const TokenSetter());
                  },
                ),
              ],
            ),
          ),
        ),
      );

    } else {

      // Token found, show vehicule list (placeholder for now)
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

        _deleteToken();

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
        FutureBuilder<List<VehicleResult>?>(
          future: _vehicles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final vehicles = snapshot.data;

              if (vehicles == null || vehicles.isEmpty) {
                return const Text('No vehicules found.');
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index].vehicle;
                    final vin = vehicle?.vin;

                    final location = Api().getLocation(vin ?? '');

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
                          // TODO: Go to vehicle details page
                          debugPrint('Card tapped.');
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
                                  child: Api().getMapImage(vin ?? ''),
                                ),

                                // Name and details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vehicle?.displayName ?? 'Unknown Vehicle',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      FutureBuilder<Location>(
                                        future: location,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(snapshot.data?.address ?? 'No address available');
                                          } else {
                                            return Text('Loading address...');
                                          }
                                        }
                                      ),                                      
                                    ],
                                  ),
                                ),

                                // Battery level
                                Container(
                                  width: 25,
                                  height: 25,
                                  color: Colors.transparent,
                                  child: _batteryIcon(vehicle?.chargeState?.batteryLevel),
                                ),
                              ],
                            ),
                          ),
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
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