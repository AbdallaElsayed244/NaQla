import 'dart:io';
import 'package:Mowasil/helper/controllers/signup_ctrl.dart';
import 'package:Mowasil/helper/models/users.dart';
import 'package:Mowasil/helper/show_snack_bar.dart';
import 'package:Mowasil/screens/login/components/register_text_fields.dart';
import 'package:Mowasil/screens/login/driver_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class DriverReg extends StatefulWidget {
  const DriverReg({Key? key}) : super(key: key);

  @override
  State<DriverReg> createState() => _DriverRegState();
}

class _DriverRegState extends State<DriverReg> {
  GlobalKey<FormState> formkey = GlobalKey();
  File? _image1;
  File? _image2;
  File? _image3;
  File? _image4;
  String? phone;
  String? password;
  String? email;
  bool _isloading = false;
  bool isloading = false;
  String? username;

  final picker = ImagePicker();
  final controller = Get.put(SignupCtrl());
  String imageUrl1 = "";
  String imageUrl2 = "";
  String imageUrl3 = "";
  String imageUrl4 = "";

  Future getImageGallery(int containerIndex) async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    print("${pickedFile?.path}");
    if (pickedFile == null) return;

    setState(() {
      isloading = true; // Set loading state to true
    });

    Reference refrenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = refrenceRoot.child("images");

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
    try {
      await referenceImageToUpload.putFile(File(pickedFile.path));
      if (containerIndex == 1) {
        setState(() {
          isloading = true; // Set loading state to true
        });
        imageUrl1 = await referenceImageToUpload.getDownloadURL();
        setState(() {
          isloading = false; // Set loading state to true
        });
      } else if (containerIndex == 2) {
        setState(() {
          isloading = true; // Set loading state to true
        });
        imageUrl2 = await referenceImageToUpload.getDownloadURL();
        setState(() {
          isloading = false; // Set loading state to true
        });
      } else if (containerIndex == 3) {
        setState(() {
          isloading = true; // Set loading state to true
        });
        imageUrl3 = await referenceImageToUpload.getDownloadURL();
        setState(() {
          isloading = false; // Set loading state to true
        });
      } else if (containerIndex == 4) {
        setState(() {
          isloading = true; // Set loading state to true
        });
        imageUrl4 = await referenceImageToUpload.getDownloadURL();
        setState(() {
          isloading = false; // Set loading state to true
        });
      }
    } catch (e) {
      showSnackBar(context, "error occurred");
    }

    setState(() {
      if (containerIndex == 1) {
        _image1 = File(pickedFile.path);
      } else if (containerIndex == 2) {
        _image2 = File(pickedFile.path);
      } else if (containerIndex == 3) {
        _image3 = File(pickedFile.path);
      } else if (containerIndex == 4) {
        _image4 = File(pickedFile.path);
      }
    });
    }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupCtrl());
    ScreenUtil.init(context);
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
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    decoration: BoxDecoration(),
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
                                "Create New Account As Driver",
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 45, 44, 44),
                                ),
                              ),
                              Stack(
                                children: [
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        getImageGallery(1);
                                        setState(() {
                                          isloading =
                                              false; // Set loading indicator to false if no image is picked
                                        });
                                      },
                                      child: Container(
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
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 20, 14, 14),
                                                      width: 4,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 90,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  if (isloading)
                                    Positioned.fill(
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                ],
                              ),
                              Text(
                                "Profile Photo",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
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
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        // Use Flexible for responsive width
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Center(
                                                  child: InkWell(
                                                    onTap: () {
                                                      getImageGallery(2);
                                                      setState(() {
                                                        isloading =
                                                            false; // Set loading indicator to false if no image is picked
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 85
                                                          .h, // Use ScreenUtil for responsive height
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors
                                                              .transparent,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                      ),
                                                      child: _image2 != null
                                                          ? Image.file(
                                                              _image2!.absolute,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Center(
                                                              child:
                                                                  Image.asset(
                                                                "images/ID.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                                if (isloading)
                                                  Positioned.fill(
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                  ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: 13
                                                    .h), // Use ScreenUtil for responsive spacing
                                            Text(
                                              "National Card",
                                              style: TextStyle(
                                                  fontSize: 23.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          width: 20
                                              .w), // Use ScreenUtil for responsive spacing
                                      Flexible(
                                        // Use Flexible for responsive width
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    getImageGallery(3);
                                                    setState(() {
                                                      isloading =
                                                          false; // Set loading indicator to false if no image is picked
                                                    }); // Pass 1 for container 1
                                                  },
                                                  child: Container(
                                                    height: 75.h,
                                                    width: 135
                                                        .h, // Use ScreenUtil for responsive height
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 4,
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                    child: _image3 != null
                                                        ? Image.file(
                                                            _image3!.absolute,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Center(
                                                            child: Image.asset(
                                                              "images/license.png",
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                if (isloading)
                                                  Positioned.fill(
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                  ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: 13
                                                    .h), // Use ScreenUtil for responsive spacing
                                            Text(
                                              "Driver License",
                                              style: TextStyle(
                                                  fontSize: 23.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 23,
                                  ),
                                  Stack(
                                    children: [
                                      Center(
                                        child: InkWell(
                                          onTap: () {
                                            getImageGallery(
                                                4); // Pass 2 for container 2
                                            setState(() {
                                              isloading =
                                                  false; // Set loading indicator to false if no image is picked
                                            });
                                          },
                                          child: Container(
                                            height: 150,
                                            width: 180,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            child: _image4 != null
                                                ? Image.file(
                                                    _image4!.absolute,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Center(
                                                    child: Image.asset(
                                                      "images/Driver.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      if (isloading)
                                        Positioned.fill(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Certificate of Vehicle Registration",
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              SizedBox(
                                width: 240,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_image1 == null ||
                                        _image2 == null ||
                                        _image3 == null ||
                                        _image4 == null) {
                                      showSnackBar(
                                          context, 'all images are required.'); // errors message
                                      return;
                                    }
                                    if (formkey.currentState!.validate()) {
                                      _isloading = true;
                                      setState(() {});
                                      try {
                                        await registerUser(); // Register Driver function call
                                        final user = UserModel(
                                          nationalcard: imageUrl2,
                                          license: imageUrl3,
                                          vehiclereg: imageUrl4,
                                          email: controller.email.text.trim(),
                                          username:
                                              controller.username.text.trim(),
                                          profilePhoto: imageUrl1,
                                        );
                                        SignupCtrl.instance.CreateDriver( user); // register Driver to database
                                           
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DriverDetails(
                                                driverEmail: email),
                                          ),
                                        );
                                        showSnackBar(context,  "Registration Successful");  // successful Driver creation message
                                         
                                      } on FirebaseAuthException catch (e) {
                                        showSnackBar(context, e.message);
                                      }
                                      _isloading = false;
                                      setState(() {});
                                    } else {}
                                  },
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(
                                        fontSize: 23,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 13, 49, 29)),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.all(7)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    // ignore: unused_local_variable
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }


}
