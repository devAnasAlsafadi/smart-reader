import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/enum/location_mode.dart';
import '../../../../../core/user_session.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../domain/entities/customer_entity.dart';
import '../../blocs/customer_bloc/customer_bloc.dart';
import '../../blocs/customer_bloc/customer_event.dart';

class AddCustomerScreenController {
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final latCtrl = TextEditingController();
  final lngCtrl = TextEditingController();


  LocationMode mode = LocationMode.gps;
  void dispose() {
    nameCtrl.dispose();
    addressCtrl.dispose();
    streetCtrl.dispose();
    latCtrl.dispose();
    lngCtrl.dispose();
  }

  Future<bool> handleLocationPermission(BuildContext context) async {
    // --- 1) Check if Location Services are ON ---
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppSnackBar.error(context, "Location services are disabled.");
      await Geolocator.openLocationSettings();
      return false;
    }

    // --- 2) Check existing permission ---
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // --- 3) Still denied? ---
    if (permission == LocationPermission.denied) {
      AppSnackBar.error(context, "Location permission denied");
      return false;
    }

    // --- 4) Permanently denied ---
    if (permission == LocationPermission.deniedForever) {
      AppSnackBar.error(
          context, "Location permission permanently denied. Enable from Settings.");

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

      AppSnackBar.success(context, "Location captured successfully");
    } catch (e) {
      AppSnackBar.error(context, "Failed to get location: $e");
    }
  }


  void saveCustomer(BuildContext context) {
    if (nameCtrl.text.isEmpty ||
        addressCtrl.text.isEmpty ||
        streetCtrl.text.isEmpty) {
      AppSnackBar.error(context, "Please fill required fields");
      return;
    }

    if (mode == LocationMode.gps &&
        (latCtrl.text.isEmpty || lngCtrl.text.isEmpty)) {
      AppSnackBar.error(context, "Please get location first");
      return;
    }

    final id = const Uuid().v4();
    final lat = double.tryParse(latCtrl.text) ?? 0.0;
    final lng = double.tryParse(lngCtrl.text) ?? 0.0;

    final entity = CustomerEntity(
      id: id,
      userId: UserSession.userId,
      name: nameCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      street: streetCtrl.text.trim(),
      lat: lat,
      lng: lng,
      synced: false
      , isDeleted:false, syncedDelete: false,
    );

    context.read<CustomerBloc>().add(AddCustomerEvent(entity));
  }
}