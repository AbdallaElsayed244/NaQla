import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/helper/show_message.dart';
import 'package:Mowasil/screens/OrdersList/components/driver_drawer.dart';
import 'package:Mowasil/screens/OrdersList/components/order_confirm.dart';
import 'package:Mowasil/screens/OrdersList/components/timeline_manage.dart';
import 'package:Mowasil/stripe_payment/payment_manager.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:loading_indicator/loading_indicator.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({Key? key, this.driverEmail}) : super(key: key);
  static String id = "Orderinfo";
  final String? driverEmail;

  @override
  State<OrderStatus> createState() => _OrderinfoState();
}

double screenHeight = 0;
double screenWidth = 0;
String useremail = '';

class _OrderinfoState extends State<OrderStatus>
    with SingleTickerProviderStateMixin {
  bool startanimation = false;
  bool isLoading = false;
  late AnimationController _controller;

  List<Function()> onPressed = [
    () {
      FirebaseFirestore.instance
          .collection('TimeLine')
          .doc(useremail)
          .update({'Pickup': false});
      print("Button 1 pressed");
    },
    () {
      FirebaseFirestore.instance
          .collection('TimeLine')
          .doc(useremail)
          .update({'coming': false});
      print("Button 2 pressed");
    },
    () {
      FirebaseFirestore.instance
          .collection('TimeLine')
          .doc(useremail)
          .update({'arrived': false});
      print("Button 3 pressed");
    },
  ]; // Define the onPressed list here

  @override
  void initState() {
    super.initState();
    getonload();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? orderStream;
  getonload() {
    setState(() {
      orderStream = FirebaseFirestore.instance
          .collection('Acceptance')
          .doc(widget.driverEmail)
          .snapshots();
    });
  }

  Future<bool> checkOrdersExistence() async {
    final doc = await FirebaseFirestore.instance
        .collection('Acceptance')
        .doc(widget.driverEmail)
        .get();
    return doc.exists;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: DriverDrawer(
        email: widget.driverEmail,
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              size: 30,
            ),
          )
        ],
        elevation: 0,
        title: Text(
          "Your Order Requests",
          style: TextStyle(
              fontSize: 24, color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/Order-info2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<bool>(
            future: checkOrdersExistence(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulse,
                    colors: [Color.fromARGB(255, 62, 99, 64)],
                    strokeWidth: 0.6,
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    pathBackgroundColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                );
              }

              if (snapshot.hasData && snapshot.data!) {
                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: orderStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(
                        child: Text(
                          'No Drivers Right Now',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color.fromARGB(255, 145, 136, 136),
                          ),
                        ),
                      );
                    }

                    final Acceptance = snapshot.data!.data();
                    final price = Acceptance?['offer'];

                    return ListView(
                      children: [
                        OrderConfirmation(
                            Acceptance: Acceptance,
                            price: price,
                            onPressed: () {
                              showMessage(
                                context,
                                'To deliver the package you should pay the fees',
                                () async {
                                  // Show loading indicator
                                  setState(() {
                                    isLoading = true;
                                  });

                                  try {
                                    // Retrieve the user's email from the Acceptance object
                                    useremail = Acceptance?['email'];

                                    // Parse the price and handle any potential null values
                                    int amount = int.parse(price ?? '0');

                                    // Process the payment
                                    await PaymentManager.makePayment(
                                        amount, "EGP");

                                    // Update the TimeLine collection in Firestore
                                    await FirebaseFirestore.instance
                                        .collection('TimeLine')
                                        .doc(useremail)
                                        .set({
                                      'email': widget.driverEmail,
                                      'Confirmed': false,
                                      'Pickup': true,
                                      'coming': true,
                                      'arrived': true,
                                    });

                                    // Delete the document from the orders collection
                                    await FirebaseFirestore.instance
                                        .collection('orders')
                                        .doc(useremail)
                                        .delete();

                                    // Delete the negotiationPrice sub-collection
                                    await FirebaseFirestore.instance
                                        .collection('orders')
                                        .doc(useremail)
                                        .collection('negotiationPrice')
                                        .doc()
                                        .delete();

                                    // Update the state and start the animation
                                    setState(() {
                                      startanimation = true;
                                    });
                                    _controller.forward();
                                  } catch (e) {
                                    // Handle errors here if necessary
                                    print(e);
                                  } finally {
                                    // Hide loading indicator
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                () {},
                                'Begin Ride', // Title of the confirmation dialog
                                "Pay Now", // Text for the positive action button
                                "Cancel", // Text for the negative action button
                                DialogType.noHeader, // Type of the dialog
                              );
                            },
                            driveremail: widget.driverEmail),
                        AnimatedContainer(
                          height: screenHeight / 2,
                          width: screenWidth,
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 300),
                          transform: Matrix4.translationValues(
                              startanimation ? 0 : screenWidth, 0, 0),
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth / 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListScreen(
                            driveremail: widget.driverEmail,
                            startAnimation: startanimation,
                            onPressed:
                                onPressed, // Pass the onPressed functions
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return Center(
                  child: Text(
                    'No Offers Accepted For Now',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(255, 145, 136, 136),
                    ),
                  ),
                );
              }
            },
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}