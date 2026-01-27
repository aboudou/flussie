import 'package:flutter/material.dart';

import 'package:flussie/viewmodels/vehicle_tab_view_vm.dart';

class VehicleTabView extends StatelessWidget {
  const VehicleTabView({super.key, required this.viewModel});

  final VehicleTabViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final detailsTab = Center(child: Text('Details view for vehicle ${viewModel.vin}'),);
    final chargesTab = Center(child: Text('Charges view for vehicle ${viewModel.vin}'),);
    final drivesTab = Center(child: Text('Drives view for vehicle ${viewModel.vin}'),);
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(viewModel.name),
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
                      // TODO: Handle drives refresh
                      // drivesTab.refresh();
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
            Tab(icon: Icon(Icons.route), text: 'Drives'),
          ],
        ),
        body: TabBarView(
          children: [
            detailsTab,
            chargesTab,
            drivesTab,
          ],
        )
      )
    );
  }
}