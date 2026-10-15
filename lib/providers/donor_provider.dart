import 'package:flutter/material.dart';

import '../models/donor_model.dart';
import '../services/api_client.dart';
import '../services/donor_service.dart';

class DonorProvider extends ChangeNotifier {
  final DonorService _service = DonorService();

  bool isLoading = false;
  String? errorMessage;

  // Devuelve true si el registro salio bien.
  Future<bool> registerDonor(DonorModel donor) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    bool ok = true;
    try {
      await _service.create(donor);
    } on ApiException catch (error) {
      errorMessage = error.message;
      ok = false;
    }

    isLoading = false;
    notifyListeners();
    return ok;
  }
}
