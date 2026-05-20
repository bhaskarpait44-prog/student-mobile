import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/repositories/extra_repositories.dart';
import '../domain/fee_models.dart';

final feesRepositoryProvider = Provider<FeesRepository>((ref) {
  return FeesRepository(ref.watch(apiClientProvider));
});

final feeInvoicesProvider = FutureProvider<List<FeeInvoice>>((ref) async {
  final data = await ref.watch(feesRepositoryProvider).getInvoices();
  return data.map((e) => FeeInvoice.fromJson(e)).toList();
});

final feeSummaryProvider = FutureProvider<FeeSummary>((ref) async {
  final data = await ref.watch(feesRepositoryProvider).getFeeSummary();
  return FeeSummary.fromJson(data);
});
