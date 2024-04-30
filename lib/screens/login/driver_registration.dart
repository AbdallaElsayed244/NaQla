// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:Mowasil/helper/show_snack_bar.dart';
import 'package:Mowasil/screens/login/2driver_reg.dart';
import 'package:Mowasil/screens/login/components/custom_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class DriverReg extends StatefulWidget {
  const DriverReg({Key? key}) : super(key: key);

  @override
  State<DriverReg> createState() => _DriverRegState();
}

class _DriverRegState extends State<DriverReg> {
  GlobalKey<FormState> formkey = GlobalKey();
  File? _image1;
  File? _image2;
  String? phone;
  String? password;
  String? username;
  bool isloading = false;
  final picker = ImagePicker();

  Future getImageGallery(int containerIndex) async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      // Check for null
      setState(() {
        if (containerIndex == 1) {
          _image1 = File(pickedFile.path); // Access path from XFile
        } else {
          _image2 = File(pickedFile.path);
        }
      });
    } else {
      print("No Image Picked");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        body: CustomScaffold(
          body: null,
          child: Column(
            children: [
              Expanded(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(40.0)),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 13,
                            ),
                            Text(
                              "Create New Account As Driver",
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(255, 45, 44, 44),
                              ),
                            ),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  getImageGallery(1);
                                },
                                child: Container(
                                  height: 120,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(0)),
                                  child: _image1 != null
                                      ? Image.file(
                                          _image1!.absolute,
                                          fit: BoxFit.cover,
                                        )
                                      : Center(
                                          child: Icon(
                                            Icons.add_photo_alternate_outlined,
                                            size: 35,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            Text("Profile Photo",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 13,
                            ),
                            TextFormField(
                              onChanged: (data) {
                                username = data;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter user name";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  label: Text("User Name"),
                                  hintText: "enter user name",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(247, 90, 94, 98)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(247, 158, 179, 200),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(215, 63, 101, 150),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            TextFormField(
                              obscureText: true,
                              obscuringCharacter: "*",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter password";
                                }
                                return null;
                              },
                              onChanged: (data) {
                                password = data;
                              },
                              decoration: InputDecoration(
                                  label: Text("Password"),
                                  hintText: "enter password",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(247, 90, 94, 98)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(247, 158, 179, 200),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(215, 63, 101, 150),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            TextFormField(
                              onChanged: (data) {
                                phone = data;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter phone";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  label: Text("Phone"),
                                  hintText: "enter phone",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(247, 90, 94, 98)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(247, 158, 179, 200),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(215, 63, 101, 150),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  getImageGallery(2);
                                },
                                child: Container(
                                  height: 180,
                                  width: 350,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(0)),
                                  child: _image2 != null
                                      ? Image.file(
                                          _image2!.absolute,
                                          fit: BoxFit.cover,
                                        )
                                      : Center(
                                          child: Icon(
                                            Icons.add_photo_alternate_outlined,
                                            size: 35,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            Text("National Card",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 240,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (formkey.currentState!.validate()) {
                                    isloading = true;
                                    setState(() {});
                                    try {
                                      await registerUser();

                                      Navigator.of(context).push(
                                          PageAnimationTransition(
                                              page: const ndPageDriver(),
                                              pageAnimationType:
                                                  RightToLeftTransition()));
                                      // Handle successful user creation (optional)
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'weak-password') {
                                        showSnackBar(context, "ًweak password");
                                      } else if (e.code ==
                                          'email-already-in-use') {
                                        showSnackBar(
                                            context, "email-already-in-use");
                                      }
                                    } catch (e) {
                                      showSnackBar(context,
                                          "You must enter email and password");
                                    }
                                    isloading = false;
                                    setState(() {});
                                  } else {}
                                },
                                child: Text(
                                  "Next ➜",
                                  style: TextStyle(
                                      fontSize: 23,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xff3F6596)),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(7)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: username!, password: password!);
  }
}
