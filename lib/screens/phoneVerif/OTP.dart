import 'package:Mowasil/helper/controllers/signup_ctrl.dart';
import 'package:Mowasil/screens/OrdersList/Order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Otp extends GetxController {
  static Otp get instance => Get.find();

  void verifyOTP(String otp, Widget? nextScreen) async {
    var isVerified = await SignupCtrl.instance.verifyOTP(otp);
    isVerified ? Get.off(nextScreen) : Get.snackbar("error", "otp not correct");
  }
}
