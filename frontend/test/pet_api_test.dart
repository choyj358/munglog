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

  test('반려견을 등록하고 서버 응답을 Pet으로 변환한다', () async {
    final client = MockClient((request) async {
      expect(request.method, 'POST');
      expect(
        request.url.toString(),
        'https://api.munglog.test/api/users/1/pets',
      );
      expect(
        request.headers['content-type'],
        'application/json; charset=UTF-8',
      );
      expect(jsonDecode(request.body), {'name': '푸딩'});

      return http.Response(
        jsonEncode({'id': 3, 'name': '푸딩', 'profileImageUrl': null}),
        201,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    final petApi = PetApi(client, baseUrl: 'https://api.munglog.test');

    final pet = await petApi.createPet(userId: '1', name: '푸딩');

    expect(pet.id, '3');
    expect(pet.name, '푸딩');
    expect(pet.profileImageUrl, isNull);
  });
  test('반려견 이름 수정 요청을 보내고 수정된 반려견을 반환한다', () async {
    final client = MockClient((request) async {
      expect(request.method, 'PATCH');
      expect(
        request.url.toString(),
        'https://api.munglog.test/api/users/1/pets/2',
      );
      expect(
        request.headers['content-type'],
        'application/json; charset=UTF-8',
      );
      expect(jsonDecode(request.body), {'name': '마요'});

      return http.Response(
        jsonEncode({'id': 2, 'name': '마요', 'profileImageUrl': null}),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    final petApi = PetApi(client, baseUrl: 'https://api.munglog.test');

    final pet = await petApi.updatePet(userId: '1', petId: '2', name: '마요');

    expect(pet.id, '2');
    expect(pet.name, '마요');
  });

  test('반려견 삭제 요청을 보낸다', () async {
    final client = MockClient((request) async {
      expect(request.method, 'DELETE');
      expect(
        request.url.toString(),
        'https://api.munglog.test/api/users/1/pets/2',
      );

      return http.Response('', 204);
    });

    final petApi = PetApi(client, baseUrl: 'https://api.munglog.test');

    await petApi.deletePet(userId: '1', petId: '2');
  });

  test('삭제된 반려견 복구 요청을 보내고 복구된 반려견을 반환한다', () async {
    final client = MockClient((request) async {
      expect(request.method, 'POST');
      expect(
        request.url.toString(),
        'https://api.munglog.test/api/users/1/pets/2/restore',
      );

      return http.Response(
        jsonEncode({'id': 2, 'name': '마요', 'profileImageUrl': null}),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    final petApi = PetApi(client, baseUrl: 'https://api.munglog.test');

    final pet = await petApi.restorePet(userId: '1', petId: '2');

    expect(pet.id, '2');
    expect(pet.name, '마요');
  });
}
