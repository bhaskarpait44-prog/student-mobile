import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/fee_models.dart';
import 'fees_provider.dart';

class FeesScreen extends ConsumerWidget {
  const FeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(feeSummaryProvider);
    final invoicesAsync = ref.watch(feeInvoicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Details'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(feeSummaryProvider);
          ref.invalidate(feeInvoicesProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              summaryAsync.when(
                data: (summary) => _buildSummaryHeader(summary),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error: $err'),
              ),
              const SizedBox(height: 24),
              const Text(
                'Fee Invoices',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              invoicesAsync.when(
                data: (invoices) => _buildInvoicesList(invoices),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error: $err'),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryHeader(FeeSummary summary) {
    return Card(
      color: summary.totalPending > 0 ? AppColors.danger : AppColors.success,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Total Pending',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              '₹${summary.totalPending.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Total Paid', '₹${summary.totalPaid.toInt()}'),
                _buildSummaryItem('Next Due', summary.nextDueDate ?? 'N/A'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildInvoicesList(List<FeeInvoice> invoices) {
    if (invoices.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Text('No invoices found.'),
      ));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return _buildInvoiceCard(invoice);
      },
    );
  }

  Widget _buildInvoiceCard(FeeInvoice invoice) {
    final statusColor = _getStatusColor(invoice.status);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(invoice.feeType, style: const TextStyle(fontWeight: FontWeight.bold)),
            _buildStatusBadge(invoice.status, statusColor),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Amount: ₹${invoice.amount.toInt()}'),
            Text('Due Date: ${invoice.dueDate}'),
            if (invoice.pending > 0)
              Text(
                'Pending: ₹${invoice.pending.toInt()}',
                style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w500),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Implement invoice detail view
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid': return AppColors.success;
      case 'partial': return AppColors.warning;
      case 'unpaid': return AppColors.danger;
      case 'overdue': return const Color(0xFF7F1D1D);
      default: return AppColors.textSecondary;
    }
  }
}
