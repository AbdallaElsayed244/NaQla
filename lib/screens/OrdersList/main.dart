// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, prefer_const_literals_to_create_immutables, unused_local_variable, deprecated_member_use, unused_import, avoid_web_libraries_in_flutter, unnecessary_import, use_super_parameters, must_be_immutable

import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/screens/OrdersList/components/order.dart';
import 'package:Mowasil/screens/OrdersList/components/orderData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'components/custom_switch_btn.dart';

class Orders extends StatelessWidget {
  Orders({Key? key}) : super(key: key);

  List<Map<String, dynamic>> orderItems = appdata.orderItems;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor,
        elevation: 10,
        title: Text("ORDERS"),
        centerTitle: true,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu, size: 33)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_forward,
                size: 30,
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: orderItems.length,
        itemBuilder: (context, index) {
          final orderItem = orderItems[index];
          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 207, 203, 203)),
              borderRadius: BorderRadius.circular(50),
              color: const Color.fromARGB(255, 199, 198, 198),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      ' ${orderItem['Price']} EGP',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 283),
                    SizedBox(
                      width: 100, // <-- match_parent
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Start",
                            style: TextStyle(
                                fontSize: 19,
                                color: Color.fromARGB(255, 221, 204, 204))),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xff060644))),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Text('Quantity: ${orderItem['Quantity']}',
                    style: TextStyle(
                        fontSize: 19,
                        color: const Color.fromARGB(255, 0, 0, 0))),
                Text(
                  ' ${orderItem['Item']} ',
                  style: TextStyle(
                      fontSize: 19, color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                Text(
                  'Location: ${orderItem['Location']}',
                  style: TextStyle(
                      fontSize: 19, color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                if (orderItem['Time'] != null)
                  Text(
                    'Time: ${orderItem['Time']}',
                    style: TextStyle(
                        fontSize: 19,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                if (orderItem['Additional Notes'] != null)
                  Text(
                    'Additional Notes: ${orderItem['Additional Notes']}',
                    style: TextStyle(
                        fontSize: 19,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                SizedBox(
                  height: 30,
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1.0,
                  height: 5, // Adjust thickness as needed
                  // Optional: Set width for better alignment
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 20, 14, 14),
                        width: 2), // Outline
                    shape: BoxShape.circle,
                  ),
                  padding:
                      EdgeInsets.all(8), // Adjust padding for icon placement
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.black, // Adjust color as needed
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
