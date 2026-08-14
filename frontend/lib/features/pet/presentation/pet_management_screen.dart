import 'package:flutter/material.dart';
import 'package:frontend/core/config/app_config.dart';
import 'package:frontend/features/pet/application/pet_state.dart';
import 'package:frontend/features/pet/domain/pet.dart';
import 'package:frontend/features/pet/infrastructure/pet_api.dart';
import 'package:provider/provider.dart';

class PetManagementScreen extends StatelessWidget {
  const PetManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pets = context.watch<PetState>().pets;

    return Scaffold(
      appBar: AppBar(title: const Text('반려견 관리')),
      body: pets.isEmpty
          ? const _EmptyPetView()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: pets.length,
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemBuilder: (context, index) {
                return _PetListItem(pet: pets[index]);
              },
            ),
    );
  }
}

class _PetListItem extends StatelessWidget {
  const _PetListItem({required this.pet});

  final Pet pet;

  Future<void> _showActions(BuildContext context) async {
    final action = await showDialog<_PetAction>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(pet.name),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop(_PetAction.update);
              },
              child: const ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text('이름 수정'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop(_PetAction.delete);
              },
              child: const ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('삭제'),
              ),
            ),
          ],
        );
      },
    );

    if (!context.mounted || action == null) {
      return;
    }

    switch (action) {
      case _PetAction.update:
        await _showUpdateDialog(context);
      case _PetAction.delete:
        await _showDeleteDialog(context);
    }
  }

  Future<void> _showUpdateDialog(BuildContext context) async {
    final controller = TextEditingController(text: pet.name);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) {
        String? errorText;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('이름 수정'),
              content: TextField(
                controller: controller,
                autofocus: true,
                maxLength: 20,
                decoration: InputDecoration(
                  labelText: '반려견 이름',
                  errorText: errorText,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('취소'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = controller.text.trim();

                    if (name.isEmpty) {
                      setDialogState(() {
                        errorText = '반려견 이름을 입력해주세요.';
                      });
                      return;
                    }

                    Navigator.of(context).pop(name);
                  },
                  child: const Text('저장'),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();

    if (!context.mounted || newName == null) {
      return;
    }

    final success = await context.read<PetState>().updatePet(
      petApi: context.read<PetApi>(),
      userId: AppConfig.devUserId,
      petId: pet.id,
      name: newName,
    );

    if (!context.mounted || success) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.read<PetState>().submitErrorMessage ?? '반려견 정보를 수정하지 못했습니다.',
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('반려견 삭제'),
          content: Text(
            '${pet.name}의 프로필을 삭제할까요?\n'
            '기존 추억은 삭제되지 않아요.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );

    if (!context.mounted || shouldDelete != true) {
      return;
    }

    final success = await context.read<PetState>().deletePet(
      petApi: context.read<PetApi>(),
      userId: AppConfig.devUserId,
      petId: pet.id,
    );

    if (!context.mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<PetState>().submitErrorMessage ?? '반려견을 삭제하지 못했습니다.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${pet.name}의 프로필을 삭제했어요.'),
        action: SnackBarAction(
          label: '실행 취소',
          onPressed: () {
            _restorePet(context);
          },
        ),
      ),
    );
  }

  Future<void> _restorePet(BuildContext context) async {
    final success = await context.read<PetState>().restorePet(
      petApi: context.read<PetApi>(),
      userId: AppConfig.devUserId,
      petId: pet.id,
    );

    if (!context.mounted) {
      return;
    }

    final message = success
        ? '${pet.name}의 프로필을 복구했어요.'
        : context.read<PetState>().submitErrorMessage ?? '반려견을 복구하지 못했습니다.';

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      leading: CircleAvatar(child: Text(pet.name.substring(0, 1))),
      title: Text(pet.name, style: Theme.of(context).textTheme.titleMedium),
      subtitle: const Text('프로필을 수정하거나 삭제할 수 있어요.'),
      trailing: const Icon(Icons.more_vert),
      onTap: () {
        _showActions(context);
      },
    );
  }
}

class _EmptyPetView extends StatelessWidget {
  const _EmptyPetView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('등록된 반려견이 없어요.'));
  }
}

enum _PetAction { update, delete }
