import 'package:flutter/material.dart';
import 'package:mystats/views/splash/splash_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MyStats',
      home: SplashView(),
    );
  }
}
