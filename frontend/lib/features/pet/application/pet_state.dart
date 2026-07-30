import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:frontend/features/pet/domain/pet.dart';

class PetState extends ChangeNotifier {
  final List<Pet> _pets = [];

  UnmodifiableListView<Pet> get pets {
    return UnmodifiableListView(_pets);
  }

  bool get hasPets {
    return _pets.isNotEmpty;
  }

  void addPet(Pet pet) {
    _pets.add(pet);
    notifyListeners();
  }
}
