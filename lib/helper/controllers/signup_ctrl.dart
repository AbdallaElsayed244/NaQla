import 'package:Mowasil/helper/service/auth_methods.dart';
import 'package:Mowasil/helper/service/users_methods.dart';
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
  final vehicletype = TextEditingController();
  final vehiclenum = TextEditingController();

  

  final userData = Get.put(UsersMethods());
  bool _isloading = false;

  var verificationId = ''.obs;
  Future<void> CreateUser(UserModel user) async {
    await userData.CreateUser(user);
  }
  Future<void> CreateDriver(UserModel user) async {
    await userData.CreateDriver(user);
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

   registerUser(String email, String password) async {
    try {
      await AuthMethods.instance.registerUser(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("Error", "Weak password");
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("Error", "Email already in use");
      }
    } catch (e) {
      Get.snackbar("Error", "You must enter email and password");
    }
    _isloading = false;
  }

   loginuser(String email, password) async {
    try {
      AuthMethods.instance.LoginUser(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("Error", "email not found");
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Error", "wrong-password");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      Get.snackbar("Error", "error");
    }
    _isloading = false;
  }
}
