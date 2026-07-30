import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/core/services/photo_picker_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/features/pet/application/pet_state.dart';
import 'package:frontend/features/pet/domain/pet.dart';
import 'package:provider/provider.dart';

class PetCreateScreen extends StatefulWidget {
  const PetCreateScreen({super.key});

  @override
  State<PetCreateScreen> createState() => _PetCreateScreenState();
}

class _PetCreateScreenState extends State<PetCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _photoPickerService = PhotoPickerService();

  XFile? _profilePhoto;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectProfilePhoto() async {
    final photo = await _photoPickerService.pickSingleFromGallery();

    if (photo == null || !mounted) {
      return;
    }

    setState(() {
      _profilePhoto = photo;
    });
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final name = _nameController.text.trim();

    // TODO: 반려견 등록 API 응답으로 받은 실제 ID로 교체합니다.
    final pet = Pet(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      name: name,
    );

    context.read<PetState>().addPet(pet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('반려견 등록')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '함께 기록할 아이를 알려주세요.',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text('이름은 필수이고 프로필 사진은 선택사항이에요.'),
                const SizedBox(height: 32),
                Center(
                  child: _ProfilePhoto(
                    photo: _profilePhoto,
                    onPressed: _selectProfilePhoto,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  maxLength: 20,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: '이름',
                    hintText: '예: 푸딩',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final name = value?.trim() ?? '';

                    if (name.isEmpty) {
                      return '반려견 이름을 입력해주세요.';
                    }

                    return null;
                  },
                  onFieldSubmitted: (_) {
                    _submit();
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(onPressed: _submit, child: const Text('등록하기')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto({required this.photo, required this.onPressed});

  final XFile? photo;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(60),
      child: SizedBox.square(
        dimension: 120,
        child: ClipOval(
          child: photo == null
              ? const ColoredBox(
                  color: Color(0xFFEAEAEA),
                  child: Icon(Icons.add_a_photo_outlined, size: 36),
                )
              : FutureBuilder<Uint8List>(
                  future: photo!.readAsBytes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image.memory(snapshot.data!, fit: BoxFit.cover);
                    }

                    return const ColoredBox(
                      color: Color(0xFFEAEAEA),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
