import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mystats/views/auth/login_view.dart';
import 'package:mystats/views/auth/register_view.dart';
import 'package:mystats/views/home/home_view.dart';
import 'package:mystats/views/calendar/calendar_view.dart';
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
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterView();
      },
    ),
    GoRoute(
      path: '/record/add',
      builder: (BuildContext context, GoRouterState state) {
        return const CalendarView();
      },
    )
  ],
);
