import 'package:Naqla/helper/show_snack_bar.dart';
import 'package:Naqla/screens/Driver/OrdersList/Order_list.dart';
import 'package:Naqla/screens/login/components/text_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/scale_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class DriverLogin extends StatefulWidget {
  final VoidCallback? onBack; // Callback function
  const DriverLogin({Key? key, this.onBack, required this.context})
      : super(key: key);
  final BuildContext context;
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

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: screenSize.width, // Adjust width based on screen size
        height: screenSize.height * 0.55, // Adjust height based on screen size
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
                        color: Colors.white,
                        child: TextFields(
                          text: "email",
                          onChanged: (data) {
                            email = data;
                          },
                          icon: const Icon(Icons.person),
                          hide: false,
                          type: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Material(
                        color: Colors.white,
                        child: TextFields(
                          text: "Password",
                          onChanged: (data) {
                            password = data;
                          },
                          icon: const Icon(Icons.key),
                          hide: true,
                          type: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 70), // Adjust spacing

                SizedBox(
                  width: 330,
                  height: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 13, 49, 29),
                        elevation: 5,
                      ),
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            isloading = true;
                          });
                          final driverDoc = await FirebaseFirestore.instance
                              .collection('Users')
                              .doc("${email}Driver")
                              .get();
                          if (driverDoc.exists) {
                            try {
                              // Login successful, navigate to the appropriate screen
                              print('Login successful!');
                              await LoginUser(); // Driver login function call
                            } on FirebaseAuthException catch (e) {
                              showSnackBar(
                                  widget.context, e.message); // error message
                            } finally {
                              setState(() {
                                isloading = false;
                              });
                            }
                          } else {
                            // Driver not found in Database
                            showSnackBar(widget.context,
                                "register as driver to continue");
                            // Show an error message
                          }
                        }
                      },
                      child: isloading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Sign in',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> LoginUser() async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
      Navigator.of(context).push(PageAnimationTransition(
          page: Orders(driverEmail: email),
          pageAnimationType: ScaleAnimationTransition()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(widget.context, "email not registerd");
      } else if (e.code == "wrong-password") {
        showSnackBar(widget.context, "wrong password");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(
        widget.context,
        "Error, please try again later",
      );
    }
  }
}
