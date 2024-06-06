import 'dart:ffi';

import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/helper/show_message.dart';
import 'package:Mowasil/User/OrderStatus/order_timeline.dart';
import 'package:Mowasil/screens/login/driver_details.dart';
import 'package:Mowasil/stripe_payment/payment_manager.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:loading_indicator/loading_indicator.dart';

class OrderRequests extends StatelessWidget {
  const OrderRequests({
    super.key,
    required this.negotiationPriceData,
    this.price,
    this.email,
    this.index,
    this.Driveremail,
  });

  final Map<String, dynamic>? negotiationPriceData;
  final price;
  final String? email;
  final String? index;
  final dynamic Driveremail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(50),
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 20, 14, 14),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: negotiationPriceData?['profilephoto'] != null
                    ? ClipOval(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          height: 60,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => LoadingIndicator(
                                indicatorType: Indicator.ballPulse,
                                colors: [Color.fromARGB(255, 62, 99, 64)],
                                strokeWidth: 0.6,
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                pathBackgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                              ),
                              imageUrl: negotiationPriceData?['profilephoto'],
                              imageBuilder: (context, imageProvider) =>
                                  InstaImageViewer(
                                child: Image.network(
                                  negotiationPriceData?['profilephoto'],
                                  scale: 5,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: LoadingIndicator(
                                          indicatorType: Indicator.ballPulse,
                                          colors: [
                                            Color.fromARGB(255, 62, 99, 64)
                                          ],
                                          strokeWidth: 0.6,
                                          backgroundColor: Color.fromARGB(
                                              255, 255, 255, 255),
                                          pathBackgroundColor: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Flexible(
                      child: AutoSizeText(
                        'Driver price : ${price} EGP',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 50,
                          ),
                          AutoSizeText(
                            '${negotiationPriceData?['username']}',
                            style: TextStyle(
                              fontSize: 24,
                              color: Color.fromARGB(255, 82, 177, 82),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          AutoSizeText(
                            '${negotiationPriceData?['vehicletype']} - ${negotiationPriceData?['vehiclenum']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                      AutoSizeText(
                        '${negotiationPriceData?['phone']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                showMessage(
                    context, 'Are you sure you want to accept this offer?',
                    () async {
                  await OfferAcceptance(context);
                }, () {}, 'Accept Offer', "Accept", "cancle",
                    DialogType.noHeader);
              },
              child: AutoSizeText(
                "Accept",
                style: TextStyle(fontSize: 19, color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  ButtonsColor2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> OfferAcceptance(BuildContext context) async {
    var data =
        await FirebaseFirestore.instance.collection('Users').doc(email).get();
    Map<String, dynamic>? user;
    if (data.exists) {
      user = data.data() as Map<String, dynamic>;
    } else {
      print('No such document!');
    }
    await FirebaseFirestore.instance
        .collection("Acceptance")
        .doc(Driveremail)
        .set({
      'offer': price,
      'profilephoto': user?['profilePhoto'] ?? null,
      'username': user?['username'],
      'email': user?['email'],
      'phone': user?['phone'],
    });

    Fluttertoast.showToast(
      msg: "Offer Accepted",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: MessageColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    // Debugging print statement to ensure navigation is being called
    print('Navigating to TimelineComponent');

    // Ensure that the Navigator push is called after all async operations
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              TimelineComponent(email: email, driverEmail: Driveremail)),
    );
  }
}
