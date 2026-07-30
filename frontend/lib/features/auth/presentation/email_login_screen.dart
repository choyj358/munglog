import 'package:flutter/material.dart';
import 'package:frontend/features/auth/presentation/email_signup_screen.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  void _login() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    // TODO: 이후 Spring Boot 로그인 API를 호출합니다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('이메일 로그인')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  '다시 만나서 반가워요!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text('이메일과 비밀번호를 입력해주세요.'),
                const SizedBox(height: 32),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: '이메일',
                    hintText: 'example@email.com',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';

                    if (email.isEmpty) {
                      return '이메일을 입력해주세요.';
                    }

                    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                    if (!emailPattern.hasMatch(email)) {
                      return '올바른 이메일 형식을 입력해주세요.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final password = value ?? '';

                    if (password.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    }

                    if (password.length < 8) {
                      return '비밀번호는 8자 이상 입력해주세요.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(onPressed: _login, child: const Text('로그인')),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const EmailSignupScreen(),
                      ),
                    );
                  },
                  child: const Text('처음이신가요? 회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
