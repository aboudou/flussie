import 'package:latlong2/latlong.dart';

import 'package:flussie/models/charge.dart';

class ChargeDetailsViewModel {
  ChargeDetailsViewModel({required this.charge}) {
    _initViewModel();
  }

  final Charge charge;

  LatLng coordinates = LatLng(0, 0);
  String stationType = 'standardCharger';

  void _initViewModel() async {
    if (charge.latitude != null && charge.longitude != null) {
      coordinates = LatLng(charge.latitude!, charge.longitude!);
    }

    if (charge.isSupercharger == true) {
      stationType = 'supercharger';
    } else if (charge.isFastCharger == true) {
      stationType = 'fastCharger';
    } else {
      stationType = 'standardCharger';
    }
  }
}
