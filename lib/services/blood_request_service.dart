import '../models/blood_request_model.dart';
import 'api_client.dart';

class BloodRequestService {
  final ApiClient _api = ApiClient();

  Future<List<BloodRequestModel>> getAll({String? bloodGroup}) async {
    var path = '/api/blood-requests';
    if (bloodGroup != null) {
      path = '$path?bloodGroup=${Uri.encodeQueryComponent(bloodGroup)}';
    }
    final data = await _api.get(path) as List;
    return data.map((item) => BloodRequestModel.fromJson(item)).toList();
  }

  Future<BloodRequestModel> create(BloodRequestModel request) async {
    final data = await _api.post('/api/blood-requests', request.toJson());
    return BloodRequestModel.fromJson(data);
  }
}
