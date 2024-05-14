// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructorimport 'dart:io';

import 'dart:io';

import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/helper/controllers/signup_ctrl.dart';
import 'package:Mowasil/helper/models/users.dart';
import 'package:Mowasil/helper/service/auth_methods.dart';
import 'package:Mowasil/helper/show_snack_bar.dart';
import 'package:Mowasil/screens/frieght/frieght_page.dart';

import 'package:Mowasil/screens/login/components/custom_scaffold.dart';
import 'package:Mowasil/screens/oder_info/orderinfo.dart';
import 'package:Mowasil/screens/phoneVerif/phone_verif_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class UserReg extends StatefulWidget {
  const UserReg({Key? key}) : super(key: key);

  @override
  State<UserReg> createState() => _UserRegState();
}

class _UserRegState extends State<UserReg> {
  GlobalKey<FormState> formkey = GlobalKey();
  File? _image1;
  String? phone;
  String? password;
  String? email;
  String? username;
  bool _isloading = false;
  bool isloading = false;
  final picker = ImagePicker();
  final controller = Get.put(SignupCtrl());
  String imageUrl = "";

  Future<void> getImageGallery(int containerIndex) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      setState(() {
        isloading =
            true; // Set loading indicator to false if no image is picked
      });
      if (pickedFile == null) {
        setState(() {
          isloading =
              false; // Set loading indicator to false if no image is picked
        });
        return;
      }

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child("images");

      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);

      await referenceImageToUpload.putFile(File(pickedFile.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();

      setState(() {
        isloading = false; // Reset loading indicator after successful upload
        if (containerIndex == 1) {
          _image1 = File(pickedFile.path);
        }
      });
    } catch (e) {
      showSnackBar(context.mounted as BuildContext, "Error occurred");
      setState(() {
        isloading = false; // Reset loading indicator on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupCtrl());
    return ModalProgressHUD(
      inAsyncCall: _isloading,
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
                              "Create New Account As User",
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(255, 45, 44, 44),
                              ),
                            ),
                            Center(
                              child: InkWell(
                                onTap: () async {
                                  await getImageGallery(1);
                                  setState(() {
                                    isloading =
                                        false; // Set loading indicator to false if no image is picked
                                  });
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 120,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      child: _image1 != null
                                          ? Image.file(
                                              _image1!.absolute,
                                              fit: BoxFit.cover,
                                            )
                                          : Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 20, 14, 14),
                                                      width: 4,
                                                    ),
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                  Icons.person,
                                                  size: 90,
                                                ),
                                              ),
                                            ),
                                    ),
                                    // Loading Indicator inside the InkWell
                                    if (isloading)
                                      Positioned.fill(
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Text("Profile Photo",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 13,
                            ),
                            TextFormField(
                              controller: controller.email,
                              onChanged: (data) {
                                email = data;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter email";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  label: Text("email"),
                                  hintText: "enter email",
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
                              controller: controller.username,
                              onChanged: (data) {
                                username = data;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter username";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  label: Text("username"),
                                  hintText: "enter username",
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
                              controller: controller.passowrd,
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
                              controller: controller.phone,
                              onChanged: (data) {
                                formkey.currentState?.validate();
                                // Check if the entered phone number doesn't start with the country code
                                if (!data.startsWith("+2") &&
                                    !data.startsWith("01")) {
                                  // If not, add the Egypt country code
                                  controller.phone.text = "+2$data";
                                }
                                phone = controller.phone
                                    .text; // Update phone variable if needed
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter phone";
                                } else if (!RegExp(
                                        r'^(\+201|01|00201)[0-2,5]{1}[0-9]{8}$')
                                    .hasMatch(value)) {
                                  return "Please enter valid phone number";
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
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 240,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_image1 == null) {
                                    showSnackBar(
                                        context, 'profile image is requierd.');

                                    return;
                                  }
                                  if (formkey.currentState!.validate()) {
                                    _isloading = true;
                                    setState(() {});
                                    try {
                                      await registerUser();
                                      phoneauth(
                                        controller.phone.text.trim(),
                                      );

                                      final user = UserModel(
                                          nationalcard: controller
                                              .nationalcard.text
                                              .trim(),
                                          license:
                                              controller.license.text.trim(),
                                          vehiclereg:
                                              controller.vehiclereg.text.trim(),
                                          email: controller.email.text.trim(),
                                          username:
                                              controller.username.text.trim(),
                                          profilePhoto: imageUrl);
                                      SignupCtrl.instance.CreateUser(user);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Frieght(email: email)),
                                      );
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
                                    _isloading = false;
                                    setState(() {});
                                  } else {}
                                },
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(
                                      fontSize: 23,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(ButtonsColor),
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
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }

  Future<void> phoneauth(String phone) async {
    await SignupCtrl.instance.phoneAuth(phone);
  }
}
