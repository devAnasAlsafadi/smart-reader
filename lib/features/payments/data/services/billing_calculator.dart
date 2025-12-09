import 'dart:ffi';

import 'package:smart_reader/core/utils/reading_utils.dart';
import 'package:smart_reader/features/meter_reading/domain/entities/meter_reading_entity.dart';
import 'package:smart_reader/features/payments/domain/entities/payment_entity.dart';

import '../../../../core/constants.dart';
import 'billing_summary.dart';
import 'monthly_statement.dart';

class BillingCalculator {

  BillingSummary calculateSummary(
      List<MeterReadingEntity> readings,
      List<PaymentEntity> payments,
      ) {

    final totalCost = readings.fold<double>(
      0.0,
          (sum, r) {
        return sum + ReadingUtils.calculateCost(r.reading);
      },
    );
    final totalPayments = payments.fold<double>(
      0.0,
          (sum, p) => sum + p.amount,
    );

    return BillingSummary(
      totalReadingsCost: totalCost,
      totalPayments: totalPayments,
      balance: totalCost - totalPayments,
    );
  }

  List<MonthlyStatement> groupByMonth(
      List<MeterReadingEntity> readings,
      List<PaymentEntity> payments,
      ) {
    final Map<String, List<MeterReadingEntity>> readingsMap = {};
    final Map<String, List<PaymentEntity>> paymentsMap = {};

    for (var r in readings) {
      final key = "${r.timestamp.year}-${r.timestamp.month}";
      readingsMap.putIfAbsent(key, () => []);
      readingsMap[key]!.add(r);
    }

    for (var p in payments) {
      final key = "${p.timestamp.year}-${p.timestamp.month}";
      paymentsMap.putIfAbsent(key, () => []);
      paymentsMap[key]!.add(p);
    }

    final allKeys = {...readingsMap.keys, ...paymentsMap.keys};
    final List<MonthlyStatement> result = [];

    for (var key in allKeys) {
      final parts = key.split("-");
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);

      final monthlyReadings = readingsMap[key] ?? [];
      final monthlyPayments = paymentsMap[key] ?? [];

      final readingsCost = monthlyReadings.fold<double>(
        0.0,
            (sum, r) {
          return sum + ReadingUtils.calculateCost(r.reading);
        },
      );

      final paymentAmount = monthlyPayments.fold<double>(
        0.0,
            (sum, p) => sum + p.amount,
      );

      result.add(
        MonthlyStatement(
          year: year,
          month: month,
          monthlyReadingsCost: readingsCost,
          monthlyPayments: paymentAmount,
          monthlyBalance: readingsCost - paymentAmount,
          payments: monthlyPayments,
          readings: monthlyReadings
        ),
      );
    }

    // ترتيب حسب التاريخ (أحدث شهر أول)
    result.sort((a, b) {
      final da = DateTime(a.year, a.month);
      final db = DateTime(b.year, b.month);
      return db.compareTo(da);
    });

    return result;
  }
}
