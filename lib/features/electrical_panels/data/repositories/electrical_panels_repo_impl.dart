import '../../../../core/services/connectivity_service.dart';
import '../../domain/entities/electrical_panel_entity.dart';
import '../../domain/repositories/electrical_panels_repository.dart';
import '../data_sources/electrical_panels_local.dart';
import '../data_sources/electrical_panels_remote.dart';

class ElectricalPanelRepositoryImpl
    implements ElectricalPanelRepository {

  final ElectricalPanelLocalDataSource local;
  final ElectricalPanelRemoteDataSource remote;

  ElectricalPanelRepositoryImpl(this.local, this.remote);

  @override
  Future<List<ElectricalPanelEntity>> getPanels() async {
    final online = await ConnectivityService.isOnline();

    if (!online) {
      return await local.getAll();
    }

    try {
      final remotePanels = await remote.getPanels();
      print('remotePanels length is  : ${remotePanels.length}');
      await local.saveAll(remotePanels);
      print("last send is  : ${remotePanels.length}");
      return remotePanels;
    } catch (_) {
      print('cacc');
      return await local.getAll();
    }
  }
}
