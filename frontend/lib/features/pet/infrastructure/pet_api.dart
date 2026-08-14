import 'dart:convert';

import 'package:frontend/core/config/app_config.dart';
import 'package:frontend/features/pet/domain/pet.dart';
import 'package:http/http.dart' as http;

class PetApi {
  PetApi(this._client, {this.baseUrl = AppConfig.apiBaseUrl});

  final http.Client _client;
  final String baseUrl;

  Future<List<Pet>> fetchPets({required String userId}) async {
    final uri = Uri.parse('$baseUrl/api/users/$userId/pets');

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        '반려견 목록을 불러오지 못했습니다. '
        '상태 코드: ${response.statusCode}',
      );
    }

    final decodedBody =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

    return decodedBody
        .map((item) => Pet.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Pet> createPet({required String userId, required String name}) async {
    final uri = Uri.parse('$baseUrl/api/users/$userId/pets');

    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 201) {
      throw Exception('반려견을 등록하지 못했습니다. 상태 코드: ${response.statusCode}');
    }

    final decodedBody =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    return Pet.fromJson(decodedBody);
  }

  Future<Pet> updatePet({
    required String userId,
    required String petId,
    required String name,
  }) async {
    final uri = Uri.parse('$baseUrl/api/users/$userId/pets/$petId');

    final response = await _client.patch(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        '반려견 정보를 수정하지 못했습니다. '
        '상태 코드: ${response.statusCode}',
      );
    }

    final decodedBody =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    return Pet.fromJson(decodedBody);
  }

  Future<void> deletePet({
    required String userId,
    required String petId,
  }) async {
    final uri = Uri.parse('$baseUrl/api/users/$userId/pets/$petId');

    final response = await _client.delete(uri);

    if (response.statusCode != 204) {
      throw Exception(
        '반려견을 삭제하지 못했습니다. '
        '상태 코드: ${response.statusCode}',
      );
    }
  }

  Future<Pet> restorePet({
    required String userId,
    required String petId,
  }) async {
    final uri = Uri.parse('$baseUrl/api/users/$userId/pets/$petId/restore');

    final response = await _client.post(uri);

    if (response.statusCode != 200) {
      throw Exception(
        '반려견을 복구하지 못했습니다. '
        '상태 코드: ${response.statusCode}',
      );
    }

    final decodedBody =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    return Pet.fromJson(decodedBody);
  }
}
