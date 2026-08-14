import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:frontend/features/pet/domain/pet.dart';
import 'package:frontend/features/pet/infrastructure/pet_api.dart';

class PetState extends ChangeNotifier {
  final List<Pet> _pets = [];

  bool _isLoading = false;
  String? _errorMessage;

  bool _isSubmitting = false;
  String? _submitErrorMessage;

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

  bool get isSubmitting {
    return _isSubmitting;
  }

  String? get submitErrorMessage {
    return _submitErrorMessage;
  }

  void addPet(Pet pet) {
    _pets.add(pet);
    notifyListeners();
  }

  Future<bool> createPet({
    required PetApi petApi,
    required String userId,
    required String name,
  }) async {
    _isSubmitting = true;
    _submitErrorMessage = null;
    notifyListeners();

    try {
      final pet = await petApi.createPet(userId: userId, name: name);

      _pets.add(pet);
      return true;
    } catch (error) {
      _submitErrorMessage = '반려견을 등록하지 못했습니다.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> updatePet({
    required PetApi petApi,
    required String userId,
    required String petId,
    required String name,
  }) async {
    _isSubmitting = true;
    _submitErrorMessage = null;
    notifyListeners();

    try {
      final updatedPet = await petApi.updatePet(
        userId: userId,
        petId: petId,
        name: name,
      );

      final index = _pets.indexWhere((pet) => pet.id == updatedPet.id);

      if (index != -1) {
        _pets[index] = updatedPet;
      }

      return true;
    } catch (error) {
      _submitErrorMessage = '반려견 정보를 수정하지 못했습니다.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> deletePet({
    required PetApi petApi,
    required String userId,
    required String petId,
  }) async {
    _isSubmitting = true;
    _submitErrorMessage = null;
    notifyListeners();

    try {
      await petApi.deletePet(userId: userId, petId: petId);

      _pets.removeWhere((pet) => pet.id == petId);

      return true;
    } catch (error) {
      _submitErrorMessage = '반려견을 삭제하지 못했습니다.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> restorePet({
    required PetApi petApi,
    required String userId,
    required String petId,
  }) async {
    _isSubmitting = true;
    _submitErrorMessage = null;
    notifyListeners();

    try {
      await petApi.restorePet(userId: userId, petId: petId);

      final pets = await petApi.fetchPets(userId: userId);

      _pets
        ..clear()
        ..addAll(pets);

      return true;
    } catch (error) {
      _submitErrorMessage = '반려견을 복구하지 못했습니다.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
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
