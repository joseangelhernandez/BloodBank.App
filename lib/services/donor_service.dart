import '../models/donor_model.dart';
import 'api_client.dart';

class DonorService {
  final ApiClient _api = ApiClient();

  // Mi registro de donante, o null si todavia no me registre (el backend responde 404).
  Future<DonorModel?> getMine() async {
    try {
      final data = await _api.get('/api/donors/me');
      return DonorModel.fromJson(data);
    } on ApiException catch (error) {
      if (error.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<DonorModel> create(DonorModel donor) async {
    final data = await _api.post('/api/donors', donor.toJson());
    return DonorModel.fromJson(data);
  }

  Future<DonorModel> update(String id, DonorModel donor) async {
    final data = await _api.put('/api/donors/$id', donor.toJson());
    return DonorModel.fromJson(data);
  }
}
