import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/helper/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'components/custom_switch_btn.dart';

class Orders extends StatefulWidget {
  Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Stream? OrderStream;
  getonload() async {
    OrderStream = await DatabaseMethods().getOederDetails();
    setState(() {});
  }

  @override
  void initState() {
    getonload();
    super.initState();
  }

  Widget Allordersdetail() {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: OrderStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.docs?.length ?? 0,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 207, 203, 203)),
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
                                ' ${ds['offer']} EGP',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 233),
                              SizedBox(
                                width: 100,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text("Start",
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: Color.fromARGB(
                                              255, 221, 204, 204))),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xff060644))),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            ' ${ds['cargo']} ',
                            style: TextStyle(
                                fontSize: 19,
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          Text(
                            'Location: ${ds['pickup']}',
                            style: TextStyle(
                                fontSize: 19,
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          if (ds['date'] != null)
                            Text(
                              'Time: ${ds['date']}',
                              style: TextStyle(
                                  fontSize: 19,
                                  color: const Color.fromARGB(255, 0, 0, 0)),
                            ),
                          if (ds['destination'] != null)
                            Text(
                              'Additional Notes: ${ds['destination']}',
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
                            height: 5,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromARGB(255, 20, 14, 14),
                                  width: 2),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BackgroundColor,
          elevation: 10,
          title: Text("ORDERS"),
          centerTitle: true,
          leading:
              IconButton(onPressed: () {}, icon: Icon(Icons.menu, size: 33)),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_forward,
                  size: 30,
                ))
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(11),
          child: Column(
            children: [Expanded(child: Allordersdetail())],
          ),
        ));
  }
}
