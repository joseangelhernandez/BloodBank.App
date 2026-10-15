// Datos del formulario "Donor Registration" que se envian al backend.
class DonorModel {
  final String name;
  final String contactNumber;
  final String bloodGroup;
  final String location;
  final DateTime lastDonationDate;

  DonorModel({
    required this.name,
    required this.contactNumber,
    required this.bloodGroup,
    required this.location,
    required this.lastDonationDate,
  });

  // Cuerpo que se envia en POST /api/donors.
  Map<String, dynamic> toJson() {
    final mes = lastDonationDate.month.toString().padLeft(2, '0');
    final dia = lastDonationDate.day.toString().padLeft(2, '0');
    return {
      'name': name,
      'contactNumber': contactNumber,
      'bloodGroup': bloodGroup,
      'location': location,
      'lastDonationDate': '${lastDonationDate.year}-$mes-$dia', // "yyyy-MM-dd"
    };
  }
}
