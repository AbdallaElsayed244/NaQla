import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/helper/models/users.dart';
import 'package:Mowasil/helper/service/orders_methods.dart';
import 'package:Mowasil/screens/oder_info/components/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:loading_indicator/loading_indicator.dart';

class OrdersContainer extends StatefulWidget {
  OrdersContainer({
    Key? key,
    this.email,
  }) : super(key: key);
  final String? email;

  @override
  State<OrdersContainer> createState() => _OrdersContainerState();
}

class _OrdersContainerState extends State<OrdersContainer> {
  Stream? orderStream;

  getonload() async {
    orderStream = await OrderseMethods().getOederDetails();
    setState(() {});
  }

  void printUser(UserModel user) {
    print(user);
  }

  @override
  void initState() {
    super.initState();
    getonload();
  }

  Widget Allordersdetail({
    required Stream<dynamic>? orderStream,
    required bool showOnlyFirst,
  }) {
    return RefreshIndicator(
      onRefresh: () async {
        await getonload();
      },
      child: StreamBuilder(
        stream: orderStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final orders = snapshot.data.docs;
            if (orders.isEmpty) {
              return Center(
                child: Text(
                  'No Orders Right Now',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(255, 145, 136, 136),
                  ),
                ),
              );
            }

            final firstOrder = orders.first;
            final remainingOrders = orders.sublist(1);

            return Column(
              children: [
                if (showOnlyFirst) OrderDetailsContainer(order: firstOrder),
                if (!showOnlyFirst)
                  Expanded(
                    child: ListView.builder(
                      itemCount: remainingOrders.length,
                      itemBuilder: (context, index) {
                        final ds = remainingOrders[index];
                        return OrderDetailsContainer(order: ds);
                      },
                    ),
                  ),
              ],
            );
          } else {
            return Center(
              child: Container(
                width: 100,
                height: 100,
                child: const LoadingIndicator(
                  indicatorType: Indicator.ballPulse,
                  colors: [Color.fromARGB(255, 63, 63, 77)],
                  strokeWidth: 0.6,
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  pathBackgroundColor: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Allordersdetail(
        orderStream: orderStream,
        showOnlyFirst: false,
      ),
    );
  }
}

class OrderDetailsContainer extends StatelessWidget {
  final DocumentSnapshot order;

  const OrderDetailsContainer({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ds = order;
    return FutureBuilder(
      future:
          FirebaseFirestore.instance.collection('Users').doc(ds['id']).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              width: 100,
              height: 100,
              child: const LoadingIndicator(
                indicatorType: Indicator.ballPulse,
                colors: [Color.fromARGB(255, 63, 63, 77)],
                strokeWidth: 0.6,
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                pathBackgroundColor: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          );
        }
        if (userSnapshot.hasError) {
          return Text('Error: ${userSnapshot.error}');
        }
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return SizedBox();
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 207, 203, 203),
            ),
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromARGB(255, 199, 198, 198),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' ${ds['offer']} EGP',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                ' ${ds['cargo']} ',
                style: TextStyle(
                  fontSize: 19,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Text(
                'Location: ${ds['pickup']}',
                style: TextStyle(
                  fontSize: 19,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              if (ds['date'] != null)
                Text(
                  'Time: ${ds['date']}',
                  style: TextStyle(
                    fontSize: 19,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              if (ds['destination'] != null)
                Text(
                  'Additional Notes: ${ds['destination']}',
                  style: TextStyle(
                    fontSize: 19,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              SizedBox(height: 30),
              Divider(
                color: Colors.black,
                thickness: 1.0,
                height: 5,
              ),
            ],
          ),
        );
      },
    );
  }
}
