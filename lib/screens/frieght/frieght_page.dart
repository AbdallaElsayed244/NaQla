// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// ignore: avoid_web_libraries_in_flutter

import 'dart:math';

import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/screens/frieght/components/text_field.dart';
import 'package:Mowasil/screens/login/maps/googlemap.dart';
import 'package:Mowasil/helper/service/database.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  TextEditingController PickupController = new TextEditingController();
  TextEditingController DestinationController = new TextEditingController();
  TextEditingController datetimeController = new TextEditingController();
  TextEditingController DescribtionOfTheCargoController =
      new TextEditingController();
  TextEditingController VehicleController = new TextEditingController();
  TextEditingController OfferController = new TextEditingController();

  final GlobalKey<_FrieghtState> dropDownTextFieldKey = GlobalKey();

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
                  controller: PickupController,
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
                    controller: DestinationController,
                    name: "Destination",
                    navigate: () {}),
                TextFrieght(
                    type: TextInputType.datetime,
                    controller: datetimeController,
                    name: "Date And Time",
                    navigate: () {}),
                TextFrieght(
                    type: TextInputType.text,
                    controller: DescribtionOfTheCargoController,
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
                    controller: OfferController,
                    name: "Offer Your Car",
                    navigate: () {}),
                ElevatedButton(
                  onPressed: () async {
                    String id = generateRandomString(10);
                    Map<String, dynamic> OrderInfomap = {
                      "pickup": PickupController.text,
                      "destination": DestinationController.text,
                      "cargo": DescribtionOfTheCargoController.text,
                      "Vehicle": selectedValue,
                      "offer": OfferController.text,
                      "date": datetimeController.text,
                      "id": id,
                    };
                    // Assuming DatabaseMethods is a class, create an instance of it
                    DatabaseMethods databaseMethods = DatabaseMethods();
                    await databaseMethods
                        .addEmployeeDetails(OrderInfomap, id)
                        .then((value) {});
                    Fluttertoast.showToast(
                        msg: "Employee Details has been uploaded successfully",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 55, 102, 172),
                        textColor: Colors.white,
                        fontSize: 16.0);
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

  String generateRandomString(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
