import 'dart:io';
import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/helper/controllers/signup_ctrl.dart';
import 'package:Mowasil/helper/models/users.dart';
import 'package:Mowasil/helper/show_snack_bar.dart';
import 'package:Mowasil/screens/User/frieght/frieght_page.dart';
import 'package:Mowasil/screens/login/components/register_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            iconSize: 29,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/photo.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                    flex: 7,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(40.0)),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 70),
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
                                            border: Border.all(
                                                color: Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(0),
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
                                                          color: const Color
                                                              .fromARGB(
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
                                                child:
                                                    CircularProgressIndicator()),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text("Profile Photo",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 13,
                                ),
                                RegisterTextFields(
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
                                  label: Text("email"),
                                  hintText: "enter email",
                                  obscureText: false,
                                ),
                                SizedBox(
                                  height: 13,
                                ),
                                RegisterTextFields(
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
                                  label: Text("username"),
                                  hintText: "enter username",
                                  obscureText: false,
                                ),
                                SizedBox(
                                  height: 13,
                                ),
                                RegisterTextFields(
                                  controller: controller.passowrd,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter password";
                                    }
                                    return null;
                                  },
                                  onChanged: (data) {
                                    password = data;
                                  },
                                  label: Text("Password"),
                                  hintText: "enter password",
                                ),
                                SizedBox(
                                  height: 13,
                                ),
                                RegisterTextFields(
                                  obscureText: false,
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
                                  label: Text("Phone"),
                                  hintText: "enter phone",
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
                                        showSnackBar(context,
                                            'profile image is requierd.');

                                        return;
                                      }
                                      if (formkey.currentState!.validate()) {
                                        _isloading = true;
                                        setState(() {});
                                        try {
                                          await registerUser(); // Register User function call
                                          final user = UserModel(
                                              nationalcard: controller  .nationalcard.text.trim(),
                                              license: controller.license.text .trim(),  
                                              vehiclereg: controller .vehiclereg.text .trim(),
                                              email: controller.email.text.trim(),
                                              username: controller.username.text.trim(),
                                              phone: controller.phone.text.trim(),
                                              profilePhoto: imageUrl);
                                          SignupCtrl.instance.CreateUser(user); // register user to database

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Frieght(email: email)),
                                          );
                                         
                                        } on FirebaseAuthException catch (e) {
                                          showSnackBar(context, e.message); // error message
                                        }
                                        _isloading = false;
                                        setState(() {});
                                      } else {}
                                    },
                                    child: Text(
                                      "Create Account",
                                      style: TextStyle(
                                          fontSize: 23,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              ButtonsColor),
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
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
