// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Third-party
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

// Localization
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

// Core
import 'package:smart_reader/core/enum/location_mode.dart';
import 'package:smart_reader/core/user_session.dart';
import 'package:smart_reader/core/utils/app_snackbar.dart';



// Features – Users
import '../../../../electrical_panels/domain/entities/electrical_panel_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../blocs/user_bloc/user_bloc.dart';
import '../../blocs/user_bloc/user_event.dart';

class AddUserScreenController {

  final nameCtrl = TextEditingController();
  final idNumberCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  final addressCtrl = TextEditingController();
  final streetCtrl = TextEditingController();


  final latCtrl = TextEditingController();
  final lngCtrl = TextEditingController();

  LocationMode mode = LocationMode.gps;

  ElectricalPanelEntity? selectedPanel;


  void dispose() {
    nameCtrl.dispose();
    idNumberCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    streetCtrl.dispose();
    latCtrl.dispose();
    lngCtrl.dispose();
  }



  // ================= Location =================

  Future<bool> handleLocationPermission(BuildContext context) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppSnackBar.error(context, LocaleKeys.location_service_disabled.t);
      await Geolocator.openLocationSettings();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      AppSnackBar.error(context, LocaleKeys.location_permission_denied.t);
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      AppSnackBar.error(
        context,
        LocaleKeys.location_permission_denied_forever.t,
      );
      await Geolocator.openAppSettings();
      return false;
    }

    return true;
  }

  Future<void> getGps(BuildContext context) async {
    if (!await handleLocationPermission(context)) return;

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      latCtrl.text = pos.latitude.toStringAsFixed(6);
      lngCtrl.text = pos.longitude.toStringAsFixed(6);

      AppSnackBar.success(
        context,
        LocaleKeys.location_captured_success.t,
      );
    } catch (e) {
      AppSnackBar.error(
        context,
        "${LocaleKeys.location_failed.t}: $e",
      );
    }
  }

  // ================= Validation =================

  bool _isFormValid(BuildContext context) {
    if (nameCtrl.text.trim().isEmpty ||
        idNumberCtrl.text.trim().isEmpty ||
        phoneCtrl.text.trim().isEmpty ||
        addressCtrl.text.trim().isEmpty ||
        streetCtrl.text.trim().isEmpty) {
      AppSnackBar.error(context, LocaleKeys.fill_required_fields.t);
      return false;
    }

    if (selectedPanel == null) {
      AppSnackBar.error(context, LocaleKeys.select_electrical_panel.t);
      return false;
    }

    if (mode == LocationMode.gps &&
        (latCtrl.text.isEmpty || lngCtrl.text.isEmpty)) {
      AppSnackBar.error(context, LocaleKeys.get_location_first.t);
      return false;
    }

    return true;
  }

  // ================= Save =================

  void saveUser(BuildContext context) {
    if (!_isFormValid(context)) return;

    final entity = UserEntity(
      id: const Uuid().v4(),
      employeeId: EmployeeSession.employeeId,
      name: nameCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      street: streetCtrl.text.trim(),
      lat: double.tryParse(latCtrl.text) ?? 0.0,
      lng: double.tryParse(lngCtrl.text) ?? 0.0,
      createdAt: DateTime.now(),
      electricalPanelId: selectedPanel!.id,
      idNumber: int.parse(idNumberCtrl.text),
      phoneNumber: phoneCtrl.text.trim(),
      synced: false,
      isDeleted: false,
      syncedDelete: false,
    );

    context.read<UserBloc>().add(AddUserEvent(entity));
  }
}
