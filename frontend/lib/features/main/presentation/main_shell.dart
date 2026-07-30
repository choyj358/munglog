import 'package:flutter/material.dart';
import 'package:frontend/features/album/presentation/album_home_screen.dart';
import 'package:frontend/core/services/photo_picker_service.dart';
import 'package:frontend/features/memory/presentation/memory_create_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/features/pet/application/pet_state.dart';
import 'package:provider/provider.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _photoPickerService = PhotoPickerService();
  int _selectedIndex = 0;

  static const _titles = ['멍로그', '지도', '추억', '설정'];

  static const _pages = [
    AlbumHomeScreen(),
    _PreparingPage(message: '지도 화면을 준비하고 있어요.'),
    _PreparingPage(message: '추억 화면을 준비하고 있어요.'),
    _PreparingPage(message: '설정 화면을 준비하고 있어요.'),
  ];

  void _selectDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showPhotoSourceDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('사진 추가'),
          content: const Text('사진을 가져올 방법을 선택해주세요.'),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _pickFromGallery();
              },
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('갤러리'),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _takePhoto();
              },
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('카메라'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickFromGallery() async {
    final result = await _photoPickerService.pickFromGallery();

    if (!mounted) {
      return;
    }

    if (result.exceededLimit) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('사진은 최대 10장까지 선택할 수 있어요.')));
    }

    _openMemoryCreateScreen(result.photos);
  }

  Future<void> _takePhoto() async {
    final photos = await _photoPickerService.takePhoto();

    _openMemoryCreateScreen(photos);
  }

  void _openMemoryCreateScreen(List<XFile> photos) {
    if (photos.isEmpty || !mounted) {
      return;
    }

    final pets = context.read<PetState>().pets.toList();

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => MemoryCreateScreen(photos: photos, pets: pets),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _showPhotoSourceDialog,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectDestination,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: '사진첩',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: '지도',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: '추억',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}

class _PreparingPage extends StatelessWidget {
  const _PreparingPage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
