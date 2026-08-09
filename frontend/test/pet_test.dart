import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/pet/domain/pet.dart';

void main() {
  test('서버 JSON을 반려견 객체로 변환한다', () {
    final json = <String, dynamic>{
      'id': 1,
      'name': '푸딩',
      'profileImageUrl': null,
      'createdAt': '2026-08-06T20:16:10.94931',
    };

    final pet = Pet.fromJson(json);

    expect(pet.id, '1');
    expect(pet.name, '푸딩');
    expect(pet.profileImageUrl, isNull);
  });
}
