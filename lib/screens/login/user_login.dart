import 'package:Mowasil/helper/controllers/signup_ctrl.dart';
import 'package:Mowasil/helper/show_snack_bar.dart';
import 'package:Mowasil/screens/User/frieght/frieght_page.dart';
import 'package:Mowasil/screens/login/components/text_fields.dart';
import 'package:Mowasil/screens/User/oder_info/orderinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserLogin extends StatefulWidget {
  final VoidCallback? onBack; // Callback function
  const UserLogin({Key? key, this.onBack, required this.context})
      : super(key: key);
  final BuildContext context;
  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  String? email, password;
  final GlobalKey<FormState> formkey = GlobalKey();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the screen size
    final screenSize = MediaQuery.of(context).size;
    final controller = Get.put(SignupCtrl());

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
                  "Sign in to continue as user.",
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
                            isloading = true;
                          });
                          try {
                            await loginUser(
                                widget.context); // user login function call
                            await navigateBasedOnOrder(widget.context, email!); // navigate to Order page based on user order existence
                          } on FirebaseAuthException catch (e) {
                            showSnackBar(widget.context,
                                e.message); // message user login errors
                          } finally {
                            setState(() {
                              isloading = false;
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

  Future<void> loginUser(BuildContext context) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }

  Future<void> navigateBasedOnOrder(BuildContext context, String email) async {
    final orderCollection = FirebaseFirestore.instance.collection('orders');
    final querySnapshot =
        await orderCollection.where('id', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      // If an order with the email exists, navigate to OrderInfo page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Orderinfo(email: email)),
      );
    } else {
      // Otherwise, navigate to Frieght page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Frieght(email: email)),
      );
    }
  }
}
