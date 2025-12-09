import 'package:smart_reader/features/payments/data/data_source/payment_local_data_source.dart';
import 'package:smart_reader/features/payments/data/data_source/payment_remote_data_source.dart';
import 'package:smart_reader/features/payments/data/model/payment_model.dart';
import 'package:smart_reader/features/payments/domain/entities/payment_entity.dart';

import '../../../../core/services/connectivity_service.dart';
import '../../domain/repositories/payment_repositories.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentLocalDataSource local;
  final PaymentRemoteDataSource remote;

  PaymentRepositoryImpl(this.local, this.remote,);


  @override
  Future<void> addPayment(PaymentEntity entity) async {
    final model = PaymentModel(
        idHive: entity.id,
        customerIdHive: entity.customerId,
        timestampHive: entity.timestamp,
        amountHive: entity.amount,
        noteHive: entity.note,
        syncedHive: entity.synced,
        isDeletedHive: entity.isDeleted
    );
    print('local adding');

    try {
      await local.addPayment(model);
      print('local added');
    } catch (e) {
      print("LOCAL ADD ERROR: $e");
    }
    final online = await ConnectivityService.isOnline();
    if (!online) return;

    try {

      await remote.addPayment(model.copyWith(synced: true));

      await local.updatePayment(model.copyWith(synced: true,));

    } catch (e) {
      print("Add payment error: $e");

    }
  }

  @override
  Future<void> deletePayment(String id) async {
    final model = await local.getById(id);
    if (model == null) return;


    final online = await ConnectivityService.isOnline();
    if(online){
      try{
        await remote.deletePayment(id);
        await local.deletePayment(id);
      }
      catch(e){}
    }else{
      final updated = model.copyWith(
        isDeleted: true,
      );
      await local.updatePayment(updated);
    }
  }

  @override
  Future<List<PaymentEntity>> getPayments(String customerId) async {

    final online = await ConnectivityService.isOnline();
    if (!online) {
      final all = await local.getPayment(customerId);
      return all.where((r) => !r.isDeleted).toList();
    }
    await syncDeleteOffline(customerId);

    try{
      final remoteList = await remote.getPayments(customerId);
      final localList = await local.getPayment(customerId);

      final localMap = {for (var r in localList) r.id: r};

      for (var remoteR in remoteList) {
        if (!localMap.containsKey(remoteR.id)) {
          await local.addPayment(remoteR);
        }
      }
      final all = await local.getPayment(customerId);
      return all.where((r) => !r.isDeleted).toList();
    }
    catch(e){
      final all = await local.getPayment(customerId);
      return all.where((r) => !r.isDeleted).toList();
    }

  }

  Future<void> syncDeleteOffline(String customerId) async {
    final all = await local.getPayment(customerId);

    final needDelete = all.where(
          (r) => r.isDeleted == true,
    );

    for (var r in needDelete) {
      try {
        await remote.deletePayment(r.id);
        await local.deletePayment(r.id);
      } catch (_) {}
    }
  }

  @override
  Future<void> syncOffline(String customerId) async {
    final online = await ConnectivityService.isOnline();
    if (!online) return;

    final all = await local.getPayment(customerId);

    for (var c in all) {
      if (!c.synced) {
        try {
          final remoteModel = c.copyWith(
            synced: true,
          );
          await remote.addPayment(remoteModel);
          final updatedLocal = c.copyWith(
            synced: true,
          );
          await local.updatePayment(updatedLocal);
        } catch (e) {
          print('error during sync: $e');
        }
      }
    }
  }
}
