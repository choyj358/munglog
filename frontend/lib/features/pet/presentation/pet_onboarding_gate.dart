import 'package:flutter/material.dart';
import 'package:frontend/features/main/presentation/main_shell.dart';
import 'package:frontend/features/pet/application/pet_state.dart';
import 'package:frontend/features/pet/infrastructure/pet_api.dart';
import 'package:frontend/features/pet/presentation/pet_create_screen.dart';
import 'package:provider/provider.dart';

class PetOnboardingGate extends StatefulWidget {
  const PetOnboardingGate({super.key});

  @override
  State<PetOnboardingGate> createState() {
    return _PetOnboardingGateState();
  }
}

class _PetOnboardingGateState extends State<PetOnboardingGate> {
  bool _isInitialRequestPending = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPets();
    });
  }

  Future<void> _loadPets() async {
    setState(() {
      _isInitialRequestPending = true;
    });

    await context.read<PetState>().loadPets(
      petApi: context.read<PetApi>(),
      userId: '1',
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isInitialRequestPending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final petState = context.watch<PetState>();

    if (_isInitialRequestPending || petState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (petState.errorMessage != null && !petState.hasPets) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_outlined, size: 48),
                  const SizedBox(height: 16),
                  Text(petState.errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _loadPets,
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (!petState.hasPets) {
      return const PetCreateScreen();
    }

    return const MainShell();
  }
}
