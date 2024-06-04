import 'package:Mowasil/screens/oder_info/orderinfo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({
    super.key,
    required this.widget,
  });

  final Orderinfo widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.data() == null) {
          return Container(
              width: double.infinity,
              child: Center(
                  child: AutoSizeText(
                'No Orders Found add order Now',
                style: TextStyle(fontSize: 30),
              )));
        }
        final orderData = snapshot.data!.data() as Map<String, dynamic>;
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Order Details",
                      style: TextStyle(
                          fontSize: 23, color: Color.fromARGB(255, 1, 48, 1)),
                    ),
                  ),
                  AutoSizeText(
                    '${orderData['offer'] ?? 'Unknown'} EGP',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        "PickUp:",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      AutoSizeText(
                        ' ${orderData['pickup'] ?? 'Unknown'}',
                        style: TextStyle(
                            fontSize: 19,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        "Location:",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Flexible(
                        child: AutoSizeText(
                          ' ${orderData['destination'] ?? 'Unknown'}',
                          style: TextStyle(
                              fontSize: 19,
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        "Time: ",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      AutoSizeText(
                        '${orderData['date'] ?? 'Unknown'}',
                        style: TextStyle(
                            fontSize: 19,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        "Additional Notes:",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      AutoSizeText(
                        ' ${orderData['cargo'] ?? 'Unknown'}',
                        style: TextStyle(
                            fontSize: 19,
                            color: const Color.fromARGB(255, 0, 0, 0)),
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
