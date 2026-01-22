class Vehicle {
  final int? id;
  final String? vin;
  final String? idS;
  final String? color;
  final String? state;
  final int? userId;
  final bool? inService;
  final int? vehicleId;
  final String? accessType;
  final int? apiVersion;
  final DriveState? driveState;
  final ChargeState? chargeState;
  final String? displayName;
  final GuiSettings? guiSettings;
  final String? optionCodes;
  final ClimateState? climateState;
  final VehicleState? vehicleState;
  final String? backseatToken;
  final VehicleConfig? vehicleConfig;
  final bool? calendarEnabled;
  final String? backseatTokenUpdatedAt;

  const Vehicle({
    this.id,
    this.vin,
    this.idS,
    this.color,
    this.state,
    this.userId,
    this.inService,
    this.vehicleId,
    this.accessType,
    this.apiVersion,
    this.driveState,
    this.chargeState,
    this.displayName,
    this.guiSettings,
    this.optionCodes,
    this.climateState,
    this.vehicleState,
    this.backseatToken,
    this.vehicleConfig,
    this.calendarEnabled,
    this.backseatTokenUpdatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: (json['id'] as num?)?.toInt(),
      vin: json['vin'] as String?,
      idS: json['id_s'] as String?,
      color: json['color'] as String?,
      state: json['state'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      inService: json['in_service'] as bool?,
      vehicleId: (json['vehicle_id'] as num?)?.toInt(),
      accessType: json['access_type'] as String?,
      apiVersion: (json['api_version'] as num?)?.toInt(),
      driveState: json['drive_state'] == null ? null : DriveState.fromJson(json['drive_state'] as Map<String, dynamic>),
      chargeState: json['charge_state'] == null ? null : ChargeState.fromJson(json['charge_state'] as Map<String, dynamic>),
      displayName: json['display_name'] as String?,
      guiSettings: json['gui_settings'] == null ? null : GuiSettings.fromJson(json['gui_settings'] as Map<String, dynamic>),
      optionCodes: json['option_codes'] as String?,
      climateState: json['climate_state'] == null ? null : ClimateState.fromJson(json['climate_state'] as Map<String, dynamic>),
      vehicleState: json['vehicle_state'] == null ? null : VehicleState.fromJson(json['vehicle_state'] as Map<String, dynamic>),
      backseatToken: json['backseat_token'] as String?,
      vehicleConfig: json['vehicle_config'] == null ? null : VehicleConfig.fromJson(json['vehicle_config'] as Map<String, dynamic>),
      calendarEnabled: json['calendar_enabled'] as bool?,
      backseatTokenUpdatedAt: json['backseat_token_updated_at'] as String?,
    );
  }
}

class DriveState {
  final int? power;
  final int? speed;
  final int? heading;
  final double? latitude;
  final int? gpsAsOf;
  final double? longitude;
  final int? timestamp;
  final String? nativeType;
  final String? shiftState;
  final double? nativeLatitude;
  final double? nativeLongitude;
  final int? nativeLocationSupported;
  final String? activeRouteDestination;
  final int? activeRouteEnergyAtArrival;
  final double? activeRouteLatitude;
  final double? activeRouteLongitude;
  final double? activeRouteMilesToArrival;
  final double? activeRouteMinutesToArrival;
  final int? activeRouteTrafficMinutesDelay;

  const DriveState({
    this.power,
    this.speed,
    this.heading,
    this.latitude,
    this.gpsAsOf,
    this.longitude,
    this.timestamp,
    this.nativeType,
    this.shiftState,
    this.nativeLatitude,
    this.nativeLongitude,
    this.nativeLocationSupported,
    this.activeRouteDestination,
    this.activeRouteEnergyAtArrival,
    this.activeRouteLatitude,
    this.activeRouteLongitude,
    this.activeRouteMilesToArrival,
    this.activeRouteMinutesToArrival,
    this.activeRouteTrafficMinutesDelay,
  });

  factory DriveState.fromJson(Map<String, dynamic> json) {
    return DriveState(
      power: (json['power'] as num?)?.toInt(),
      speed: (json['speed'] as num?)?.toInt(),
      heading: (json['heading'] as num?)?.toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      gpsAsOf: (json['gps_as_of'] as num?)?.toInt(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      timestamp: (json['timestamp'] as num?)?.toInt(),
      nativeType: json['native_type'] as String?,
      shiftState: json['shift_state'] as String?,
      nativeLatitude: (json['native_latitude'] as num?)?.toDouble(),
      nativeLongitude: (json['native_longitude'] as num?)?.toDouble(),
      nativeLocationSupported: (json['native_location_supported'] as num?)?.toInt(),
      activeRouteDestination: json['active_route_destination'] as String?,
      activeRouteEnergyAtArrival: (json['active_route_energy_at_arrival'] as num?)?.toInt(),
      activeRouteLatitude: (json['active_route_latitude'] as num?)?.toDouble(),
      activeRouteLongitude: (json['active_route_longitude'] as num?)?.toDouble(),
      activeRouteMilesToArrival: (json['active_route_miles_to_arrival'] as num?)?.toDouble(),
      activeRouteMinutesToArrival: (json['active_route_minutes_to_arrival'] as num?)?.toDouble(),
      activeRouteTrafficMinutesDelay: (json['active_route_traffic_minutes_delay'] as num?)?.toInt(),
    );
  }
}

class ChargeState {
  final int? timestamp;
  final int? chargeAmps;
  final double? chargeRate;
  final int? batteryLevel;
  final double? batteryRange;
  final int? chargerPower;
  final bool? tripCharging;
  final int? chargerPhases;
  final String? chargingState;
  final int? chargerVoltage;
  final int? chargeLimitSoc;
  final bool? batteryHeaterOn;
  final String? chargePortColor;
  final String? chargePortLatch;
  final String? connChargeCable;
  final double? estBatteryRange;
  final String? fastChargerType;
  final String? fastChargerBrand;
  final double? chargeEnergyAdded;
  final bool? chargeToMaxRange;
  final double? idealBatteryRange;
  final int? timeToFullCharge;
  final int? chargeLimitSocMax;
  final int? chargeLimitSocMin;
  final int? chargeLimitSocStd;
  final bool? fastChargerPresent;
  final int? usableBatteryLevel;
  final bool? chargeEnableRequest;
  final bool? chargePortDoorOpen;
  final int? chargerPilotCurrent;
  final String? preconditioningTimes;
  final int? chargeCurrentRequest;
  final int? chargerActualCurrent;
  final int? minutesToFullCharge;
  final bool? managedChargingActive;
  final String? offPeakChargingTimes;
  final int? offPeakHoursEndTime;
  final bool? preconditioningEnabled;
  final String? scheduledChargingMode;
  final int? chargeMilesAddedIdeal;
  final double? chargeMilesAddedRated;
  final int? maxRangeChargeCounter;
  final bool? notEnoughPowerToHeat;
  final int? scheduledDepartureTime;
  final bool? offPeakChargingEnabled;
  final int? chargeCurrentRequestMax;
  final bool? scheduledChargingPending;
  final bool? userChargeEnableRequest;
  final String? managedChargingStartTime;
  final bool? chargePortColdWeatherMode;
  final int? scheduledChargingStartTime;
  final bool? managedChargingUserCanceled;
  final int? scheduledDepartureTimeMinutes;
  final int? scheduledChargingStartTimeApp;
  final bool? superchargerSessionTripPlanner;
  final double? packCurrent;
  final double? packVoltage;
  final int? moduleTempMin;
  final int? moduleTempMax;
  final double? energyRemaining;
  final double? lifetimeEnergyUsed;

  const ChargeState({
    this.timestamp,
    this.chargeAmps,
    this.chargeRate,
    this.batteryLevel,
    this.batteryRange,
    this.chargerPower,
    this.tripCharging,
    this.chargerPhases,
    this.chargingState,
    this.chargerVoltage,
    this.chargeLimitSoc,
    this.batteryHeaterOn,
    this.chargePortColor,
    this.chargePortLatch,
    this.connChargeCable,
    this.estBatteryRange,
    this.fastChargerType,
    this.fastChargerBrand,
    this.chargeEnergyAdded,
    this.chargeToMaxRange,
    this.idealBatteryRange,
    this.timeToFullCharge,
    this.chargeLimitSocMax,
    this.chargeLimitSocMin,
    this.chargeLimitSocStd,
    this.fastChargerPresent,
    this.usableBatteryLevel,
    this.chargeEnableRequest,
    this.chargePortDoorOpen,
    this.chargerPilotCurrent,
    this.preconditioningTimes,
    this.chargeCurrentRequest,
    this.chargerActualCurrent,
    this.minutesToFullCharge,
    this.managedChargingActive,
    this.offPeakChargingTimes,
    this.offPeakHoursEndTime,
    this.preconditioningEnabled,
    this.scheduledChargingMode,
    this.chargeMilesAddedIdeal,
    this.chargeMilesAddedRated,
    this.maxRangeChargeCounter,
    this.notEnoughPowerToHeat,
    this.scheduledDepartureTime,
    this.offPeakChargingEnabled,
    this.chargeCurrentRequestMax,
    this.scheduledChargingPending,
    this.userChargeEnableRequest,
    this.managedChargingStartTime,
    this.chargePortColdWeatherMode,
    this.scheduledChargingStartTime,
    this.managedChargingUserCanceled,
    this.scheduledDepartureTimeMinutes,
    this.scheduledChargingStartTimeApp,
    this.superchargerSessionTripPlanner,
    this.packCurrent,
    this.packVoltage,
    this.moduleTempMin,
    this.moduleTempMax,
    this.energyRemaining,
    this.lifetimeEnergyUsed,
  });

  factory ChargeState.fromJson(Map<String, dynamic> json) {
    return ChargeState(
      timestamp: (json['timestamp'] as num?)?.toInt(),
      chargeAmps: (json['charge_amps'] as num?)?.toInt(),
      chargeRate: (json['charge_rate'] as num?)?.toDouble(),
      batteryLevel: (json['battery_level'] as num?)?.toInt(),
      batteryRange: (json['battery_range'] as num?)?.toDouble(),
      chargerPower: (json['charger_power'] as num?)?.toInt(),
      tripCharging: json['trip_charging'] as bool?,
      chargerPhases: (json['charger_phases'] as num?)?.toInt(),
      chargingState: json['charging_state'] as String?,
      chargerVoltage: (json['charger_voltage'] as num?)?.toInt(),
      chargeLimitSoc: (json['charge_limit_soc'] as num?)?.toInt(),
      batteryHeaterOn: json['battery_heater_on'] as bool?,
      chargePortColor: json['charge_port_color'] as String?,
      chargePortLatch: json['charge_port_latch'] as String?,
      connChargeCable: json['conn_charge_cable'] as String?,
      estBatteryRange: (json['est_battery_range'] as num?)?.toDouble(),
      fastChargerType: json['fast_charger_type'] as String?,
      fastChargerBrand: json['fast_charger_brand'] as String?,
      chargeEnergyAdded: (json['charge_energy_added'] as num?)?.toDouble(),
      chargeToMaxRange: json['charge_to_max_range'] as bool?,
      idealBatteryRange: (json['ideal_battery_range'] as num?)?.toDouble(),
      timeToFullCharge: (json['time_to_full_charge'] as num?)?.toInt(),
      chargeLimitSocMax: (json['charge_limit_soc_max'] as num?)?.toInt(),
      chargeLimitSocMin: (json['charge_limit_soc_min'] as num?)?.toInt(),
      chargeLimitSocStd: (json['charge_limit_soc_std'] as num?)?.toInt(),
      fastChargerPresent: json['fast_charger_present'] as bool?,
      usableBatteryLevel: (json['usable_battery_level'] as num?)?.toInt(),
      chargeEnableRequest: json['charge_enable_request'] as bool?,
      chargePortDoorOpen: json['charge_port_door_open'] as bool?,
      chargerPilotCurrent: (json['charger_pilot_current'] as num?)?.toInt(),
      preconditioningTimes: json['preconditioning_times'] as String?,
      chargeCurrentRequest: (json['charge_current_request'] as num?)?.toInt(),
      chargerActualCurrent: (json['charger_actual_current'] as num?)?.toInt(),
      minutesToFullCharge: (json['minutes_to_full_charge'] as num?)?.toInt(),
      managedChargingActive: json['managed_charging_active'] as bool?,
      offPeakChargingTimes: json['off_peak_charging_times'] as String?,
      offPeakHoursEndTime: (json['off_peak_hours_end_time'] as num?)?.toInt(),
      preconditioningEnabled: json['preconditioning_enabled'] as bool?,
      scheduledChargingMode: json['scheduled_charging_mode'] as String?,
      chargeMilesAddedIdeal: (json['charge_miles_added_ideal'] as num?)?.toInt(),
      chargeMilesAddedRated: (json['charge_miles_added_rated'] as num?)?.toDouble(),
      maxRangeChargeCounter: (json['max_range_charge_counter'] as num?)?.toInt(),
      notEnoughPowerToHeat: json['not_enough_power_to_heat'] as bool?,
      scheduledDepartureTime: (json['scheduled_departure_time'] as num?)?.toInt(),
      offPeakChargingEnabled: json['off_peak_charging_enabled'] as bool?,
      chargeCurrentRequestMax: (json['charge_current_request_max'] as num?)?.toInt(),
      scheduledChargingPending: json['scheduled_charging_pending'] as bool?,
      userChargeEnableRequest: json['user_charge_enable_request'] as bool?,
      managedChargingStartTime: json['managed_charging_start_time'] as String?,
      chargePortColdWeatherMode: json['charge_port_cold_weather_mode'] as bool?,
      scheduledChargingStartTime: (json['scheduled_charging_start_time'] as num?)?.toInt(),
      managedChargingUserCanceled: json['managed_charging_user_canceled'] as bool?,
      scheduledDepartureTimeMinutes: (json['scheduled_departure_time_minutes'] as num?)?.toInt(),
      scheduledChargingStartTimeApp: (json['scheduled_charging_start_time_app'] as num?)?.toInt(),
      superchargerSessionTripPlanner: json['supercharger_session_trip_planner'] as bool?,
      packCurrent: (json['pack_current'] as num?)?.toDouble(),
      packVoltage: (json['pack_voltage'] as num?)?.toDouble(),
      moduleTempMin: (json['module_temp_min'] as num?)?.toInt(),
      moduleTempMax: (json['module_temp_max'] as num?)?.toInt(),
      energyRemaining: (json['energy_remaining'] as num?)?.toDouble(),
      lifetimeEnergyUsed: (json['lifetime_energy_used'] as num?)?.toDouble(),
    );
  }
}

class GuiSettings {
  final int? timestamp;
  final bool? gui24HourTime;
  final bool? showRangeUnits;
  final String? guiRangeDisplay;
  final String? guiDistanceUnits;
  final String? guiChargeRateUnits;
  final String? guiTemperatureUnits;

  const GuiSettings({
    this.timestamp,
    this.gui24HourTime,
    this.showRangeUnits,
    this.guiRangeDisplay,
    this.guiDistanceUnits,
    this.guiChargeRateUnits,
    this.guiTemperatureUnits,
  });

  factory GuiSettings.fromJson(Map<String, dynamic> json) {
    return GuiSettings(
      timestamp: (json['timestamp'] as num?)?.toInt(),
      gui24HourTime: json['gui_24_hour_time'] as bool?,
      showRangeUnits: json['show_range_units'] as bool?,
      guiRangeDisplay: json['gui_range_display'] as String?,
      guiDistanceUnits: json['gui_distance_units'] as String?,
      guiChargeRateUnits: json['gui_charge_rate_units'] as String?,
      guiTemperatureUnits: json['gui_temperature_units'] as String?,
    );
  }
}

class ClimateState {
  final int? timestamp;
  final int? fanStatus;
  final double? insideTemp;
  final int? defrostMode;
  final double? outsideTemp;
  final bool? isClimateOn;
  final bool? batteryHeater;
  final bool? bioweaponMode;
  final int? maxAvailTemp;
  final int? minAvailTemp;
  final int? seatHeaterLeft;
  final String? hvacAutoRequest;
  final int? seatHeaterRight;
  final bool? isPreconditioning;
  final bool? wiperBladeHeater;
  final String? climateKeeperMode;
  final double? driverTempSetting;
  final int? leftTempDirection;
  final bool? sideMirrorHeaters;
  final bool? isRearDefrosterOn;
  final int? rightTempDirection;
  final bool? isFrontDefrosterOn;
  final int? seatHeaterRearLeft;
  final bool? steeringWheelHeater;
  final double? passengerTempSetting;
  final int? seatHeaterRearRight;
  final bool? batteryHeaterNoPower;
  final bool? isAutoConditioningOn;
  final int? seatHeaterRearCenter;
  final String? cabinOverheatProtection;
  final int? seatHeaterThirdRowLeft;
  final int? seatHeaterThirdRowRight;
  final bool? remoteHeaterControlEnabled;
  final bool? allowCabinOverheatProtection;
  final bool? supportsFanOnlyCabinOverheatProtection;

  const ClimateState({
    this.timestamp,
    this.fanStatus,
    this.insideTemp,
    this.defrostMode,
    this.outsideTemp,
    this.isClimateOn,
    this.batteryHeater,
    this.bioweaponMode,
    this.maxAvailTemp,
    this.minAvailTemp,
    this.seatHeaterLeft,
    this.hvacAutoRequest,
    this.seatHeaterRight,
    this.isPreconditioning,
    this.wiperBladeHeater,
    this.climateKeeperMode,
    this.driverTempSetting,
    this.leftTempDirection,
    this.sideMirrorHeaters,
    this.isRearDefrosterOn,
    this.rightTempDirection,
    this.isFrontDefrosterOn,
    this.seatHeaterRearLeft,
    this.steeringWheelHeater,
    this.passengerTempSetting,
    this.seatHeaterRearRight,
    this.batteryHeaterNoPower,
    this.isAutoConditioningOn,
    this.seatHeaterRearCenter,
    this.cabinOverheatProtection,
    this.seatHeaterThirdRowLeft,
    this.seatHeaterThirdRowRight,
    this.remoteHeaterControlEnabled,
    this.allowCabinOverheatProtection,
    this.supportsFanOnlyCabinOverheatProtection,
  });

  factory ClimateState.fromJson(Map<String, dynamic> json) {
    return ClimateState(
      timestamp: (json['timestamp'] as num?)?.toInt(),
      fanStatus: (json['fan_status'] as num?)?.toInt(),
      insideTemp: (json['inside_temp'] as num?)?.toDouble(),
      defrostMode: (json['defrost_mode'] as num?)?.toInt(),
      outsideTemp: (json['outside_temp'] as num?)?.toDouble(),
      isClimateOn: json['is_climate_on'] as bool?,
      batteryHeater: json['battery_heater'] as bool?,
      bioweaponMode: json['bioweapon_mode'] as bool?,
      maxAvailTemp: (json['max_avail_temp'] as num?)?.toInt(),
      minAvailTemp: (json['min_avail_temp'] as num?)?.toInt(),
      seatHeaterLeft: (json['seat_heater_left'] as num?)?.toInt(),
      hvacAutoRequest: json['hvac_auto_request'] as String?,
      seatHeaterRight: (json['seat_heater_right'] as num?)?.toInt(),
      isPreconditioning: json['is_preconditioning'] as bool?,
      wiperBladeHeater: json['wiper_blade_heater'] as bool?,
      climateKeeperMode: json['climate_keeper_mode'] as String?,
      driverTempSetting: (json['driver_temp_setting'] as num?)?.toDouble(),
      leftTempDirection: (json['left_temp_direction'] as num?)?.toInt(),
      sideMirrorHeaters: json['side_mirror_heaters'] as bool?,
      isRearDefrosterOn: json['is_rear_defroster_on'] as bool?,
      rightTempDirection: (json['right_temp_direction'] as num?)?.toInt(),
      isFrontDefrosterOn: json['is_front_defroster_on'] as bool?,
      seatHeaterRearLeft: (json['seat_heater_rear_left'] as num?)?.toInt(),
      steeringWheelHeater: json['steering_wheel_heater'] as bool?,
      passengerTempSetting: (json['passenger_temp_setting'] as num?)?.toDouble(),
      seatHeaterRearRight: (json['seat_heater_rear_right'] as num?)?.toInt(),
      batteryHeaterNoPower: json['battery_heater_no_power'] as bool?,
      isAutoConditioningOn: json['is_auto_conditioning_on'] as bool?,
      seatHeaterRearCenter: (json['seat_heater_rear_center'] as num?)?.toInt(),
      cabinOverheatProtection: json['cabin_overheat_protection'] as String?,
      seatHeaterThirdRowLeft: (json['seat_heater_third_row_left'] as num?)?.toInt(),
      seatHeaterThirdRowRight: (json['seat_heater_third_row_right'] as num?)?.toInt(),
      remoteHeaterControlEnabled: json['remote_heater_control_enabled'] as bool?,
      allowCabinOverheatProtection: json['allow_cabin_overheat_protection'] as bool?,
      supportsFanOnlyCabinOverheatProtection: json['supports_fan_only_cabin_overheat_protection'] as bool?,
    );
  }
}

class VehicleState {
  final int? df;
  final int? dr;
  final int? ft;
  final int? pf;
  final int? pr;
  final int? rt;
  final bool? locked;
  final double? odometer;
  final int? fdWindow;
  final int? fpWindow;
  final int? rdWindow;
  final int? rpWindow;
  final int? timestamp;
  final int? santaMode;
  final bool? valetMode;
  final int? apiVersion;
  final String? carVersion;
  final MediaState? mediaState;
  final bool? sentryMode;
  final bool? remoteStart;
  final String? vehicleName;
  final String? dashcamState;
  final String? autoparkStyle;
  final bool? homelinkNearby;
  final bool? isUserPresent;
  final SoftwareUpdate? softwareUpdate;
  final SpeedLimitMode? speedLimitMode;
  final double? tpmsPressureFl;
  final double? tpmsPressureFr;
  final double? tpmsPressureRl;
  final double? tpmsPressureRr;
  final String? autoparkStateV2;
  final bool? calendarSupported;
  final String? lastAutoparkError;
  final int? centerDisplayState;
  final bool? remoteStartEnabled;
  final int? homelinkDeviceCount;
  final bool? sentryModeAvailable;
  final bool? remoteStartSupported;
  final bool? smartSummonAvailable;
  final bool? notificationsSupported;
  final bool? parsedCalendarSupported;
  final bool? dashcamClipSaveAvailable;
  final bool? summonStandbyModeEnabled;

  const VehicleState({
    this.df,
    this.dr,
    this.ft,
    this.pf,
    this.pr,
    this.rt,
    this.locked,
    this.odometer,
    this.fdWindow,
    this.fpWindow,
    this.rdWindow,
    this.rpWindow,
    this.timestamp,
    this.santaMode,
    this.valetMode,
    this.apiVersion,
    this.carVersion,
    this.mediaState,
    this.sentryMode,
    this.remoteStart,
    this.vehicleName,
    this.dashcamState,
    this.autoparkStyle,
    this.homelinkNearby,
    this.isUserPresent,
    this.softwareUpdate,
    this.speedLimitMode,
    this.tpmsPressureFl,
    this.tpmsPressureFr,
    this.tpmsPressureRl,
    this.tpmsPressureRr,
    this.autoparkStateV2,
    this.calendarSupported,
    this.lastAutoparkError,
    this.centerDisplayState,
    this.remoteStartEnabled,
    this.homelinkDeviceCount,
    this.sentryModeAvailable,
    this.remoteStartSupported,
    this.smartSummonAvailable,
    this.notificationsSupported,
    this.parsedCalendarSupported,
    this.dashcamClipSaveAvailable,
    this.summonStandbyModeEnabled,
  });

  factory VehicleState.fromJson(Map<String, dynamic> json) {
    return VehicleState(
      df: (json['df'] as num?)?.toInt(),
      dr: (json['dr'] as num?)?.toInt(),
      ft: (json['ft'] as num?)?.toInt(),
      pf: (json['pf'] as num?)?.toInt(),
      pr: (json['pr'] as num?)?.toInt(),
      rt: (json['rt'] as num?)?.toInt(),
      locked: json['locked'] as bool?,
      odometer: (json['odometer'] as num?)?.toDouble(),
      fdWindow: (json['fd_window'] as num?)?.toInt(),
      fpWindow: (json['fp_window'] as num?)?.toInt(),
      rdWindow: (json['rd_window'] as num?)?.toInt(),
      rpWindow: (json['rp_window'] as num?)?.toInt(),
      timestamp: (json['timestamp'] as num?)?.toInt(),
      santaMode: (json['santa_mode'] as num?)?.toInt(),
      valetMode: json['valet_mode'] as bool?,
      apiVersion: (json['api_version'] as num?)?.toInt(),
      carVersion: json['car_version'] as String?,
      mediaState: json['media_state'] == null ? null : MediaState.fromJson(json['media_state'] as Map<String, dynamic>),
      sentryMode: json['sentry_mode'] as bool?,
      remoteStart: json['remote_start'] as bool?,
      vehicleName: json['vehicle_name'] as String?,
      dashcamState: json['dashcam_state'] as String?,
      autoparkStyle: json['autopark_style'] as String?,
      homelinkNearby: json['homelink_nearby'] as bool?,
      isUserPresent: json['is_user_present'] as bool?,
      softwareUpdate: json['software_update'] == null ? null : SoftwareUpdate.fromJson(json['software_update'] as Map<String, dynamic>),
      speedLimitMode: json['speed_limit_mode'] == null ? null : SpeedLimitMode.fromJson(json['speed_limit_mode'] as Map<String, dynamic>),
      tpmsPressureFl: json['tpms_pressure_fl'] as double?,
      tpmsPressureFr: json['tpms_pressure_fr'] as double?,
      tpmsPressureRl: json['tpms_pressure_rl'] as double?,
      tpmsPressureRr: json['tpms_pressure_rr'] as double?,
      autoparkStateV2: json['autopark_state_v2'] as String?,
      calendarSupported: json['calendar_supported'] as bool?,
      lastAutoparkError: json['last_autopark_error'] as String?,
      centerDisplayState: (json['center_display_state'] as num?)?.toInt(),
      remoteStartEnabled: json['remote_start_enabled'] as bool?,
      homelinkDeviceCount: (json['homelink_device_count'] as num?)?.toInt(),
      sentryModeAvailable: json['sentry_mode_available'] as bool?,
      remoteStartSupported: json['remote_start_supported'] as bool?,
      smartSummonAvailable: json['smart_summon_available'] as bool?,
      notificationsSupported: json['notifications_supported'] as bool?,
      parsedCalendarSupported: json['parsed_calendar_supported'] as bool?,
      dashcamClipSaveAvailable: json['dashcam_clip_save_available'] as bool?,
      summonStandbyModeEnabled: json['summon_standby_mode_enabled'] as bool?,
    );
  }
}

class MediaState {
  final bool? remoteControlEnabled;

  const MediaState({this.remoteControlEnabled});

  factory MediaState.fromJson(Map<String, dynamic> json) {
    return MediaState(
      remoteControlEnabled: json['remote_control_enabled'] as bool?,
    );
  }
}

class SoftwareUpdate {
  final String? status;
  final String? version;
  final int? installPerc;
  final int? downloadPerc;
  final int? expectedDurationSec;

  const SoftwareUpdate({
    this.status,
    this.version,
    this.installPerc,
    this.downloadPerc,
    this.expectedDurationSec,
  });

  factory SoftwareUpdate.fromJson(Map<String, dynamic> json) {
    return SoftwareUpdate(
      status: json['status'] as String?,
      version: json['version'] as String?,
      installPerc: (json['install_perc'] as num?)?.toInt(),
      downloadPerc: (json['download_perc'] as num?)?.toInt(),
      expectedDurationSec: (json['expected_duration_sec'] as num?)?.toInt(),
    );
  }
}

class SpeedLimitMode {
  final bool? active;
  final bool? pinCodeSet;
  final int? maxLimitMph;
  final int? minLimitMph;
  final int? currentLimitMph;

  const SpeedLimitMode({
    this.active,
    this.pinCodeSet,
    this.maxLimitMph,
    this.minLimitMph,
    this.currentLimitMph,
  });

  factory SpeedLimitMode.fromJson(Map<String, dynamic> json) {
    return SpeedLimitMode(
      active: json['active'] as bool?,
      pinCodeSet: json['pin_code_set'] as bool?,
      maxLimitMph: (json['max_limit_mph'] as num?)?.toInt(),
      minLimitMph: (json['min_limit_mph'] as num?)?.toInt(),
      currentLimitMph: (json['current_limit_mph'] as num?)?.toInt(),
    );
  }
}

class VehicleConfig {
  final bool? plg;
  final bool? pws;
  final bool? rhd;
  final String? carType;
  final int? seatType;
  final int? timestamp;
  final bool? euVehicle;
  final String? roofColor;
  final int? utcOffset;
  final String? wheelType;
  final String? spoilerType;
  final String? trimBadging;
  final String? driverAssist;
  final String? headlampType;
  final String? exteriorColor;
  final int? rearSeatType;
  final String? rearDriveUnit;
  final String? thirdRowSeats;
  final String? carSpecialType;
  final String? chargePortType;
  final bool? eceRestrictions;
  final String? frontDriveUnit;
  final bool? hasSeatCooling;
  final int? rearSeatHeaters;
  final bool? useRangeBadging;
  final bool? canActuateTrunks;
  final String? efficiencyPackage;
  final bool? hasAirSuspension;
  final bool? hasLudicrousMode;
  final String? interiorTrimType;
  final int? sunRoofInstalled;
  final bool? defaultChargeToMax;
  final bool? motorizedChargePort;
  final bool? dashcamClipSaveSupported;
  final bool? canAcceptNavigationRequests;

  const VehicleConfig({
    this.plg,
    this.pws,
    this.rhd,
    this.carType,
    this.seatType,
    this.timestamp,
    this.euVehicle,
    this.roofColor,
    this.utcOffset,
    this.wheelType,
    this.spoilerType,
    this.trimBadging,
    this.driverAssist,
    this.headlampType,
    this.exteriorColor,
    this.rearSeatType,
    this.rearDriveUnit,
    this.thirdRowSeats,
    this.carSpecialType,
    this.chargePortType,
    this.eceRestrictions,
    this.frontDriveUnit,
    this.hasSeatCooling,
    this.rearSeatHeaters,
    this.useRangeBadging,
    this.canActuateTrunks,
    this.efficiencyPackage,
    this.hasAirSuspension,
    this.hasLudicrousMode,
    this.interiorTrimType,
    this.sunRoofInstalled,
    this.defaultChargeToMax,
    this.motorizedChargePort,
    this.dashcamClipSaveSupported,
    this.canAcceptNavigationRequests,
  });

  factory VehicleConfig.fromJson(Map<String, dynamic> json) {
    return VehicleConfig(
      plg: json['plg'] as bool?,
      pws: json['pws'] as bool?,
      rhd: json['rhd'] as bool?,
      carType: json['car_type'] as String?,
      seatType: (json['seat_type'] as num?)?.toInt(),
      timestamp: (json['timestamp'] as num?)?.toInt(),
      euVehicle: json['eu_vehicle'] as bool?,
      roofColor: json['roof_color'] as String?,
      utcOffset: (json['utc_offset'] as num?)?.toInt(),
      wheelType: json['wheel_type'] as String?,
      spoilerType: json['spoiler_type'] as String?,
      trimBadging: json['trim_badging'] as String?,
      driverAssist: json['driver_assist'] as String?,
      headlampType: json['headlamp_type'] as String?,
      exteriorColor: json['exterior_color'] as String?,
      rearSeatType: (json['rear_seat_type'] as num?)?.toInt(),
      rearDriveUnit: json['rear_drive_unit'] as String?,
      thirdRowSeats: json['third_row_seats'] as String?,
      carSpecialType: json['car_special_type'] as String?,
      chargePortType: json['charge_port_type'] as String?,
      eceRestrictions: json['ece_restrictions'] as bool?,
      frontDriveUnit: json['front_drive_unit'] as String?,
      hasSeatCooling: json['has_seat_cooling'] as bool?,
      rearSeatHeaters: (json['rear_seat_heaters'] as num?)?.toInt(),
      useRangeBadging: json['use_range_badging'] as bool?,
      canActuateTrunks: json['can_actuate_trunks'] as bool?,
      efficiencyPackage: json['efficiency_package'] as String?,
      hasAirSuspension: json['has_air_suspension'] as bool?,
      hasLudicrousMode: json['has_ludicrous_mode'] as bool?,
      interiorTrimType: json['interior_trim_type'] as String?,
      sunRoofInstalled: (json['sun_roof_installed'] as num?)?.toInt(),
      defaultChargeToMax: json['default_charge_to_max'] as bool?,
      motorizedChargePort: json['motorized_charge_port'] as bool?,
      dashcamClipSaveSupported: json['dashcam_clip_save_supported'] as bool?,
      canAcceptNavigationRequests: json['can_accept_navigation_requests'] as bool?,
    );
  }
}
