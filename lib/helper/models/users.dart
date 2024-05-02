class UserModel {
  final String? id; // Unique user identifier (e.g., from Firebase Auth)
  final String email;
  final String username;
  final String profilePhoto;
  final String nationalcard;
  final String license;
  final String vehiclereg;

  const UserModel({
    this.id,
    required this.nationalcard,
    required this.license,
    required this.vehiclereg,
    required this.email,
    required this.username,
    required this.profilePhoto,
  });

  toJson() {
    return {
      "nationalcard": nationalcard,
      "license": license,
      "vehiclereg": vehiclereg,
      "email": email,
      "username": username,
      "profilePhoto": profilePhoto,
    };
  }
}
