import 'package:flutter/material.dart';

import 'package:flussie/viewmodels/vehicle_tab_view_vm.dart';

class VehicleTabView extends StatelessWidget {
  const VehicleTabView({super.key, required this.vin, required this.name});

  final String name;
  final String vin;

  @override
  Widget build(BuildContext context) {
    VehicleTabViewModel vehicleTabViewModel = VehicleTabViewModel(vin: vin, name: name);
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text(vehicleTabViewModel.name)),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.electric_car), text: 'Details'),
            Tab(icon: Icon(Icons.ev_station), text: 'Charges'),
            Tab(icon: Icon(Icons.route), text: 'Trips'),
          ],
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Details view for vehicle ${vehicleTabViewModel.vin}')),
            Center(child: Text('Charges view for vehicle ${vehicleTabViewModel.vin}')),
            Center(child: Text('Trips view for vehicle ${vehicleTabViewModel.vin}')),
          ],
        )
      )
    );
  }
}