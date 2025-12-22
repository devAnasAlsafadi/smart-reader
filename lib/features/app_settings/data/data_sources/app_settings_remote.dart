import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/billing_settings_model.dart';

class AppSettingsRemoteDataSource {
  final _doc = FirebaseFirestore
      .instance
      .collection('app_settings')
      .doc('billing');

  Future<BillingSettingsModel> fetch() async {
    final snap = await _doc.get();
    return BillingSettingsModel.fromJson(json :snap.data()!,id: _doc.id);
  }
}