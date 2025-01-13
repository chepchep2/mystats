import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mystats/services/auth_service.dart';
import 'package:mystats/widgets/common/custom_button.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton(
                      value: 2025,
                      items: [2024, 2025, 2026].map((year) {
                        return DropdownMenuItem(
                          value: year,
                          child: Text('$year년'),
                        );
                      }).toList(),
                      onChanged: (value) {},
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton(
                      value: 1,
                      underline: const SizedBox(),
                      items:
                          [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].map((month) {
                        return DropdownMenuItem(
                          value: month,
                          child: Text('$month월'),
                        );
                      }).toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              const Spacer(),
              CustomButton(
                backgroundColor: Colors.white,
                text: '로그아웃',
                textColor: Colors.black,
                onPressed: () async {
                  await AuthService().logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
