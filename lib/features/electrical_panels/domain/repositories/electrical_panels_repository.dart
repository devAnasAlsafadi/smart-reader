import '../entities/electrical_panel_entity.dart';

abstract class ElectricalPanelRepository {
  Future<List<ElectricalPanelEntity>> getPanels();
}