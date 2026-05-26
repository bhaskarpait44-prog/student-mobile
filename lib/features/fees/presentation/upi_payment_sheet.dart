import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/fee_models.dart';
import 'fees_provider.dart';

class UpiPaymentSheet extends ConsumerStatefulWidget {
  final FeeInvoice invoice;
  const UpiPaymentSheet({super.key, required this.invoice});

  @override
  ConsumerState<UpiPaymentSheet> createState() => _UpiPaymentSheetState();
}

class _UpiPaymentSheetState extends ConsumerState<UpiPaymentSheet> {
  Future<void> _launchUpi(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No UPI app found to handle this payment.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch UPI app: $e')),
        );
      }
    }
  }

  void _submit() {
    ref.read(upiPaymentSubmitProvider.notifier).submit(
      invoiceId: widget.invoice.id,
      amount: widget.invoice.pending,
      upiTransactionId: 'PAYMENT_PENDING',
      note: 'Payment initiated via app',
    );
  }

  @override
  Widget build(BuildContext context) {
    final upiInfoAsync = ref.watch(schoolUpiInfoProvider);
    final submitState = ref.watch(upiPaymentSubmitProvider);

    ref.listen(upiPaymentSubmitProvider, (prev, next) {
      if (next is AsyncData && prev is AsyncLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment request submitted successfully!')),
        );
        ref.invalidate(feeInvoicesProvider);
        ref.invalidate(myUpiRequestsProvider);
        Navigator.pop(context);
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );
      }
    });

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Pay via UPI',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Scan the QR or open your preferred UPI app',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                
                upiInfoAsync.when(
                  data: (info) {
                    if (!info.upiEnabled) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.red[100]!),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.report_gmailerrorred_rounded, size: 48, color: Colors.red[400]),
                            const SizedBox(height: 16),
                            const Text(
                              'Payments Under Maintenance',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Online UPI payments are temporarily disabled for maintenance. Please pay at the school office or try again later.',
                              style: TextStyle(color: Colors.grey[700], fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    if (info.upiId.isEmpty) {
                      return const Center(child: Text('School UPI ID not configured.'));
                    }
                    final upiUri = Uri(
                      scheme: 'upi',
                      host: 'pay',
                      queryParameters: {
                        'pa': info.upiId,
                        'pn': info.schoolName,
                        'am': widget.invoice.pending.toStringAsFixed(2),
                        'cu': 'INR',
                        'tn': 'Fee Payment for ${widget.invoice.feeType}',
                      },
                    );
                    final upiUrl = upiUri.toString();
                    
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: QrImageView(
                            data: upiUrl,
                            version: QrVersions.auto,
                            size: 200.0,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Color(0xFF1F2937),
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          info.schoolName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          info.upiId,
                          style: TextStyle(color: Colors.grey[500], fontSize: 13),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 240,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () => _launchUpi(upiUrl),
                            icon: const Icon(Icons.open_in_new, size: 18),
                            label: const Text('Open UPI App'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Text('Error: $err'),
                ),

                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Payable Amount', style: TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        '₹${widget.invoice.pending.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: submitState is AsyncLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: submitState is AsyncLoading
                      ? const SizedBox(
                          height: 20, 
                          width: 20, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('I have paid', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
