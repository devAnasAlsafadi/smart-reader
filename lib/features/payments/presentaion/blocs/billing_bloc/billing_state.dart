import 'package:equatable/equatable.dart';
import '../../../data/services/billing_summary.dart';
import '../../../data/services/monthly_statement.dart';


class BillingState extends Equatable {
  final bool isLoading;
  final BillingSummary? summary;
  final List<MonthlyStatement> monthly;
  final String? error;

  const BillingState({
    this.isLoading = false,
    this.summary,
    this.monthly = const [],
    this.error,
  });

  BillingState copyWith({
    bool? isLoading,
    BillingSummary? summary,
    List<MonthlyStatement>? monthly,
    String? error,
  }) {
    return BillingState(
      isLoading: isLoading ?? this.isLoading,
      summary: summary ?? this.summary,
      monthly: monthly ?? this.monthly,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, summary, monthly, error];
}
