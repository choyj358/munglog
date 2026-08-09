import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/pet/application/pet_state.dart';
import 'package:frontend/features/pet/infrastructure/pet_api.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('반려견 목록을 불러와 상태에 저장한다', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode([
          {'id': 2, 'name': '마요', 'profileImageUrl': null},
          {'id': 1, 'name': '레오', 'profileImageUrl': null},
        ]),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    final petApi = PetApi(client);
    final petState = PetState();

    final loadFuture = petState.loadPets(petApi: petApi, userId: '1');

    expect(petState.isLoading, isTrue);
    expect(petState.errorMessage, isNull);

    await loadFuture;

    expect(petState.isLoading, isFalse);
    expect(petState.errorMessage, isNull);
    expect(petState.pets, hasLength(2));
    expect(petState.pets[0].name, '마요');
    expect(petState.pets[1].name, '레오');
  });

  test('반려견 목록 요청이 실패하면 오류 상태를 저장한다', () async {
    final client = MockClient((request) async {
      return http.Response('', 500);
    });

    final petApi = PetApi(client);
    final petState = PetState();

    await petState.loadPets(petApi: petApi, userId: '1');

    expect(petState.isLoading, isFalse);
    expect(petState.errorMessage, '반려견 목록을 불러오지 못했습니다.');
    expect(petState.pets, isEmpty);
  });
}
