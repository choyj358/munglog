import 'package:flutter/material.dart';

class EmailSignupScreen extends StatefulWidget {
  const EmailSignupScreen({super.key});

  @override
  State<EmailSignupScreen> createState() => _EmailSignupScreenState();
}

class _EmailSignupScreenState extends State<EmailSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _signup() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    // TODO: 이후 Spring Boot 회원가입 API를 호출합니다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
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
                  '멍로그를 시작해볼까요?',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text('계정 생성에 필요한 정보를 입력해주세요.'),
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
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    hintText: '8자 이상 입력해주세요.',
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
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '비밀번호 확인',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 한 번 더 입력해주세요.';
                    }

                    if (value != _passwordController.text) {
                      return '비밀번호가 일치하지 않습니다.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(onPressed: _signup, child: const Text('회원가입')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
