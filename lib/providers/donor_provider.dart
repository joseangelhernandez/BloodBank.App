import 'package:flutter/material.dart';

import '../models/donor_model.dart';
import '../services/api_client.dart';
import '../services/donor_service.dart';

class DonorProvider extends ChangeNotifier {
  final DonorService _service = DonorService();

  // Registro de donante del usuario autenticado; null = todavia no es donante.
  DonorModel? myDonor;
  bool isLoading = false;
  String? errorMessage;

  bool get isRegistered => myDonor != null;

  // Pregunta al backend si el usuario ya es donante.
  Future<void> loadMyDonor() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      myDonor = await _service.getMine();
    } on ApiException catch (error) {
      errorMessage = error.message;
    }

    isLoading = false;
    notifyListeners();
  }

  // Si no es donante lo registra (POST); si ya lo es, actualiza sus datos (PUT).
  // Devuelve true si salio bien.
  Future<bool> saveDonor(DonorModel donor) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    bool ok = true;
    try {
      myDonor = myDonor == null
          ? await _service.create(donor)
          : await _service.update(myDonor!.id!, donor);
    } on ApiException catch (error) {
      errorMessage = error.message;
      ok = false;
    }

    isLoading = false;
    notifyListeners();
    return ok;
  }

  // Se llama al cerrar sesion para no mostrar datos del usuario anterior.
  void clear() {
    myDonor = null;
    errorMessage = null;
    notifyListeners();
  }
}
