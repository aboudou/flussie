import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'package:flussie/models/charge.dart';
import 'package:flussie/models/drive.dart';
import 'package:flussie/providers/api/api_provider.dart';
import 'package:flussie/providers/storage/storage_provider.dart';
import 'package:flussie/viewmodels/charge_details_vm.dart';
import 'package:flussie/viewmodels/drive_details_vm.dart';
import 'package:flussie/viewmodels/vehicle_tab_view_vm.dart';
import 'package:flussie/views/charge_details_view.dart';
import 'package:flussie/views/drive_details_view.dart';
import 'package:flussie/views/token_setter_view.dart';
import 'package:flussie/views/vehicle_tab_view.dart';

class AppRouter {
  static const tokenSetter = '/token-setter';
  static const vehicleTab = '/vehicle-tab';
  static const chargeDetails = '/charge-details';
  static const driveDetails = '/drive-details';

  static Future<T?>? toTokenSetter<T>(StorageProvider storageProvider) =>
      Get.to(
        () => TokenSetterView(storageProvider: storageProvider),
        routeName: tokenSetter,
      );

  static Future<T?>? toVehicleTab<T>({
    required String vin,
    required String name,
    required ApiProvider apiProvider,
  }) =>
      Get.to(
        () => VehicleTabView(
          viewModel: VehicleTabViewModel(vin: vin, name: name),
          apiProvider: apiProvider,
        ),
        routeName: vehicleTab,
      );

  static Future<T?>? toChargeDetails<T>(Charge charge) =>
      Get.to(
        () => ChargeDetailsView(viewModel: ChargeDetailsViewModel(charge: charge)),
        routeName: chargeDetails,
      );

  static Future<T?>? toDriveDetails<T>({
    required Drive drive,
    required String vin,
    required List<LatLng> coordinates,
  }) =>
      Get.to(
        () => DriveDetailsView(
          viewModel: DriveDetailsViewModel(drive: drive, vin: vin, coordinates: coordinates),
        ),
        routeName: driveDetails,
      );

  static void back<T>({T? result}) => Get.back(result: result);
}
