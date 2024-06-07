import 'package:Naqla/helper/controllers/signup_ctrl.dart';
import 'package:Naqla/helper/firebase/message.dart';
import 'package:Naqla/screens/User/frieght/frieght_page.dart';
import 'package:Naqla/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthMethods extends GetxController {
  static AuthMethods get instance => Get.find();
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  Future<String?> registerUser(
    String email,
    password,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll((context) => Frieght())
          : Get.offAll((context) => const SplashScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('Firebase auth exeption  ${ex.message}');
      throw ex;
    } catch (e) {
      const ex = SignUpWithEmailAndPasswordFailure();
      print('exeption  ${ex.message}');
      throw e;
    }
    return null;
  }

  Future<String?> LoginUser(
    String email,
    password,
  ) async {
    return null;
  }

  Future<void> phoneauth(String phone) async {
    await SignupCtrl.instance.phoneAuth(phone);
  }

  Future<void> logout() async => await _auth.signOut();
}
