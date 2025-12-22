import 'package:hive/hive.dart';

import '../models/electrical_panel_model.dart';

abstract class ElectricalPanelLocalDataSource {
  Future<void> saveAll(List<ElectricalPanelModel> models);
  Future<List<ElectricalPanelModel>> getAll();
}

class ElectricalPanelLocalDataSourceImpl
    implements ElectricalPanelLocalDataSource {

  final Box<ElectricalPanelModel> box;
  ElectricalPanelLocalDataSourceImpl(this.box);

  @override
  Future<void> saveAll(List<ElectricalPanelModel> models) async {
    await box.clear();
    for (final m in models) {
      await box.put(m.idHive, m);
    }
  }

  @override
  Future<List<ElectricalPanelModel>> getAll() async {
    return box.values.toList();
  }
}