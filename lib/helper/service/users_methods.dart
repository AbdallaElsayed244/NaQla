import 'package:Mowasil/helper/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersMethods extends GetxController {
  static UsersMethods get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  CreateUser(UserModel user) async {
    await _db
        .collection("Users")
        .doc(user.email)
        .set(user.toJson())
        .whenComplete(() => Get.snackbar(
              "Success",
              "your account has been created",
              backgroundColor: Color.fromARGB(255, 53, 107, 121),
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(50),
            ))
        .catchError((error, stackTrace) {
      Get.snackbar(
        "Error",
        "Something went wrong, try again",
        backgroundColor: Color.fromARGB(255, 175, 5, 28),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(50),
      );
      print(error.toString());
    });
  }

  CreateDriver(UserModel user) async {
    await _db
        .collection("Users")
        .doc("${user.email}Driver")
        .set(user.toJson())
        .whenComplete(() => Get.snackbar(
              "Success",
              "your account has been created",
              backgroundColor: Color.fromARGB(255, 53, 107, 121),
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(50),
            ))
        .catchError((error, stackTrace) {
      Get.snackbar(
        "Error",
        "Something went wrong, try again",
        backgroundColor: Color.fromARGB(255, 175, 5, 28),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(50),
      );
      print(error.toString());
    });
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<UserModel>> allUser() async {
    final snapshot = await _db.collection("Users").get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  Future<UserModel?> getUserProfile(String email) async {
    final docSnapshot = await _db.collection('Users').doc(email).get();
    if (docSnapshot.exists) {
      return UserModel.fromJson(docSnapshot.data()!);
    } else {
      return null;
    }
  }
}
