import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/services/auth_service.dart';

class RegisterState {
  final bool isLoading;
  final String? error;

  RegisterState({
    this.isLoading = false,
    this.error,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final registerViewModelProvider =
    StateNotifierProvider<RegisterViewModel, RegisterState>(
  (ref) => RegisterViewModel(ref.read(authServiceProvider)),
);

class RegisterViewModel extends StateNotifier<RegisterState> {
  RegisterViewModel(this._authService) : super(RegisterState());

  final AuthService _authService;

  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final teamController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    nameController.dispose();
    teamController.dispose();
    super.dispose();
  }

  Future<bool> register() async {
    if (!_validateInputs()) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.apiService.register(
        email: idController.text,
        password: passwordController.text,
        name: nameController.text,
        team: teamController.text.isEmpty ? null : teamController.text,
      );

      await _authService.saveToken(result.$1);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  bool _validateInputs() {
    if (idController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty) {
      state = state.copyWith(error: '필수 항목을 모두 입력해주세요.');
      return false;
    }

    if (!idController.text.contains('@')) {
      state = state.copyWith(error: '올바른 이메일 형식이 아닙니다.');
      return false;
    }

    if (passwordController.text.length < 8) {
      state = state.copyWith(error: '비밀번호는 8자 이상이어야 합니다.');
      return false;
    }

    if (!passwordController.text.contains(RegExp(r'[!@#$%^&*]'))) {
      state = state.copyWith(error: '비밀번호는 특수문자(!@#\$%^&*)를 포함해야 합니다.');
      return false;
    }

    return true;
  }
}
