import 'package:image_picker/image_picker.dart';

class MemoryDraft {
  MemoryDraft({
    required List<XFile> photos,
    required this.recordDate,
    required Set<String> petIds,
    String? memo,
  }) : photos = List.unmodifiable(photos),
       petIds = Set.unmodifiable(petIds),
       memo = _normalizeMemo(memo);

  final List<XFile> photos;
  final DateTime recordDate;
  final Set<String> petIds;
  final String? memo;

  static String? _normalizeMemo(String? memo) {
    final trimmedMemo = memo?.trim();

    if (trimmedMemo == null || trimmedMemo.isEmpty) {
      return null;
    }

    return trimmedMemo;
  }
}
