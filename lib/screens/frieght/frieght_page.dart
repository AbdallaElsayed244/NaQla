// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// ignore: avoid_web_libraries_in_flutter

import 'dart:math';

import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/helper/controllers/signup_ctrl.dart';
import 'package:Mowasil/helper/service/auth_methods.dart';
import 'package:Mowasil/screens/frieght/components/have_order.dart';
import 'package:Mowasil/screens/frieght/components/text_field.dart';
import 'package:Mowasil/screens/login/maps/googlemap%20copy.dart';
import 'package:Mowasil/screens/login/maps/googlemap.dart';
import 'package:Mowasil/helper/service/orders_methods.dart';
import 'package:Mowasil/screens/oder_info/components/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_animation_transition/animations/scale_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import '../oder_info/orderinfo.dart';

class Frieght extends StatefulWidget {
  Frieght({super.key, this.email, this.locationString, this.locationString2});
  static String id = "Frieght";
  final String? email;
  final String? locationString;
  final String? locationString2;

  @override
  State<Frieght> createState() => _FrieghtState(email: email);
}

class _FrieghtState extends State<Frieght> {
  TextEditingController PickupController = new TextEditingController();
  TextEditingController DestinationController = new TextEditingController();
  TextEditingController datetimeController = TextEditingController();
  TextEditingController DescribtionOfTheCargoController =
      new TextEditingController();
  TextEditingController VehicleController = new TextEditingController();
  TextEditingController OfferController = new TextEditingController();
  FocusNode _focusNode = FocusNode();

  final GlobalKey<_FrieghtState> dropDownTextFieldKey = GlobalKey();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            checkboxTheme: CheckboxThemeData(
                overlayColor: MaterialStateProperty.all(BackgroundColor),
                fillColor: MaterialStateProperty.all(BackgroundColor),
                checkColor: MaterialStateProperty.all(BackgroundColor)),
            // Background color of the calendar picker
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      String formattedDate = "${picked.year}-${picked.month}-${picked.day}";
      datetimeController.text = formattedDate;
    }
  }

  _FrieghtState({this.email});
  final String? email;

  @override
  Widget build(BuildContext context) {
    // Define a list of options

    List<String> options = ['نقل', 'نص نقل', 'ربع نقل ', 'تروسيكل'];

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
                  icon: Icon(Icons.location_pin),
                  controller:
                      TextEditingController(text: widget.locationString),
                  name: "Pickup Location",
                  ontap: () {
                    Navigator.of(context).push(PageAnimationTransition(
                      page: GoogleMapPage(
                        email: widget.email,
                        locationString2: widget.locationString2,
                      ),
                      pageAnimationType: ScaleAnimationTransition(),
                    ));
                  },
                ),
                TextFrieght(
                  icon: Icon(Icons.location_pin),
                  type: TextInputType.streetAddress,
                  controller:
                      TextEditingController(text: widget.locationString2),
                  name: "Destination",
                  ontap: () {
                    Navigator.of(context).push(PageAnimationTransition(
                      page: GoogleMapPage2(
                        email: widget.email,
                        locationString: widget.locationString,
                      ),
                      pageAnimationType: ScaleAnimationTransition(),
                    ));
                  },
                ),
                TextFrieght(
                    icon: Icon(Icons.calendar_month_outlined),
                    type: TextInputType.datetime,
                    controller: datetimeController,
                    name: "Pickup Date ",
                    ontap: () => _selectDate(context)),
                TextFrieght(
                    icon: Icon(Icons.description),
                    type: TextInputType.text,
                    controller: DescribtionOfTheCargoController,
                    name: "description Of The Cargo",
                    ontap: () {
                      Fluttertoast.showToast(
                        msg: "descripe the cargo that will be delivered",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 18, 151, 204),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  padding: EdgeInsets.symmetric(horizontal: 21),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: 350,
                  height: 70,
                  child: DropDownTextField(
                      dropDownList: [
                        DropDownValueModel(name: 'نقل', value: "value5"),
                        DropDownValueModel(name: 'نص نقل', value: "value6"),
                        DropDownValueModel(name: 'ربع نقل ', value: "value7"),
                        DropDownValueModel(name: 'تروسيكل', value: "value8"),
                      ],
                      dropdownColor: Colors.white,
                      dropDownIconProperty: IconProperty(
                        icon: Icons.keyboard_arrow_down,
                        color: Colors.black,
                        size: 40,
                      ),
                      
                      clearIconProperty: IconProperty(
                        icon: Icons.close,
                        color: Colors.black,
                        size: 40,
                      ),
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
                          // Remove focus to close the dropdown
                          FocusScope.of(context).unfocus();
                        });
                      },
                      textFieldDecoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Vehicle Size",
                        hintStyle: TextStyle(fontSize: 18),
                        labelStyle: TextStyle(fontSize: 33),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.vertical_shades_sharp),
                          iconSize: 40,
                          onPressed: () {},
                        ),
                      )),
                ),
                TextFrieght(
                    icon: Icon(Icons.price_change),
                    type: TextInputType.number,
                    controller: OfferController,
                    name: "Offer Your Price",
                    ontap: () {
                      Fluttertoast.showToast(
                        msg: "set price for the delivery",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 18, 151, 204),
                        textColor: Colors.white,
                        fontSize: 18.0,
                      );
                    }),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() {
                            _isLoading = true; // Start loading
                          });

                          // 1. Validate form fields and build error message
                          if (widget.locationString!.isEmpty ||
                              widget.locationString2!.isEmpty ||
                              DescribtionOfTheCargoController.text.isEmpty ||
                              selectedValue.isEmpty ||
                              OfferController.text.isEmpty ||
                              datetimeController.text.isEmpty) {
                            // Show Flutter toast indicating all fields are required
                            Fluttertoast.showToast(
                              msg: "All fields are required",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 204, 18, 49),
                              textColor: Colors.white,
                              fontSize: 26.0,
                            );
                            return; // Exit the function early
                          }

                          Map<String, dynamic> OrderInfomap = {
                            "pickup": widget.locationString?.trim(),
                            "destination": widget.locationString2?.trim(),
                            "cargo": DescribtionOfTheCargoController.text,
                            "Vehicle": selectedValue,
                            "offer": OfferController.text,
                            "date": datetimeController.text,
                            "id": email,
                          };
                          // Assuming DatabaseMethods is a class, create an instance of it
                          // Check if data already exists in Firestore
                          bool isDuplicate = await checkDuplicateData(
                            OrderInfomap,
                          );

                          if (isDuplicate) {
                            // Show Flutter toast indicating duplicate data
                            Fluttertoast.showToast(
                              msg: "Duplicate data! Order already exists",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 204, 18, 49),
                              textColor: Colors.white,
                              fontSize: 26.0,
                            );
                          } else {
                            // Add data to Firestore if not duplicate
                            try {
                              OrderseMethods databaseMethods = OrderseMethods();
                              await databaseMethods.addOrderDetails(
                                  OrderInfomap, email);
                              Fluttertoast.showToast(
                                msg:
                                    "Order Details has been uploaded successfully",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    Color.fromARGB(255, 55, 102, 172),
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            } catch (error) {
                              _showErrorDialog("Error saving data: $error");
                            } finally {
                              setState(() {
                                _isLoading = false; // Stop loading
                              });
                            }

                            Navigator.of(context).push(
                              PageAnimationTransition(
                                page: Orderinfo(
                                  email: widget.email,
                                ),
                                pageAnimationType: ScaleAnimationTransition(),
                              ),
                            );
                          }
                        },
                  child: _isLoading // Step 3
                      ? CircularProgressIndicator() // Render loading indicator
                      : Text(
                          "Order Freight",
                          style: TextStyle(
                              fontSize: 25,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(ButtonsColor),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 25, horizontal: 90)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ))),
                ),
                SizedBox(height: 19),
                HaveOrder(
                  function: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Orderinfo(email: email)),
                    );
                  },
                )
              ],
            ),
          ),
        ),
        drawer: CustomDrawer(
          email: widget.email,
        ),
        appBar: AppBar(
          primary: true,
          elevation: 10,
          title: Text(
            "FREIGHT",
            style: TextStyle(color: Colors.black),
          ),
          titleTextStyle: TextStyle(fontSize: 33),
          backgroundColor: BackgroundColor,
          centerTitle: true,
        ));
  }

  Future<bool> checkDuplicateData(Map<String, dynamic> orderInfoMap) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(
            'your_collection_name') // Replace 'your_collection_name' with your actual collection name
        .where('pickup', isEqualTo: orderInfoMap['pickup'])
        .where('destination', isEqualTo: orderInfoMap['destination'])
        .where('cargo', isEqualTo: orderInfoMap['cargo'])
        .where('Vehicle', isEqualTo: orderInfoMap['Vehicle'])
        .where('offer', isEqualTo: orderInfoMap['offer'])
        .where('date', isEqualTo: orderInfoMap['date'])
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

// Function to display an error dialog
  void _showErrorDialog(String errorMessage) {
    Fluttertoast.showToast(
        msg: "complete any missing field:\n",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 219, 31, 56),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
