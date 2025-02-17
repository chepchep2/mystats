import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/models/user/user_model.dart';
import 'package:mystats/providers/auth_provider.dart';

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
    final authNotifier = ref.watch(authProvider.notifier);
    return LoginViewModel(authNotifier);
  },
);

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthNotifier _authNotifier;

  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginViewModel(this._authNotifier) : super(LoginState());

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
      await _authNotifier.login(
        idController.text,
        passwordController.text,
      );

      state = state.copyWith(
        isLoading: false,
        user: _authNotifier.state.user,
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
