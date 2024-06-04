import 'package:Mowasil/helper/show_snack_bar.dart';
import 'package:Mowasil/screens/OrdersList/Order_list.dart';
import 'package:Mowasil/screens/login/components/text_fields.dart';
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

                SizedBox(
                  width: 330,
                  height: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(
                            255, 13, 49, 29), //) Set text color to white
                        elevation: 5,
                      ),
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            isloading = true; // Move inside setState
                          });
                          try {
                            final userDoc = await FirebaseFirestore.instance
                                .collection('Users')
                                .doc("${email}Driver")
                                .get();

                            if (userDoc.exists) {
                              // Login successful, navigate to the appropriate screen
                              print('Login successful!');
                              await LoginUser();
                            } else {
                              // User not found in Firestore, handle error
                              showSnackBar(widget.context,
                                  "register as driver to continue");
                              // Show an error message or dialog
                            }

                            // Handle successful user creation (optional)
                           } on FirebaseAuthException catch (e) {
                            showSnackBar(widget.context, e.message);
                          } finally {
                            setState(() {
                              isloading = false; // Move inside setState
                            });
                          }
                        }
                      },
                      child: isloading
                          ? CircularProgressIndicator()
                          : Text(
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
