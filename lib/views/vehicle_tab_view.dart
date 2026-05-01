import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flussie/providers/api/api_provider.dart';
import 'package:flussie/viewmodels/charge_list_vm.dart';
import 'package:flussie/viewmodels/drive_list_vm.dart';
import 'package:flussie/viewmodels/vehicle_details_vm.dart';
import 'package:flussie/viewmodels/vehicle_tab_view_vm.dart';
import 'package:flussie/views/charge_list_view.dart';
import 'package:flussie/views/drive_list_view.dart';
import 'package:flussie/views/vehicle_details_view.dart';

class VehicleTabView extends StatefulWidget {
  const VehicleTabView({super.key, required this.viewModel, required ApiProvider apiProvider})
      : _apiProvider = apiProvider;

  final VehicleTabViewModel viewModel;
  final ApiProvider _apiProvider;

  @override
  State<VehicleTabView> createState() => _VehicleTabViewState();
}

class _VehicleTabViewState extends State<VehicleTabView> {
  late final VehicleDetailsViewModel _detailsViewModel;
  late final ChargeListViewModel _chargesViewModel;
  late final DriveListViewModel _drivesViewModel;

  @override
  void initState() {
    super.initState();
    _detailsViewModel = VehicleDetailsViewModel(vin: widget.viewModel.vin, apiProvider: widget._apiProvider);
    _chargesViewModel = ChargeListViewModel(vin: widget.viewModel.vin, apiProvider: widget._apiProvider);
    _drivesViewModel = DriveListViewModel(vin: widget.viewModel.vin, apiProvider: widget._apiProvider);
  }

  @override
  void dispose() {
    _detailsViewModel.dispose();
    _chargesViewModel.dispose();
    _drivesViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.viewModel.name),
          actions: [
            Builder(
              builder: (innerContext) => IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  final int selectedIndex = DefaultTabController.of(innerContext).index;
                  switch (selectedIndex) {
                    case 0:
                      _detailsViewModel.refresh();
                      break;
                    case 1:
                      _chargesViewModel.refresh();
                      break;
                    case 2:
                      _drivesViewModel.refresh();
                      break;
                  }
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.electric_car), text: 'vehicle_tab_details'.tr),
            Tab(icon: Icon(Icons.ev_station), text: 'vehicle_tab_charges'.tr),
            Tab(icon: Icon(Icons.route), text: 'vehicle_tab_drives'.tr),
          ],
        ),
        body: TabBarView(
          children: [
            VehicleDetailsView(viewModel: _detailsViewModel),
            ChargeListView(viewModel: _chargesViewModel),
            DriveListView(viewModel: _drivesViewModel),
          ],
        )
      )
    );
  }
}
