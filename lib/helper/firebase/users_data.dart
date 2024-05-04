import 'package:Mowasil/helper/models/users.dart';
import 'package:Mowasil/helper/show_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersData extends GetxController {
  static UsersData get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  CreateUser(UserModel user) async {
    await _db
        .collection("Users")
        .add(user.toJson())
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
}
