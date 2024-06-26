import 'package:Naqla/helper/order_history_add.dart';
import 'package:Naqla/screens/User/oder_info/orderinfo.dart';
import 'package:Naqla/helper/app_colors.dart';
import 'package:Naqla/helper/show_message.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({
    super.key,
    required this.widget,
  });

  final Orderinfo widget;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.widget.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.data() == null) {
          return Container(
              width: double.infinity,
              child: const Center(
                  child: AutoSizeText(
                'No Orders Found add order Now',
                style: TextStyle(fontSize: 30),
              )));
        }
        final orderData = snapshot.data!.data() as Map<String, dynamic>;
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Order Details",
                          style: TextStyle(
                              fontSize: 23,
                              color: Color.fromARGB(255, 1, 48, 1)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: AutoSizeText(
                          '${orderData['offer'] ?? 'Unknown'} EGP',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        showMessage(
                          context,
                          'Delete your order and all the requests with it',
                          () async {
                            // Show loading indicator
                            setState(() {});

                            try {
                              // Delete the document from the orders collection

                              // Delete the negotiationPrice sub-collection
                              await FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(widget.widget.email)
                                  .collection('negotiationPrice')
                                  .doc()
                                  .delete();
                              await transferDocument(
                                  'orders',
                                  widget.widget.email,
                                  widget.widget.email,
                                  "orders_History",
                                  "canceled");
                              await FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(widget.widget.email)
                                  .delete();
                              // Update the state and start the animation
                            } catch (e) {
                              // Handle errors here if necessary
                              print(e);
                            } finally {
                              // Hide loading indicator
                              setState(() {});
                            }
                          },
                          () {},
                          'Cancel Order', // Title of the confirmation dialog
                          "Cancel", // Text for the positive action button
                          "no", // Text for the negative action button
                          DialogType.error, // Type of the dialog
                        );
                      },
                      child: const Text(
                        "Cancel Order",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                              (states) => ButtonsColor2),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: Colors.black, width: 1)))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AutoSizeText(
                        "PickUp:",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Flexible(
                        child: AutoSizeText(
                          ' ${orderData['pickup'] ?? 'Unknown'}',
                          style: const TextStyle(
                              fontSize: 19,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AutoSizeText(
                        "Location:",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Flexible(
                        child: AutoSizeText(
                          ' ${orderData['destination'] ?? 'Unknown'}',
                          style: const TextStyle(
                              fontSize: 19,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AutoSizeText(
                        "Time: ",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      AutoSizeText(
                        '${orderData['date'] ?? 'Unknown'}',
                        style: const TextStyle(
                            fontSize: 19, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AutoSizeText(
                        "Additional Notes:",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      AutoSizeText(
                        ' ${orderData['cargo'] ?? 'Unknown'}',
                        style: const TextStyle(
                            fontSize: 19, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
