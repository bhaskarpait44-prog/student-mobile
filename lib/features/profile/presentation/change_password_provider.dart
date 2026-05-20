import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/repositories/student_repositories.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(apiClientProvider));
});

class ChangePasswordNotifier extends StateNotifier<AsyncValue<void>> {
  final ProfileRepository _repository;

  ChangePasswordNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final changePasswordProvider = StateNotifierProvider<ChangePasswordNotifier, AsyncValue<void>>((ref) {
  return ChangePasswordNotifier(ref.watch(profileRepositoryProvider));
});
