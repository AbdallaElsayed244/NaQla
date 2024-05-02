import 'package:Mowasil/helper/show_snack_bar.dart';
import 'package:Mowasil/screens/OrdersList/main.dart';
import 'package:Mowasil/screens/frieght/frieght_page.dart';
import 'package:Mowasil/screens/login/components/new_account.dart';
import 'package:Mowasil/screens/login/components/text_fields.dart';
import 'package:Mowasil/screens/login/components/login_button.dart';
import 'package:Mowasil/screens/oder_info/orderinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/animations/scale_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class DriverLogin extends StatefulWidget {
  final VoidCallback? onBack; // Callback function
  const DriverLogin({Key? key, this.onBack}) : super(key: key);

  @override
  State<DriverLogin> createState() => _DriverLoginState();
}

class _DriverLoginState extends State<DriverLogin> {
  String? email, password;
  final GlobalKey<FormState> formkey = GlobalKey();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the screen size
    final screenSize = MediaQuery.of(context).size;

    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: screenSize.width, // Adjust width based on screen size
          height:
              screenSize.height * 0.55, // Adjust height based on screen size
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(60)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: widget.onBack,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xff1C2120),
                        size: 35,
                      ),
                    ),
                  ),
                  const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40, // Reduced font size for better adaptability
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Sign in to continue as Driver.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Material(
                          child: TextFields(
                            text: "email",
                            onChanged: (data) {
                              email = data;
                            },
                            icon: Icon(Icons.person),
                            hide: false,
                            type: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(height: 10),
                        Material(
                          child: TextFields(
                            text: "Password",
                            onChanged: (data) {
                              password = data;
                            },
                            icon: Icon(Icons.key),
                            hide: true,
                            type: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 70), // Adjust spacing

                  LoginButton(
                    type: "sign in",
                    function: () async {
                      if (formkey.currentState!.validate()) {
                        isloading = true;
                        setState(() {});
                        try {
                          await LoginUser();
                          Navigator.of(context).push(PageAnimationTransition(
                              page: Orders(),
                              pageAnimationType: ScaleAnimationTransition()));
                          // Handle successful user creation (optional)
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            showSnackBar(context, "email not registerd");
                          } else if (e.code == 'wrong-password') {
                            showSnackBar(context, "wrong password");
                          }
                        } catch (e) {
                          showSnackBar(
                              context, "You must enter email and password");
                        }
                        isloading = false;
                        setState(() {});
                      } else {}
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> LoginUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
