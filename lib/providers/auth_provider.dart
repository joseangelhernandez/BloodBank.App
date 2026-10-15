import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';

// Guarda el estado de la sesion. Las pantallas lo leen con Provider.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String? errorMessage;
  UserModel? currentUser;

  // Devuelve true si todo salio bien; si no, deja el texto en errorMessage.
  Future<bool> login(String email, String password) async {
    errorMessage = null;
    try {
      currentUser = await _authService.login(email: email, password: password);
      notifyListeners();
      return true;
    } on ApiException catch (error) {
      errorMessage = error.message;
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    errorMessage = null;
    try {
      currentUser = await _authService.register(name: name, email: email, password: password);
      notifyListeners();
      return true;
    } on ApiException catch (error) {
      errorMessage = error.message;
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    errorMessage = null;
    try {
      await _authService.forgotPassword(email);
      return true;
    } on ApiException catch (error) {
      errorMessage = error.message;
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    currentUser = null;
    notifyListeners();
  }

  // Revisa si hay un token guardado. El usuario se carga luego con ProfileProvider.
  Future<bool> tryAutoLogin() async {
    final token = await _authService.getSavedToken();
    return token != null;
  }
}
