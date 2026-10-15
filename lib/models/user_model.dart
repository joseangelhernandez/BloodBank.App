// Datos del usuario que devuelve el backend (UserDto).
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? gender; // "Male" o "Female"
  final String? bloodGroup;
  final String? location;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.gender,
    this.bloodGroup,
    this.location,
    this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
      location: json['location'],
      photoUrl: json['photoUrl'],
    );
  }
}
