import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mystats/viewmodels/auth/register_viewmodel.dart';
import 'package:mystats/widgets/common/custom_button.dart';
import 'package:mystats/widgets/common/custom_text_field.dart';

class RegisterView extends ConsumerWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerViewModelProvider);
    final registerVM = ref.read(registerViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: FaIcon(
                  FontAwesomeIcons.baseball,
                  size: 100,
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                hint: '이메일을 입력하세요',
                prefixIcon: FontAwesomeIcons.envelope,
                controller: registerVM.idController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: '비밀번호를 입력하세요',
                prefixIcon: FontAwesomeIcons.lock,
                isPassword: true,
                controller: registerVM.passwordController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: '이름을 입력하세요',
                prefixIcon: FontAwesomeIcons.user,
                controller: registerVM.nameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: '팀을 입력하세요 (선택사항)',
                prefixIcon: FontAwesomeIcons.users,
                controller: registerVM.teamController,
              ),
              if (registerState.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    registerState.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 24),
              CustomButton(
                backgroundColor: Colors.white,
                text: '회원가입',
                textColor: Colors.black,
                isLoading: registerState.isLoading,
                onPressed: () async {
                  final success = await registerVM.register();
                  if (success && context.mounted) {
                    context.go('/home');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
