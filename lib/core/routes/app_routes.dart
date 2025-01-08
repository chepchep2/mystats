import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mystats/views/auth/login_view.dart';
import 'package:mystats/views/home/home_view.dart';
import 'package:mystats/views/splash/splash_view.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashView();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginView();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeView();
      },
    ),
  ],
);
