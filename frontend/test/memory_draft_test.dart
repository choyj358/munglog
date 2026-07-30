import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/memory/application/memory_draft.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  test('빈 메모는 null로 정리된다', () {
    final draft = MemoryDraft(
      photos: [XFile('test.jpg')],
      recordDate: DateTime(2026, 7, 30),
      petIds: {'pet-1'},
      memo: '   ',
    );

    expect(draft.memo, isNull);
  });

  test('메모 앞뒤의 불필요한 공백이 제거된다', () {
    final draft = MemoryDraft(
      photos: [XFile('test.jpg')],
      recordDate: DateTime(2026, 7, 30),
      petIds: {'pet-1'},
      memo: '  오늘도 즐거웠다!  ',
    );

    expect(draft.memo, '오늘도 즐거웠다!');
  });

  test('생성된 초안의 사진과 반려견 목록은 외부에서 변경할 수 없다', () {
    final photo = XFile('test.jpg');

    final draft = MemoryDraft(
      photos: [photo],
      recordDate: DateTime(2026, 7, 30),
      petIds: {'pet-1'},
    );

    expect(() {
      draft.photos.add(photo);
    }, throwsUnsupportedError);

    expect(() {
      draft.petIds.add('pet-2');
    }, throwsUnsupportedError);
  });
}
