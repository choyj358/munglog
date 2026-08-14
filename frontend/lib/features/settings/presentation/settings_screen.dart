import 'package:flutter/material.dart';
import 'package:frontend/features/pet/presentation/pet_management_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('프로필', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.pets_outlined),
            title: const Text('반려견 관리'),
            subtitle: const Text('반려견 이름과 프로필을 관리해요.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) {
                    return const PetManagementScreen();
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
