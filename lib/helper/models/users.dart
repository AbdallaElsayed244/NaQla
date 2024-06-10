import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id; // Unique user identifier (e.g., from Firebase Auth)
  final String email;
  final String username;
  final String profilePhoto;
  final String? nationalcard;
  final String? license;
  final String? vehiclereg;
  final String? phone;

  const UserModel({
    this.id,
    this.nationalcard,
    this.license,
    this.vehiclereg,
    required this.email,
    required this.username,
    required this.profilePhoto,
    this.phone,
  });

  toJson() {
    return {
      "nationalcard": nationalcard,
      "license": license,
      "vehiclereg": vehiclereg,
      "email": email,
      "username": username,
      "profilePhoto": profilePhoto,
      "phone": phone
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      phone: data["phone"],
      nationalcard: data["nationalcard"],
      license: data["license"],
      vehiclereg: data["vehiclereg"],
      email: data["email"],
      username: data["username"],
      profilePhoto: data["profilePhoto"],
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        nationalcard: json["nationalcard"],
        license: json["license"],
        vehiclereg: json["vehiclereg"],
        email: json["email"],
        username: json["username"],
        profilePhoto: json["profilePhoto"],
        phone: json["phone"],
      );
}
