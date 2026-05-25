import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _txController = TextEditingController();
  final _noteController = TextEditingController();
  bool _showForm = false;

  @override
  void dispose() {
    _txController.dispose();
    _noteController.dispose();
    super.dispose();
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
                  'Pay via UPI QR',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Scan the QR code using any UPI app',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                
                upiInfoAsync.when(
                  data: (info) {
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

                if (!_showForm)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => setState(() => _showForm = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text('I have paid', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                else
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _txController,
                          decoration: InputDecoration(
                            labelText: 'UPI Transaction ID / Ref No.',
                            hintText: 'Enter 12-digit transaction ID',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                            prefixIcon: const Icon(Icons.receipt_long),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter transaction ID';
                            if (value.length < 8) return 'ID too short';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _noteController,
                          decoration: InputDecoration(
                            labelText: 'Note (Optional)',
                            hintText: 'Add a note for the accountant',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                            prefixIcon: const Icon(Icons.note),
                          ),
                          maxLines: 2,
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
                              : const Text('Submit for Confirmation', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(upiPaymentSubmitProvider.notifier).submit(
        invoiceId: widget.invoice.id,
        amount: widget.invoice.pending,
        upiTransactionId: _txController.text,
        note: _noteController.text,
      );
    }
  }
}
