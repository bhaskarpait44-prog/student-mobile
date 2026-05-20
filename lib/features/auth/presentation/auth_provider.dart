import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../domain/auth_models.dart';
import '../../../core/api/api_client.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    final user = await _repository.getSavedUser();
    final token = await _repository.getSavedToken();
    state = state.copyWith(user: user, token: token, isLoading: false);
  }

  Future<void> login({
    required String admissionNo,
    required String password,
    required String schoolCode,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.login(
        admissionNo: admissionNo,
        password: password,
        schoolCode: schoolCode,
      );
      state = state.copyWith(
        user: result['user'],
        token: result['token'],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState();
  }
}
