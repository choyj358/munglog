import 'dart:convert';

import 'package:frontend/features/pet/domain/pet.dart';
import 'package:http/http.dart' as http;

class PetApi {
  PetApi(this._client, {this.baseUrl = 'http://localhost:8080'});

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
}
