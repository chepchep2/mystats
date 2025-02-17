import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/models/user/user_model.dart';
import 'package:mystats/services/api_service.dart';
import 'package:mystats/services/auth_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(apiService, authService);
});

class AuthState {
  final bool isAuthenticated;
  final UserModel? user;
  final String? token;

  AuthState({
    this.isAuthenticated = false,
    this.user,
    this.token,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserModel? user,
    String? token,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;
  final AuthService _authService;

  AuthNotifier(this._apiService, this._authService) : super(AuthState()) {
    _initializeAuth();
  }

  Future<void> login(String email, String password) async {
    try {
      final (token, user) = await _apiService.login(email, password);
      await _authService.saveToken(token);
      _apiService.setToken(token);
      state = AuthState(
        isAuthenticated: true,
        user: user,
        token: token,
      );
    } catch (e) {
      logout();
      rethrow;
    }
  }

  Future<void> _initializeAuth() async {
    final token = await _authService.getToken();
    if (token != null) {
      _apiService.setToken(token);
      state = state.copyWith(
        isAuthenticated: true,
        token: token,
      );
    }
  }

  void logout() {
    _apiService.removeToken();
    state = AuthState();
  }
}
