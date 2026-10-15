import 'package:flutter/material.dart';

import '../models/blood_request_model.dart';
import '../services/api_client.dart';
import '../services/blood_request_service.dart';

class BloodRequestProvider extends ChangeNotifier {
  final BloodRequestService _service = BloodRequestService();

  List<BloodRequestModel> requests = []; // todas: las muestra el Home
  // Lista de la pantalla All Requests, con el filtro aplicado.
  // Va aparte para que filtrar alli no cambie lo que se ve en el Home.
  List<BloodRequestModel> filteredRequests = [];
  String? selectedBloodGroup; // null = todos los grupos
  BloodRequestModel? selectedRequest; // la que se ve en el detalle
  bool isLoading = false;
  String? errorMessage;

  // Cambia el filtro y vuelve a cargar solo la lista filtrada.
  Future<void> setBloodGroup(String? group) async {
    selectedBloodGroup = group;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      filteredRequests = await _service.getAll(bloodGroup: selectedBloodGroup);
    } on ApiException catch (error) {
      errorMessage = error.message;
    }

    isLoading = false;
    notifyListeners();
  }

  // Carga todas las solicitudes (sin filtro) para el Home.
  Future<void> loadRequests() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      requests = await _service.getAll();
    } on ApiException catch (error) {
      errorMessage = error.message;
    }

    isLoading = false;
    notifyListeners();
  }

  // Devuelve true si se creo bien.
  Future<bool> createRequest(BloodRequestModel request) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    bool ok = true;
    try {
      final created = await _service.create(request);
      requests.insert(0, created); // la mas nueva va primero
    } on ApiException catch (error) {
      errorMessage = error.message;
      ok = false;
    }

    isLoading = false;
    notifyListeners();
    return ok;
  }

  void selectRequest(BloodRequestModel request) {
    selectedRequest = request;
    notifyListeners();
  }

  // Se llama al cerrar sesion para no mostrar datos del usuario anterior.
  void clear() {
    requests = [];
    filteredRequests = [];
    selectedBloodGroup = null;
    selectedRequest = null;
    errorMessage = null;
    notifyListeners();
  }
}
