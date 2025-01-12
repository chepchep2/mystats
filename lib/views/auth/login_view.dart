import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mystats/viewmodels/auth/login_viewmodel.dart';
import 'package:mystats/widgets/common/custom_button.dart';
import 'package:mystats/widgets/common/custom_text_field.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    final loginVM = ref.read(loginViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Center(
                child: FaIcon(
                  FontAwesomeIcons.baseball,
                  size: 100,
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                hint: 'ID를 입력하세요',
                prefixIcon: FontAwesomeIcons.user,
                controller: loginVM.idController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: '비밀번호를 입력하세요',
                prefixIcon: FontAwesomeIcons.lock,
                isPassword: true,
                controller: loginVM.passwordController,
              ),
              if (loginState.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    loginState.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 24),
              CustomButton(
                backgroundColor: Colors.white,
                text: '로그인',
                textColor: Colors.black,
                isLoading: loginState.isLoading,
                onPressed: () async {
                  final success = await loginVM.login();
                  if (success && context.mounted) {
                    context.go('/home');
                  }
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                backgroundColor: Colors.white,
                text: '회원가입',
                textColor: Colors.black,
                onPressed: () {
                  // TODO: 회원가입 화면으로 이동
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
