import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/helper/service/auth_methods.dart';
import 'package:Mowasil/helper/service/orders_methods.dart';
import 'package:Mowasil/screens/oder_info/components/drawer.dart';
import 'package:Mowasil/stripe_payment/payment_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Orderinfo extends StatefulWidget {
  final String? email;
  const Orderinfo({Key? key, this.email}) : super(key: key);
  static String id = "Orderinfo";

  @override
  State<Orderinfo> createState() => _OrderinfoState();
}

class _OrderinfoState extends State<Orderinfo> {
  Stream<QuerySnapshot>? orderStream; // Stream to hold negotiationPrice data
  getonload() async {
    orderStream = FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.email)
        .collection('negotiationPrice')
        .snapshots();
  }

  Stream<bool> checkOrdersExistence() async* {
    final snapshot = await FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.email)
        .collection('negotiationPrice')
        .limit(1)
        .get();

    yield snapshot.docs.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    getonload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        email: widget.email,
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
        backgroundColor: BackgroundColor,
        elevation: 10,
        title: Text("Your Orders"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getonload();
        },
        child: StreamBuilder<bool>(
          stream: checkOrdersExistence(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData && snapshot.data!) {
              return StreamBuilder<QuerySnapshot>(
                stream: orderStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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

                  final negotiationPrices =
                      snapshot.data!.docs; // Get list of documents

                  return ListView.builder(
                    itemCount: negotiationPrices.length,
                    itemBuilder: (context, index) {
                      final doc = negotiationPrices[index];
                      final negotiationPriceData =
                          doc.data() as Map<String, dynamic>?;
                      final price = negotiationPriceData?['negotiationPrice'];

                      return Dismissible(
                        key: Key(doc.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            FirebaseFirestore.instance
                                .collection("orders")
                                .doc(widget.email)
                                .collection('negotiationPrice')
                                .doc(doc.id)
                                .delete();
                          });
                        },
                        background: Container(
                          color: Colors.red,
                          padding: EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 25),
                                    child: Text(
                                      'Driver price : ${price} EGP',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      int amount = int.parse(price);
                                      PaymentManager.makePayment(amount, "EGP");
                                    },
                                    child: Text(
                                      "Pay Now",
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: Color.fromARGB(
                                              255, 221, 204, 204)),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Color(0xff060644),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Divider(
                                color: Colors.black,
                                thickness: 1.0,
                                height: 5,
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 20, 14, 14),
                                        width: 2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: negotiationPriceData?[
                                                'profilephoto'] !=
                                            null
                                        ? ClipOval(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              height: 60,
                                              width: 60,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: InstaImageViewer(
                                                  child: Image.network(
                                                    negotiationPriceData?[
                                                        'profilephoto'],
                                                    scale: 5,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      } else {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      }
                                                    },
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
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${negotiationPriceData?['username']}',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                      ),
                                      Text(
                                        '${negotiationPriceData?['phone']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                      ),
                                      Text(
                                        '${negotiationPriceData?['vehicletype']} - ${negotiationPriceData?['vehiclenum']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'Add an Order Now',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(255, 145, 136, 136),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
