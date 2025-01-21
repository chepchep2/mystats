import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/models/user/user_model.dart';
import 'package:mystats/services/auth_service.dart';

class LoginState {
  final bool isLoading;
  final String? error;
  final UserModel? user;

  LoginState({
    this.isLoading = false,
    this.error,
    this.user,
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
    UserModel? user,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>(
  (ref) {
    final authService = ref.watch(authServiceProvider);
    return LoginViewModel(authService);
  },
);

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthService _authService;

  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginViewModel(this._authService) : super(LoginState());

  void clearFields() {
    idController.clear();
    passwordController.clear();
    state = LoginState();
  }

  Future<bool> login() async {
    if (idController.text.isEmpty || passwordController.text.isEmpty) {
      state = state.copyWith(error: '이메일과 비밀번호를 입력해주세요');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final (token, user) = await _authService.apiService.login(
        idController.text,
        passwordController.text,
      );

      await _authService.saveToken(token);

      state = state.copyWith(
        isLoading: false,
        user: user,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
