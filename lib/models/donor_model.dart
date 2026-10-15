// Donante (DonorDto). Es siempre el usuario autenticado: el backend lo liga a su cuenta.
class DonorModel {
  final String? id; // null cuando todavia no se ha registrado en el servidor
  final String name;
  final String contactNumber;
  final String bloodGroup;
  final String location;
  final String? photoUrl; // la app aun no la cambia, pero se reenvia para no borrarla
  final DateTime lastDonationDate;

  DonorModel({
    this.id,
    required this.name,
    required this.contactNumber,
    required this.bloodGroup,
    required this.location,
    this.photoUrl,
    required this.lastDonationDate,
  });

  factory DonorModel.fromJson(Map<String, dynamic> json) {
    return DonorModel(
      id: json['id'],
      name: json['name'],
      contactNumber: json['contactNumber'],
      bloodGroup: json['bloodGroup'],
      location: json['location'],
      photoUrl: json['photoUrl'],
      lastDonationDate: DateTime.parse(json['lastDonationDate']), // "yyyy-MM-dd"
    );
  }

  // Cuerpo que se envia en POST /api/donors y PUT /api/donors/{id}.
  Map<String, dynamic> toJson() {
    final mes = lastDonationDate.month.toString().padLeft(2, '0');
    final dia = lastDonationDate.day.toString().padLeft(2, '0');
    return {
      'name': name,
      'contactNumber': contactNumber,
      'bloodGroup': bloodGroup,
      'location': location,
      'photoUrl': photoUrl,
      'lastDonationDate': '${lastDonationDate.year}-$mes-$dia', // "yyyy-MM-dd"
    };
  }
}
