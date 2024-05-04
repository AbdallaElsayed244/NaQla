import 'package:Mowasil/helper/firebase/users_data.dart';
import 'package:Mowasil/helper/models/users.dart';
import 'package:Mowasil/helper/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final phone = TextEditingController();

  final userData = Get.put(UsersData());

  var verificationId = ''.obs;
  Future<void> CreateUser(UserModel user) async {
    await userData.CreateUser(user);
  }

  Future<void> phoneAuth(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (credentials) async {
          await FirebaseAuth.instance.signInWithCredential(credentials);
        },
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number') {
            Get.snackbar("error", "phone number not correct");
          } else {
            Get.snackbar("error", "phone number not correct");
          }
        },
        codeSent: (verificationId, forceResendingToken) {
          this.verificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId.value = verificationId;
        });
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials = await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }
}
