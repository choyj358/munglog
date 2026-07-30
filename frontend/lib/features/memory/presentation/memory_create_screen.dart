import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/features/memory/application/memory_draft.dart';
import 'package:frontend/features/pet/domain/pet.dart';
import 'package:image_picker/image_picker.dart';

class MemoryCreateScreen extends StatefulWidget {
  const MemoryCreateScreen({
    required this.photos,
    required this.pets,
    super.key,
  });

  final List<XFile> photos;
  final List<Pet> pets;

  @override
  State<MemoryCreateScreen> createState() {
    return _MemoryCreateScreenState();
  }
}

class _MemoryCreateScreenState extends State<MemoryCreateScreen> {
  final _memoController = TextEditingController();

  late final List<XFile> _photos;
  late final Set<String> _selectedPetIds;

  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());

  @override
  void initState() {
    super.initState();

    _photos = List.of(widget.photos);

    if (widget.pets.length == 1) {
      _selectedPetIds = {widget.pets.first.id};
    } else {
      _selectedPetIds = {};
    }
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  void _reorderPhoto(int oldIndex, int newIndex) {
    setState(() {
      final photo = _photos.removeAt(oldIndex);
      _photos.insert(newIndex, photo);
    });
  }

  void _removePhoto(int index) {
    if (_photos.length == 1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('기록에는 사진이 한 장 이상 필요해요.')));
      return;
    }

    setState(() {
      _photos.removeAt(index);
    });
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateUtils.dateOnly(DateTime.now()),
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDate = selectedDate;
    });
  }

  void _togglePet(String petId) {
    setState(() {
      if (_selectedPetIds.contains(petId)) {
        _selectedPetIds.remove(petId);
      } else {
        _selectedPetIds.add(petId);
      }
    });
  }

  void _continue() {
    if (_selectedPetIds.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('함께한 반려견을 한 마리 이상 선택해주세요.')));
      return;
    }

    _showMemoDialog();
  }

  Future<void> _showMemoDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('한 줄 메모'),
          content: TextField(
            controller: _memoController,
            maxLength: 500,
            minLines: 2,
            maxLines: 4,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '오늘의 기억을 자유롭게 남겨보세요.',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _memoController.clear();
                Navigator.of(dialogContext).pop();
                _prepareRecord();
              },
              child: const Text('건너뛰기'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _prepareRecord();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _prepareRecord() {
    final draft = MemoryDraft(
      photos: _photos,
      recordDate: _selectedDate,
      petIds: _selectedPetIds,
      memo: _memoController.text,
    );

    // TODO: 기록 저장 API 연결 후 임시 출력 코드를 제거합니다.
    debugPrint('선택한 사진 수: ${draft.photos.length}');
    debugPrint('기록 날짜: ${draft.recordDate}');
    debugPrint('선택한 반려견 ID: ${draft.petIds}');
    debugPrint('메모: ${draft.memo}');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('기록 정보 입력이 완료됐어요.')));
  }

  String get _formattedDate {
    final year = _selectedDate.year;
    final month = _selectedDate.month.toString().padLeft(2, '0');
    final day = _selectedDate.day.toString().padLeft(2, '0');

    return '$year.$month.$day';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('기록 만들기')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildPhotoSection(),
                    const SizedBox(height: 32),
                    _buildDateSection(),
                    const SizedBox(height: 24),
                    _buildPetSection(),
                  ],
                ),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${_photos.length}장의 사진을 선택했어요.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ReorderableListView.builder(
            scrollDirection: Axis.horizontal,
            buildDefaultDragHandles: false,
            itemCount: _photos.length,
            onReorderItem: _reorderPhoto,
            itemBuilder: (context, index) {
              final photo = _photos[index];

              return ReorderableDelayedDragStartListener(
                key: ValueKey(photo.path),
                index: index,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _PhotoPreview(
                    photo: photo,
                    order: index + 1,
                    onDelete: () {
                      _removePhoto(index);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '사진을 길게 누른 뒤 움직이면 순서를 변경할 수 있어요.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('기록 날짜', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _selectDate,
          icon: const Icon(Icons.calendar_today_outlined),
          label: Text(_formattedDate),
        ),
      ],
    );
  }

  Widget _buildPetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('함께한 아이', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.pets.map((pet) {
            return FilterChip(
              label: Text(pet.name),
              selected: _selectedPetIds.contains(pet.id),
              onSelected: (_) {
                _togglePet(pet.id);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(onPressed: _continue, child: const Text('다음')),
      ),
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview({
    required this.photo,
    required this.order,
    required this.onDelete,
  });

  final XFile photo;
  final int order;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 180,
      child: Stack(
        fit: StackFit.expand,
        children: [_buildImage(), _buildOrderNumber(), _buildDeleteButton()],
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: FutureBuilder<Uint8List>(
        future: photo.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!, fit: BoxFit.cover);
          }

          if (snapshot.hasError) {
            return const ColoredBox(
              color: Color(0xFFEAEAEA),
              child: Icon(Icons.broken_image_outlined),
            );
          }

          return const ColoredBox(
            color: Color(0xFFEAEAEA),
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildOrderNumber() {
    return Positioned(
      top: 8,
      left: 8,
      child: CircleAvatar(
        radius: 14,
        backgroundColor: Colors.black54,
        child: Text(
          '$order',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: IconButton.filled(
        onPressed: onDelete,
        icon: const Icon(Icons.close),
        tooltip: '사진 삭제',
      ),
    );
  }
}
