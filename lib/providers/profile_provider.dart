import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/api_client.dart';
import '../services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _service = ProfileService();

  UserModel? profile;
  String? errorMessage;

  Future<void> loadProfile() async {
    errorMessage = null;
    try {
      profile = await _service.getProfile();
    } on ApiException catch (error) {
      errorMessage = error.message;
    }
    notifyListeners();
  }

  bool isSaving = false;

  // Devuelve true si se guardo; si no, deja el texto en errorMessage.
  Future<bool> updateProfile({
    required String name,
    String? phone,
    String? gender,
    String? bloodGroup,
    required String location,
    String? photoUrl,
  }) async {
    errorMessage = null;
    isSaving = true;
    notifyListeners();
    try {
      profile = await _service.updateProfile(
        name: name,
        phone: phone,
        gender: gender,
        bloodGroup: bloodGroup,
        location: location,
        photoUrl: photoUrl,
      );
      return true;
    } on ApiException catch (error) {
      errorMessage = error.message;
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // Se llama al cerrar sesion para no mostrar datos del usuario anterior.
  void clear() {
    profile = null;
    errorMessage = null;
    notifyListeners();
  }
}
