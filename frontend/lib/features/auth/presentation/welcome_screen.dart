import 'package:flutter/material.dart';
import 'package:frontend/features/auth/presentation/login_choice_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(Icons.pets_rounded, size: 72, color: colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                '멍로그',
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              Text(
                '우리 아이와 함께한 오늘을,\n내일도 기억할 수 있도록.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const LoginChoiceScreen(),
                    ),
                  );
                },
                child: const Text('로그인하고 시작하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
