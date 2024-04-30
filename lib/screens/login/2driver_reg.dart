import 'dart:io';
import 'package:Mowasil/screens/OrdersList/main.dart';
import 'package:Mowasil/screens/login/components/2ndPageregistration1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_animation_transition/animations/scale_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class ndPageDriver extends StatefulWidget {
  const ndPageDriver({super.key});

  @override
  State<ndPageDriver> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ndPageDriver> {
  final _formRegistrationKey = GlobalKey<FormState>();

  // Separate state variables for each container's image
  File? _image1;
  File? _image2;

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
    return registration1(
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
                    key: _formRegistrationKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 45,
                        ),
                        Text(
                          "Driver License",
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 22),
                        Center(
                          child: InkWell(
                            onTap: () {
                              getImageGallery(1); // Pass 1 for container 1
                            },
                            child: Container(
                              height: 200,
                              width: 380,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xff3F6596)),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: _image1 != null
                                  ? Image.file(
                                      _image1!.absolute,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 50,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Certificate of Vehicle Registration",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 23,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              getImageGallery(2); // Pass 2 for container 2
                            },
                            child: Container(
                              height: 200,
                              width: 380,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xff3F6596)),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: _image2 != null
                                  ? Image.file(
                                      _image2!.absolute,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 50,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 250,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                  PageAnimationTransition(
                                      page: const Orders(),
                                      pageAnimationType:
                                          ScaleAnimationTransition()));
                            },
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff3F6596)),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(7)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
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
    );
  }
}
