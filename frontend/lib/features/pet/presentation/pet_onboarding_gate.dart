import 'package:flutter/material.dart';
import 'package:frontend/features/main/presentation/main_shell.dart';
import 'package:frontend/features/pet/application/pet_state.dart';
import 'package:frontend/features/pet/presentation/pet_create_screen.dart';
import 'package:provider/provider.dart';

class PetOnboardingGate extends StatelessWidget {
  const PetOnboardingGate({super.key});

  @override
  Widget build(BuildContext context) {
    final hasPets = context.watch<PetState>().hasPets;

    if (!hasPets) {
      return const PetCreateScreen();
    }

    return const MainShell();
  }
}
