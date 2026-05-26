import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/repositories/extra_repositories.dart';
import '../domain/fee_models.dart';

final feesRepositoryProvider = Provider<FeesRepository>((ref) {
  return FeesRepository(ref.watch(apiClientProvider));
});

final feeInvoicesProvider = FutureProvider<List<FeeInvoice>>((ref) async {
  final data = await ref.watch(feesRepositoryProvider).getInvoices();
  final list = (data['invoices'] as List? ?? []);
  return list.map((e) => FeeInvoice.fromJson(e)).toList();
});

final feeSummaryProvider = FutureProvider<FeeSummary>((ref) async {
  final data = await ref.watch(feesRepositoryProvider).getFeeSummary();
  return FeeSummary.fromJson(data);
});

final schoolUpiInfoProvider = FutureProvider.autoDispose<SchoolUpiInfo>((ref) async {
  final data = await ref.watch(feesRepositoryProvider).getSchoolUpiInfo();
  return SchoolUpiInfo.fromJson(data);
});

final myUpiRequestsProvider = FutureProvider<List<UpiPaymentRequest>>((ref) async {
  final list = await ref.watch(feesRepositoryProvider).getMyUpiRequests();
  return list.map((e) => UpiPaymentRequest.fromJson(e)).toList();
});

class UpiPaymentNotifier extends StateNotifier<AsyncValue<void>> {
  final FeesRepository _repository;
  UpiPaymentNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> submit({
    required int invoiceId,
    required double amount,
    required String upiTransactionId,
    String? note,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.submitUpiPaymentRequest(
        invoiceId: invoiceId,
        amount: amount,
        upiTransactionId: upiTransactionId,
        note: note,
      );
      state = const AsyncValue.data(null);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }
}

final upiPaymentSubmitProvider = StateNotifierProvider<UpiPaymentNotifier, AsyncValue<void>>((ref) {
  return UpiPaymentNotifier(ref.watch(feesRepositoryProvider));
});
