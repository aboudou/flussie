import 'package:flutter/material.dart';

import 'package:flussie/viewmodels/vehicle_tab_view_vm.dart';

class VehicleTabView extends StatelessWidget {
  const VehicleTabView({super.key, required this.vin, required this.name});

  final String name;
  final String vin;

  @override
  Widget build(BuildContext context) {
    VehicleTabViewModel vehicleTabViewModel = VehicleTabViewModel(vin: vin, name: name);

    final detailsTab = Center(child: Text('Details view for vehicle ${vehicleTabViewModel.vin}'),);
    final chargesTab = Center(child: Text('Charges view for vehicle ${vehicleTabViewModel.vin}'),);
    final tripsTab = Center(child: Text('Trips view for vehicle ${vehicleTabViewModel.vin}'),);
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(vehicleTabViewModel.name),
          actions: [
            Builder(
              builder: (innerContext) => IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  final int selectedIndex = DefaultTabController.of(innerContext).index;
                  switch (selectedIndex) {
                    case 0:
                      // TODO: Handle details refresh
                      // detailsTab.refresh();
                      break;
                    case 1:
                      // TODO: Handle charges refresh
                      // chargesTab.refresh();
                      break;
                    case 2:
                      // TODO: Handle trips refresh
                      // tripsTab.refresh();
                      break;
                  }
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.electric_car), text: 'Details'),
            Tab(icon: Icon(Icons.ev_station), text: 'Charges'),
            Tab(icon: Icon(Icons.route), text: 'Trips'),
          ],
        ),
        body: TabBarView(
          children: [
            detailsTab,
            chargesTab,
            tripsTab,
          ],
        )
      )
    );
  }
}