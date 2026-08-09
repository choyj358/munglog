import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/pet/infrastructure/pet_api.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('반려견 목록을 요청하고 JSON 응답을 변환한다', () async {
    final client = MockClient((request) async {
      expect(request.method, 'GET');
      expect(
        request.url.toString(),
        'https://api.munglog.test/api/users/1/pets',
      );

      return http.Response(
        jsonEncode([
          {'id': 2, 'name': '마요', 'profileImageUrl': null},
          {'id': 1, 'name': '레오', 'profileImageUrl': null},
        ]),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    final petApi = PetApi(client, baseUrl: 'https://api.munglog.test');

    final pets = await petApi.fetchPets(userId: '1');

    expect(pets.length, 2);
    expect(pets[0].id, '2');
    expect(pets[0].name, '마요');
    expect(pets[1].id, '1');
    expect(pets[1].name, '레오');
  });

  test('서버가 200이 아닌 상태 코드를 반환하면 예외가 발생한다', () async {
    final client = MockClient((request) async {
      return http.Response('', 500);
    });

    final petApi = PetApi(client, baseUrl: 'https://api.munglog.test');

    expect(() => petApi.fetchPets(userId: '1'), throwsA(isA<Exception>()));
  });
}
