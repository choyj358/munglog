import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/pet/application/pet_state.dart';
import 'package:frontend/features/pet/infrastructure/pet_api.dart';
import 'package:frontend/features/pet/presentation/pet_onboarding_gate.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(const AlbumHomePreview());
}

class AlbumHomePreview extends StatelessWidget {
  const AlbumHomePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<http.Client>(
          create: (context) => http.Client(),
          dispose: (context, client) => client.close(),
        ),
        Provider<PetApi>(
          create: (context) {
            return PetApi(context.read<http.Client>());
          },
        ),
        ChangeNotifierProvider<PetState>(create: (context) => PetState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const PetOnboardingGate(),
      ),
    );
  }
}
