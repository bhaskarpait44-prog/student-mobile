class FeeInvoice {
  final int id;
  final String feeType;
  final double amount;
  final double paid;
  final double pending;
  final String dueDate;
  final String status;
  final String? upiLatestStatus;
  final String? upiRejectedReason;
  final String? upiSubmittedAt;

  FeeInvoice({
    required this.id,
    required this.feeType,
    required this.amount,
    required this.paid,
    required this.pending,
    required this.dueDate,
    required this.status,
    this.upiLatestStatus,
    this.upiRejectedReason,
    this.upiSubmittedAt,
  });

  factory FeeInvoice.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return FeeInvoice(
      id: json['id'],
      feeType: json['fee_type_name'] ?? json['fee_type'] ?? json['feeType'],
      amount: toDouble(json['amount_due'] ?? json['amount']),
      paid: toDouble(json['amount_paid'] ?? json['paid']),
      pending: toDouble(json['balance_remaining'] ?? json['pending']),
      dueDate: json['due_date'] ?? json['dueDate'],
      status: json['status'],
      upiLatestStatus: json['upi_latest_status'],
      upiRejectedReason: json['upi_rejected_reason'],
      upiSubmittedAt: json['upi_submitted_at'],
    );
  }
}

class SchoolUpiInfo {
  final String upiId;
  final String schoolName;

  SchoolUpiInfo({required this.upiId, required this.schoolName});

  factory SchoolUpiInfo.fromJson(Map<String, dynamic> json) {
    return SchoolUpiInfo(
      upiId: json['upi_id'] ?? '',
      schoolName: json['school_name'] ?? '',
    );
  }
}

class UpiPaymentRequest {
  final int id;
  final int invoiceId;
  final double amount;
  final String upiTransactionId;
  final String status;
  final String createdAt;
  final String? rejectedReason;

  UpiPaymentRequest({
    required this.id,
    required this.invoiceId,
    required this.amount,
    required this.upiTransactionId,
    required this.status,
    required this.createdAt,
    this.rejectedReason,
  });

  factory UpiPaymentRequest.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return UpiPaymentRequest(
      id: json['id'],
      invoiceId: json['invoice_id'],
      amount: toDouble(json['amount']),
      upiTransactionId: json['upi_transaction_id'],
      status: json['status'],
      createdAt: json['created_at'],
      rejectedReason: json['rejected_reason'],
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
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return FeeSummary(
      totalPending: toDouble(json['total_pending']),
      totalPaid: toDouble(json['total_paid']),
      nextDueDate: json['next_due_date'],
    );
  }
}
