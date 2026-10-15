import '../models/user_model.dart';
import 'api_client.dart';

class ProfileService {
  final ApiClient _api = ApiClient();

  Future<UserModel> getProfile() async {
    final data = await _api.get('/api/profile');
    return UserModel.fromJson(data);
  }

  // Guarda los cambios. El backend actualiza la BD y el nombre en Firebase
  Future<UserModel> updateProfile({
    required String name,
    String? phone,
    String? gender,
    String? bloodGroup,
    String? location,
    String? photoUrl,
  }) async {
    final data = await _api.put('/api/profile', {
      'name': name,
      'phone': phone,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'location': location,
      'photoUrl': photoUrl,
    });
    return UserModel.fromJson(data);
  }
}
