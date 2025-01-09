import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/services/auth_service.dart';

final splashViewModelProvider = Provider((ref) => SplashViewModel(ref));

class SplashViewModel {
  final Ref _ref;
  
  SplashViewModel(this._ref);

  Future<void> checkAndNavigate(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (context.mounted) {
      final authService = _ref.read(authServiceProvider);
      final isLoggedIn = await authService.isLoggedIn();
      
      if (isLoggedIn) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    }
  }
}
