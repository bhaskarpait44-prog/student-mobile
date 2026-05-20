class FeeInvoice {
  final int id;
  final String feeType;
  final double amount;
  final double paid;
  final double pending;
  final String dueDate;
  final String status;

  FeeInvoice({
    required this.id,
    required this.feeType,
    required this.amount,
    required this.paid,
    required this.pending,
    required this.dueDate,
    required this.status,
  });

  factory FeeInvoice.fromJson(Map<String, dynamic> json) {
    return FeeInvoice(
      id: json['id'],
      feeType: json['fee_type'] ?? json['feeType'],
      amount: (json['amount'] as num).toDouble(),
      paid: (json['paid'] as num).toDouble(),
      pending: (json['pending'] as num).toDouble(),
      dueDate: json['due_date'] ?? json['dueDate'],
      status: json['status'],
    );
  }
}

class FeeSummary {
  final double totalPending;
  final double totalPaid;
  final String? nextDueDate;

  FeeSummary({
    required this.totalPending,
    required this.totalPaid,
    this.nextDueDate,
  });

  factory FeeSummary.fromJson(Map<String, dynamic> json) {
    return FeeSummary(
      totalPending: (json['total_pending'] as num? ?? 0).toDouble(),
      totalPaid: (json['total_paid'] as num? ?? 0).toDouble(),
      nextDueDate: json['next_due_date'],
    );
  }
}
