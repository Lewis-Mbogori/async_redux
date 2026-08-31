class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  // A factory constructor to turn raw JSON (from the API) into a UserModel.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );

  }

  @override
  bool operator ==(Object other) =>
       other is UserModel &&
       other.id == id &&
       other.name == name &&
       other.email == email;


  @override
  // Dart requires hashcode to be overriden whenever == is overriden. Objects that are == to each other must return same hashcode
  int get hashCode => Object.hash(id, name, email);
}