import 'package:flutter/material.dart';

class LoginChoiceScreen extends StatelessWidget {
  const LoginChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                '로그인 방법을 선택해주세요',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 40),
              OutlinedButton(onPressed: () {}, child: const Text('이메일로 계속하기')),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Google로 계속하기'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: () {}, child: const Text('카카오로 계속하기')),
            ],
          ),
        ),
      ),
    );
  }
}
