import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashViewModelProvider = Provider((ref) => SplashViewModel());

class SplashViewModel {
  Future<void> checkAndNavigate(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    // TODO: 실제 로그인 상태 체크 로직 구현
    const isLoggedIn = false;

    if (context.mounted) {
      if (isLoggedIn) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    }
  }
}
