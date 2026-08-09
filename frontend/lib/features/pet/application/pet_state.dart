import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:frontend/features/pet/domain/pet.dart';
import 'package:frontend/features/pet/infrastructure/pet_api.dart';

class PetState extends ChangeNotifier {
  final List<Pet> _pets = [];

  bool _isLoading = false;
  String? _errorMessage;

  UnmodifiableListView<Pet> get pets {
    return UnmodifiableListView(_pets);
  }

  bool get hasPets {
    return _pets.isNotEmpty;
  }

  bool get isLoading {
    return _isLoading;
  }

  String? get errorMessage {
    return _errorMessage;
  }

  void addPet(Pet pet) {
    _pets.add(pet);
    notifyListeners();
  }

  Future<void> loadPets({
    required PetApi petApi,
    required String userId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pets = await petApi.fetchPets(userId: userId);

      _pets
        ..clear()
        ..addAll(pets);
    } catch (error) {
      _errorMessage = '반려견 목록을 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
