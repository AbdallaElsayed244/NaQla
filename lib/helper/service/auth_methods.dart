import 'package:Mowasil/helper/controllers/signup_ctrl.dart';
import 'package:Mowasil/helper/firebase/message.dart';
import 'package:Mowasil/screens/User/frieght/frieght_page.dart';
import 'package:Mowasil/screens/User/oder_info/orderinfo.dart';
import 'package:Mowasil/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthMethods extends GetxController {
  static AuthMethods get instance => Get.find();
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  void onReady() {
    Future.delayed(Duration(seconds: 6));
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    user == null
        ? Get.offAll((context) => const SplashScreen())
        : Get.offAll((context) => Frieght());
  }

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
  }

  Future<String?> LoginUser(
    String email,
    password,
  ) async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password!);
  }

  Future<void> phoneauth(String phone) async {
    await SignupCtrl.instance.phoneAuth(phone);
  }

  Future<void> logout() async => await _auth.signOut();
}
