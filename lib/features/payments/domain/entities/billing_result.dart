import '../../data/services/billing_summary.dart';
import '../../data/services/monthly_statement.dart';

class BillingResult {
  final BillingSummary summary;
  final List<MonthlyStatement> monthly;

  BillingResult({
    required this.summary,
    required this.monthly,
  });
}
