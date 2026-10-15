import '../models/donor_model.dart';
import 'api_client.dart';

class DonorService {
  final ApiClient _api = ApiClient();

  Future<void> create(DonorModel donor) async {
    await _api.post('/api/donors', donor.toJson());
  }
}
