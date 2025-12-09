import '../../../meter_reading/domain/entities/meter_reading_entity.dart';
import '../../domain/entities/payment_entity.dart';

class MonthlyStatement {
  final int year;
  final int month;
  final double monthlyReadingsCost;
  final double monthlyPayments;
  final double monthlyBalance;
  final List<MeterReadingEntity> readings;
  final List<PaymentEntity> payments;

  MonthlyStatement({
    required this.year,
    required this.month,
    required this.monthlyReadingsCost,
    required this.monthlyPayments,
    required this.monthlyBalance,
    required this.readings,
    required this.payments,
  });

  String get monthKey => "$year-$month";
}
