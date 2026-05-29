import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../domain/auth_models.dart';
import '../../../core/api/api_client.dart';
import '../../../core/services/notification_service.dart';

import '../../../config/app_config.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider), ref);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthNotifier(this._repository, this._ref) : super(AuthState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    try {
      // Load saved IP
      final savedIp = await _repository.getSavedServerIp();
      if (savedIp != null) {
        AppConfig.setServerIp(savedIp);
        _ref.read(serverIpProvider.notifier).state = savedIp;
      }

      final user = await _repository.getSavedUser();
      final token = await _repository.getSavedToken();
      final pin = await _repository.getSavedPin();
      state = state.copyWith(
        user: user,
        token: token,
        storedPin: pin,
        isLoading: false,
      );
      if (token != null) {
        NotificationService.registerToken(token);
      }
    } catch (e) {
      state = state.copyWith(
        user: null,
        token: null,
        storedPin: null,
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.login(
        identifier: identifier,
        password: password,
      );
      state = state.copyWith(
        user: result['user'],
        token: result['token'],
        isLoading: false,
      );
      if (result['token'] != null) {
        NotificationService.registerToken(result['token']);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> setPin(String pin) async {
    await _repository.savePin(pin);
    state = state.copyWith(storedPin: pin, isPinAuthenticated: true);
  }

  bool verifyPin(String pin) {
    if (state.storedPin == pin) {
      state = state.copyWith(isPinAuthenticated: true);
      return true;
    }
    return false;
  }

  Future<void> updateServerIp(String ip) async {
    await _repository.saveServerIp(ip);
    AppConfig.setServerIp(ip);
    _ref.read(serverIpProvider.notifier).state = ip;
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState();
  }
}
