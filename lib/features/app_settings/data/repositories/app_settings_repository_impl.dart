// features/app_settings/data/repositories/app_settings_repo_impl.dart
import '../../../../core/services/connectivity_service.dart';
import '../../domain/entities/billing_settings_entity.dart';
import '../../domain/repositories/app_settings_repository.dart';
import '../data_sources/app_settings_local.dart';
import '../data_sources/app_settings_remote.dart';


class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppSettingsLocalDataSource local;
  final AppSettingsRemoteDataSource remote;

  AppSettingsRepositoryImpl(this.local, this.remote);

  @override
  Future<BillingSettingsEntity> getSettings() async {
    final localData = await local.get();
    if (localData != null) return localData;

    final remoteData = await remote.fetch();
    await local.save(remoteData);
    return remoteData;
  }

  @override
  Future<void> syncSettings() async {
    final online = await ConnectivityService.isOnline();
    if (!online) return;

    final remoteData = await remote.fetch();
    await local.save(remoteData);
  }
}
