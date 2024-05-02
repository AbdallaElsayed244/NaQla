import 'package:Mowasil/functions/firebase/users_data.dart';
import 'package:Mowasil/helper/models/users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupCtrl extends GetxController {
  static SignupCtrl get instance => Get.find();

  final email = TextEditingController();
  final profilePhoto = TextEditingController();
  final passowrd = TextEditingController();
  final nationalcard = TextEditingController();
  final license = TextEditingController();
  final vehiclereg = TextEditingController();
  final username = TextEditingController();

  final userData = Get.put(UsersData());

  Future<void> CreateUser(UserModel user) async {
    await userData.CreateUser(user);
  }
}
