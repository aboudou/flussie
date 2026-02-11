import 'package:latlong2/latlong.dart';

import 'package:flussie/enums/charge_type.dart';
import 'package:flussie/models/charge.dart';

class ChargeDetailsViewModel {
  ChargeDetailsViewModel({required this.charge}) {
    _initViewModel();
  }

  final Charge charge;

  LatLng coordinates = LatLng(0, 0);
  ChargeType stationType = ChargeType.standardCharger;

  void _initViewModel() async {
    if (charge.latitude != null && charge.longitude != null) {
      coordinates = LatLng(charge.latitude!, charge.longitude!);
    }

    if (charge.isSupercharger == true) {
      stationType = ChargeType.supercharger;
    } else if (charge.isFastCharger == true) {
      stationType = ChargeType.fastCharger;
    } else {
      stationType = ChargeType.standardCharger;
    }
  }
}
