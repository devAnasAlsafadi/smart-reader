class PaymentEntity {
  final String id;
  final String customerId;
  final double amount;
  final String note;
  final DateTime timestamp;
  final bool synced;
  final bool isDeleted;

  PaymentEntity({
    required this.id,
    required this.customerId,
    required this.amount,
    required this.note,
    required this.timestamp,
    required this.synced,
    required this.isDeleted,
  });

  int get month => timestamp.month;
  int get year => timestamp.year;
  String get monthKey => "${timestamp.year}-${timestamp.month}";
}
