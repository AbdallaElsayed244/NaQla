import 'package:Naqla/helper/app_colors.dart';
import 'package:Naqla/screens/User/frieght/components/have_order.dart';
import 'package:Naqla/screens/User/frieght/components/text_field.dart';
import 'package:Naqla/screens/maps/googlemap%20copy.dart';
import 'package:Naqla/screens/maps/googlemap.dart';
import 'package:Naqla/helper/service/orders_methods.dart';
import 'package:Naqla/screens/User/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();

  TextEditingController PickupController = TextEditingController();
  TextEditingController DestinationController = TextEditingController();
  TextEditingController datetimeController = TextEditingController();
  TextEditingController DescribtionOfTheCargoController =
      TextEditingController();
  TextEditingController VehicleController = TextEditingController();
  TextEditingController OfferController = TextEditingController();

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
                overlayColor: WidgetStateProperty.all(BackgroundColor),
                fillColor: WidgetStateProperty.all(BackgroundColor),
                checkColor: WidgetStateProperty.all(BackgroundColor)),
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
    List<String> options = ['نقل', 'نص نقل', 'ربع نقل ', 'تروسيكل'];

    String selectedValue = options[0];

    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("images/Order.jpg"),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 150),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFrieght(
                      type: TextInputType.streetAddress,
                      icon: const Icon(Icons.location_pin),
                      controller:
                          TextEditingController(text: widget.locationString),
                      name: "Pickup Location",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the pickup location';
                        }
                        return null;
                      },
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
                      icon: const Icon(Icons.location_pin),
                      type: TextInputType.streetAddress,
                      controller:
                          TextEditingController(text: widget.locationString2),
                      name: "Destination",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the destination';
                        }
                        return null;
                      },
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
                        icon: const Icon(Icons.calendar_month_outlined),
                        type: TextInputType.datetime,
                        controller: datetimeController,
                        name: "Pickup Date ",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                        ontap: () => _selectDate(context)),
                    TextFrieght(
                        icon: const Icon(Icons.description),
                        type: TextInputType.text,
                        controller: DescribtionOfTheCargoController,
                        name: "Description Of The Cargo",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe the cargo';
                          }
                          return null;
                        },
                        ontap: () {
                          Fluttertoast.showToast(
                            msg: "descripe the cargo that will be delivered",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: MessageColor,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 21),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 350,
                      height: 70,
                      child: DropDownTextField(
                          dropDownList: const [
                            DropDownValueModel(name: 'نقل', value: "value5"),
                            DropDownValueModel(name: 'نص نقل', value: "value6"),
                            DropDownValueModel(
                                name: 'ربع نقل ', value: "value7"),
                            DropDownValueModel(
                                name: 'تروسيكل', value: "value8"),
                          ],
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
                            hintStyle: const TextStyle(fontSize: 18),
                            labelStyle: const TextStyle(fontSize: 33),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.vertical_shades_sharp),
                              iconSize: 40,
                              onPressed: () {},
                            ),
                          )),
                    ),
                    TextFrieght(
                        icon: const Icon(Icons.price_change),
                        type: TextInputType.number,
                        controller: OfferController,
                        name: "Offer Your Price",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please offer a price';
                          }
                          return null;
                        },
                        ontap: () {
                          Fluttertoast.showToast(
                            msg: "set price for the delivery",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: MessageColor,
                            textColor: Colors.white,
                            fontSize: 18.0,
                          );
                        }),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) {
                                // If form is not valid, show a Flutter toast
                                Fluttertoast.showToast(
                                  msg: "Please fill all required fields",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      const Color.fromARGB(255, 204, 18, 49),
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }

                              setState(() {
                                _isLoading = true; // Start loading
                              });

                              Map<String, dynamic> OrderInfomap = {
                                "pickup": widget.locationString?.trim(),
                                "destination": widget.locationString2?.trim(),
                                "cargo": DescribtionOfTheCargoController.text,
                                "Vehicle": selectedValue,
                                "offer": OfferController.text,
                                "date": datetimeController.text,
                                "id": email,
                              }; // adding order data to database

                              // Check if data already exists in Firestore
                              bool isDuplicate =
                                  await checkDuplicateData(OrderInfomap);
                              if (isDuplicate) {
                                // Show Flutter toast indicating duplicate data
                                Fluttertoast.showToast(
                                  msg: "Duplicate data! Order already exists",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      const Color.fromARGB(255, 204, 18, 49),
                                  textColor: Colors.white,
                                  fontSize: 26.0,
                                );
                              } else {
                                // Check if there's already an order with this email
                                bool hasExistingOrder =
                                    await checkExistingOrderByEmail(email!);
                                if (hasExistingOrder) {
                                  Fluttertoast.showToast(
                                    msg: "You already added an order",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        const Color.fromARGB(255, 204, 18, 49),
                                    textColor: Colors.white,
                                    fontSize: 26.0,
                                  );
                                } else if (hasExistingOrder == false) {
                                  // Add data to Firestore if not duplicate
                                  try {
                                    OrderseMethods databaseMethods =
                                        OrderseMethods(); // calling database methods
                                    await databaseMethods.addOrderDetails(
                                        OrderInfomap, email);
                                    Fluttertoast.showToast(
                                      msg:
                                          "Order Details have been uploaded successfully",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: MessageColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    // Navigate to Orderinfo page
                                    Navigator.of(context).push(
                                      PageAnimationTransition(
                                        page: Orderinfo(
                                          email: widget.email,
                                        ),
                                        pageAnimationType:
                                            ScaleAnimationTransition(),
                                      ),
                                    );
                                  } catch (error) {
                                    _showErrorDialog(
                                        "Error saving data: $error");
                                  } finally {
                                    setState(() {
                                      _isLoading = false; // Stop loading
                                    });
                                  }
                                }
                              }
                            },
                      child: _isLoading // Step 3
                          ? const CircularProgressIndicator() // Render loading indicator
                          : const Text(
                              "Confirm Order",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(ButtonsColor2),
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 90)),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ))),
                    ),
                    const SizedBox(height: 19),
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
          ),
        ),
        drawer: CustomDrawer(
          email: widget.email,
        ),
        appBar: AppBar(
          primary: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            "Add Order",
            style: TextStyle(color: Colors.black),
          ),
          titleTextStyle: const TextStyle(fontSize: 33),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Orderinfo(
                              email: widget.email,
                            )));
              },
              icon: const Icon(
                Icons.moped,
                size: 30,
              ),
            )
          ],
        ));
  }

  Future<bool> checkDuplicateData(Map<String, dynamic> orderInfoMap) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('pickup', isEqualTo: orderInfoMap['pickup'])
        .where('destination', isEqualTo: orderInfoMap['destination'])
        .where('cargo', isEqualTo: orderInfoMap['cargo'])
        .where('Vehicle', isEqualTo: orderInfoMap['Vehicle'])
        .where('offer', isEqualTo: orderInfoMap['offer'])
        .where('date', isEqualTo: orderInfoMap['date'])
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> checkExistingOrderByEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('id', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  void _showErrorDialog(String errorMessage) {
    Fluttertoast.showToast(
        msg: "complete any missing field:\n",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 219, 31, 56),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
