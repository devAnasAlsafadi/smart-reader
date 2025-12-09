

import '../../../meter_reading/domain/entities/meter_reading_entity.dart';
import '../../data/services/billing_calculator.dart';

import '../entities/billing_result.dart';
import '../entities/payment_entity.dart';

class CalculateBillingUseCase {
  final BillingCalculator calculator;

  CalculateBillingUseCase(this.calculator);

  Future<BillingResult> call({
    required List<MeterReadingEntity> readings,
    required List<PaymentEntity> payments,
  }) async {
    final summary = calculator.calculateSummary(readings, payments);
    final monthly = calculator.groupByMonth(readings, payments);

    return BillingResult(summary: summary, monthly: monthly);
  }
}

