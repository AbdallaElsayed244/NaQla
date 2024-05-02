import 'dart:io';
import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/helper/show_snack_bar.dart';
import 'package:Mowasil/screens/frieght/components/text_field.dart';
import 'package:Mowasil/screens/login/maps/googlemap.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_animation_transition/animations/scale_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import '../oder_info/orderinfo.dart';

class Frieght extends StatefulWidget {
  const Frieght({super.key});

  @override
  State<Frieght> createState() => _FrieghtState();
}

class _FrieghtState extends State<Frieght> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  final GlobalKey<_FrieghtState> dropDownTextFieldKey = GlobalKey();

  File? _image1;

  bool isloading = false;
  final picker = ImagePicker();

  String imageUrl1 = "";

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
      await referenceImageToUpload.putFile(File(pickedFile!.path));
      if (containerIndex == 1) {
        setState(() {
          isloading = true; // Set loading state to true
        });
        imageUrl1 = await referenceImageToUpload.getDownloadURL();
        setState(() {
          isloading = false; // Set loading state to true
        });
      }
    } catch (e) {
      showSnackBar(context, "erorr occourd");
    }

    if (pickedFile != null) {
      setState(() {
        if (containerIndex == 1) {
          _image1 = File(pickedFile.path);
        }
      });
    } else {
      print("No Image Picked");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define a list of options
    List<String> options = ['Option 1', 'Option 2', 'Option 3'];

    String selectedValue = options[0];
    final FocusNode focusNode = FocusNode();
    return Scaffold(
        body: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFrieght(
                  type: TextInputType.streetAddress,
                  name: "Pickup Location",
                  navigate: () {
                    Navigator.of(context).push(PageAnimationTransition(
                      page: const GoogleMapPage(),
                      pageAnimationType: ScaleAnimationTransition(),
                    ));
                  },
                ),
                TextFrieght(
                    type: TextInputType.streetAddress,
                    controller: locationController,
                    name: "Destination",
                    navigate: () {}),
                TextFrieght(
                    type: TextInputType.datetime,
                    name: "Date And Time",
                    navigate: () {}),
                TextFrieght(
                    type: TextInputType.text,
                    name: "Describtion Of The Cargo",
                    navigate: () {}),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  padding: EdgeInsets.symmetric(horizontal: 21),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  width: 350,
                  height: 70,
                  child: DropDownTextField(
                      dropDownList: [
                        DropDownValueModel(name: 'نقل', value: "value5"),
                        DropDownValueModel(name: 'نص نقل', value: "value6"),
                        DropDownValueModel(name: 'ربع نقل ', value: "value7"),
                        DropDownValueModel(name: 'تروسيكل', value: "value8"),
                      ],
                      validator: (value) {
                        if (value == null) {
                          return "Required field";
                        } else {
                          return null;
                        }
                      },
                      dropDownItemCount: 6,
                      onChanged: (val) {
                        setState(() {
                          selectedValue = val;
                          // Close the dropdown manually (assuming a close function exists)
                          focusNode.unfocus();
                        });
                      },
                      textFieldDecoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Vehicle Size",
                        hintStyle: TextStyle(fontSize: 18),
                        labelStyle: TextStyle(fontSize: 33),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.keyboard_arrow_right_outlined),
                          iconSize: 40,
                          onPressed: () {},
                        ),
                      )),
                ),
                TextFrieght(
                    type: TextInputType.number,
                    name: "Offer Your Car",
                    navigate: () {}),
                Padding(
                  padding: const EdgeInsets.only(left: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Picture of your cargo",
                            style: TextStyle(
                                fontSize: 19,
                                color: const Color.fromARGB(255, 29, 28, 28),
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 150,
                            height: 150,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  getImageGallery(1);
                                },
                                child: Container(
                                  height: 85
                                      .h, // Use ScreenUtil for responsive height
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xff3F6596)),
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
                                            size: 30
                                                .sp, // Use ScreenUtil for responsive icon size
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
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(PageAnimationTransition(
                        page: const Orderinfo(),
                        pageAnimationType: ScaleAnimationTransition()));
                  },
                  child: Text(
                    "Order Freight",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xff3F6596)),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 25, horizontal: 90)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ))),
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          primary: true,
          elevation: 10,
          title: Text("FREIGHT"),
          titleTextStyle: TextStyle(fontSize: 33),
          backgroundColor: BackgroundColor,
          centerTitle: true,
        ));
  }
}
