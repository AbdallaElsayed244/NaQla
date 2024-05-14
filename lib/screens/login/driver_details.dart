// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// ignore: avoid_web_libraries_in_flutter

import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/helper/controllers/signup_ctrl.dart';
import 'package:Mowasil/helper/show_snack_bar.dart';
import 'package:Mowasil/screens/OrdersList/Order_list.dart';
import 'package:Mowasil/screens/login/components/custom_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class DriverDetails extends StatefulWidget {
  DriverDetails({super.key, this.driverEmail});
  final String? driverEmail;

  @override
  State<DriverDetails> createState() => _DriverDetailsState();
}

final controller = Get.put(SignupCtrl());
String? phone;
String? password;
String? username;
String? vehiclenum;
String? vehicletype;
bool _isloading = false;
GlobalKey<FormState> formkey = GlobalKey();

class _DriverDetailsState extends State<DriverDetails> {
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isloading,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: CustomScaffold(
          body: null,
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(25.0, 150.0, 25.0, 0.0),
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
                                        r'^(\+201|01|00201)[0-2,5]{1}[0-9]{8}')
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
                            TextFormField(
                              controller: controller.vehicletype,
                              onChanged: (data) {
                                vehicletype = data;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter vehicletype";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  label: Text("type of vehicle"),
                                  hintText: "type of vehicle",
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
                              controller: controller.vehiclenum,
                              keyboardType: TextInputType.number,
                              onChanged: (data) {
                                vehiclenum = data;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter vehiclenumber";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  label: Text("type vehicle number"),
                                  hintText: "type vehicle number",
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
                              height: 103,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  _isloading = true;
                                  setState(() {});
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc('${widget.driverEmail}Driver')
                                        .update({
                                      'username': username,
                                      'phone': phone,
                                      'vehicletype': vehicletype,
                                      'vehiclenum': vehiclenum,
                                    });
                                    showSnackBar(
                                        context, "Registration Successful");
                                  } catch (e) {
                                    showSnackBar(
                                        context, "something went wrong");
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Orders(
                                              driverEmail:
                                                  widget.driverEmail)));
                                } else {
                                  showSnackBar(context, "something went wrong");
                                }
                              },
                              child: Text(
                                "Done",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(ButtonsColor),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: 25, horizontal: 90)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ))),
                            )
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
}
