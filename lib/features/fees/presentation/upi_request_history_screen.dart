import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/fee_models.dart';
import 'fees_provider.dart';

class UpiRequestHistoryScreen extends ConsumerWidget {
  const UpiRequestHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(myUpiRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(myUpiRequestsProvider),
        child: requestsAsync.when(
          data: (requests) => _buildList(requests),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildList(List<UpiPaymentRequest> requests) {
    if (requests.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No payment requests found', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];
        return _buildRequestCard(req);
      },
    );
  }

  Widget _buildRequestCard(UpiPaymentRequest req) {
    final statusColor = _getStatusColor(req.status);
    final date = DateTime.parse(req.createdAt);
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(date);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${req.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                _buildStatusBadge(req.status, statusColor),
              ],
            ),
            const SizedBox(height: 8),
            Text('Transaction ID: ${req.upiTransactionId}', style: const TextStyle(fontSize: 13, fontFamily: 'monospace')),
            const SizedBox(height: 4),
            Text('Submitted: $formattedDate', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (req.status == 'rejected' && req.rejectedReason != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.danger.withValues(alpha: 0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Reason for Rejection:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.danger)),
                    const SizedBox(height: 4),
                    Text(req.rejectedReason!, style: const TextStyle(fontSize: 13, color: AppColors.danger)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed': return AppColors.success;
      case 'pending': return AppColors.warning;
      case 'rejected': return AppColors.danger;
      default: return AppColors.textSecondary;
    }
  }
}
