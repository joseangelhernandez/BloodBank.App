// Una solicitud de sangre (BloodRequestDto).
class BloodRequestModel {
  final String? id; // null cuando todavia no se ha creado en el servidor
  final String patientName;
  final String bloodGroup;
  final int bags; // de 1 a 10
  final String contactNumber;
  final String emergencyContact;
  final String cause;
  final String? gender;
  final String? location; // opcional: el formulario no tiene este campo
  final DateTime neededBefore;
  final String? notes;
  final DateTime? createdAt;

  BloodRequestModel({
    this.id,
    required this.patientName,
    required this.bloodGroup,
    required this.bags,
    required this.contactNumber,
    required this.emergencyContact,
    required this.cause,
    this.gender,
    this.location,
    required this.neededBefore,
    this.notes,
    this.createdAt,
  });

  factory BloodRequestModel.fromJson(Map<String, dynamic> json) {
    return BloodRequestModel(
      id: json['id'],
      patientName: json['patientName'],
      bloodGroup: json['bloodGroup'],
      bags: json['bags'],
      contactNumber: json['contactNumber'],
      emergencyContact: json['emergencyContact'],
      cause: json['cause'],
      gender: json['gender'],
      location: json['location'],
      neededBefore: DateTime.parse(json['neededBefore']),
      notes: json['notes'],
      // El servidor manda la fecha en UTC (termina en "Z"); la pasamos a hora local.
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
    );
  }

  // Cuerpo que se envia al crear (POST /api/blood-requests).
  Map<String, dynamic> toJson() {
    return {
      'patientName': patientName,
      'bloodGroup': bloodGroup,
      'bags': bags,
      'contactNumber': contactNumber,
      'emergencyContact': emergencyContact,
      'cause': cause,
      'gender': gender,
      'location': location,
      'neededBefore': _soloFecha(neededBefore),
      'notes': notes,
    };
  }
}

// Convierte una fecha a texto "yyyy-MM-dd".
String _soloFecha(DateTime fecha) {
  final mes = fecha.month.toString().padLeft(2, '0');
  final dia = fecha.day.toString().padLeft(2, '0');
  return '${fecha.year}-$mes-$dia';
}
