import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import 'api_client.dart';

// Habla con el backend para el login y registro. Firebase lo usa el backend, no la app.
class AuthService {
  final ApiClient _api = ApiClient();

  Future<UserModel> login({required String email, required String password}) async {
    final data = await _api.post('/api/auth/login', {'email': email, 'password': password});
    return _guardarSesion(data);
  }

  Future<UserModel> register({required String name, required String email, required String password,
  }) async {
    final data = await _api.post(
        '/api/auth/register', {'name': name, 'email': email, 'password': password});
    return _guardarSesion(data);
  }

  // Firebase envia al correo un link para cambiar la contrasena.
  Future<void> forgotPassword(String email) async {
    await _api.post('/api/auth/forgot-password', {'email': email});
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiClient.tokenKey);
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ApiClient.tokenKey);
  }

  // Guarda el token (idToken de Firebase) que nos dio el backend y devuelve el usuario.
  Future<UserModel> _guardarSesion(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiClient.tokenKey, data['token']);
    return UserModel.fromJson(data['user']);
  }
}
