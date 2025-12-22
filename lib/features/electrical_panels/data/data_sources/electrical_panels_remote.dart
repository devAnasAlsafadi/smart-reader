import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/electrical_panel_model.dart';

abstract class ElectricalPanelRemoteDataSource {
  Future<List<ElectricalPanelModel>> getPanels();
}


class ElectricalPanelRemoteDataSourceImpl
    implements ElectricalPanelRemoteDataSource {

  final collection =
  FirebaseFirestore.instance.collection('electricalPanels');

  @override
  Future<List<ElectricalPanelModel>> getPanels() async {
    final snap = await collection.get();

    return snap.docs.map((doc) {
      return ElectricalPanelModel.fromJson(
        doc.id,
        doc.data(),
      );
    }).toList();
  }
}

