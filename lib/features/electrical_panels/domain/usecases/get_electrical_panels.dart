import '../entities/electrical_panel_entity.dart';
import '../repositories/electrical_panels_repository.dart';

class GetElectricalPanelsUseCase {
  final ElectricalPanelRepository repository;
  GetElectricalPanelsUseCase(this.repository);

  Future<List<ElectricalPanelEntity>> call() {
    return repository.getPanels();
  }
}