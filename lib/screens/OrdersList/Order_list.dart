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

class Orders extends StatefulWidget {
  Orders({
    Key? key,
    this.driverEmail,
  }) : super(key: key);
  final String? driverEmail;
  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Stream? OrderStream;
  getonload() async {
    OrderStream = await OrderseMethods().getOederDetails();
    setState(() {});
  }

  void printUser(UserModel user) {
    print(user);
  }

  @override
  void initState() {
    super.initState();
    // Remove the automatic loading of data
    getonload();
  }

  Widget Allordersdetail({
    required Stream<dynamic>? orderStream,
  }) {
    return RefreshIndicator(
      onRefresh: () async {
        // Perform actions to refresh the list
        await getonload();
      },
      child: StreamBuilder(
        stream: orderStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.docs?.length ?? 0,
              itemBuilder: (context, index) {
                final DocumentSnapshot ds = snapshot.data.docs[index];
                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(ds['id'])
                      .get(),
                  builder:
                      (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                          child: Container(
                        width: 100,
                        height: 100,
                        child: const LoadingIndicator(
                            indicatorType: Indicator.ballPulse,

                            /// Required, The loading type of the widget
                            colors: [
                              Color.fromARGB(255, 63, 63, 77),
                            ],

                            /// Optional, The color collections
                            strokeWidth: 0.6,

                            /// Optional, The stroke of the line, only applicable to widget which contains line
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),

                            /// Optional, Background of the widget
                            pathBackgroundColor:
                                Color.fromARGB(255, 255, 255, 255)

                            /// Optional, the stroke backgroundColor
                            ),
                      ));
                    }
                    if (userSnapshot.hasError) {
                      return Text('Error: ${userSnapshot.error}');
                    }
                    if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                      return SizedBox();
                    }

                    final userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) => (ds),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ' ${ds['offer']} EGP',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _showDialog(context, index, ds);
                                      },
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
                                  ],
                                ),
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
                                      color:
                                          const Color.fromARGB(255, 20, 14, 14),
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),

                                  child: userData['profilePhoto'] != null
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
                                                  userData['profilePhoto'],
                                                  scale: 5,
                                                  fit: BoxFit.contain,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    } else {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(), // You can customize the loading indicator here
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
                                        ), // Empty container to maintain layout
                                ),
                                SizedBox(width: 15),
                                Text(
                                  '${userData['username']}',
                                  style: TextStyle(
                                      fontSize: 19,
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
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
            return Container(
              padding: EdgeInsets.all(10),
              child: Text(
                'No Orders Right Now',
                style: TextStyle(
                    fontSize: 70, color: Color.fromARGB(255, 145, 136, 136)),
              ),
            );
          }
        },
      ),
    );
  }

  void _showDialog(
      BuildContext context, int index, DocumentSnapshot<Object?> ds) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String _text = '';

        return AlertDialog(
          title: Text('Negotiate'),
          content: TextFormField(
            onChanged: (value) {
              _text = value;
            },
            decoration: InputDecoration(hintText: 'Enter negotiation price'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                var data = await FirebaseFirestore.instance
                    .collection('Users')
                    .doc("${widget.driverEmail}Driver")
                    .get();
                Map<String, dynamic>? user;
                if (data.exists) {
                  user = data.data() as Map<String, dynamic>;
                  // Further processing with the user data...
                } else {
                  // Handle the case where the data doesn't exist
                  if (kDebugMode) {
                    print('User data does not exist.');
                  }
                }
                // Create a new document with negotiation price and index
                await FirebaseFirestore.instance
                    .collection('orders')
                    .doc(ds['id'])
                    .collection("negotiationPrice")
                    .doc(widget.driverEmail)
                    .set({
                  'negotiationPrice': _text,
                  'profilephoto': user?['profilePhoto'] ?? null,
                  'license': user?['license'] ?? null,
                  'nationalcard': user?['nationalcard'] ?? null,
                  'username': user?['username'],
                  'vehiclereg': user?['vehiclereg'] ?? null,
                  'vehiclenum': user?['vehiclenum'],
                  'vehicletype': user?['vehicletype'],
                  'phone': user?['phone'],
                });

                print(
                    'Negotiation price sent to Firestore: $_text (index: $index)');

                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawer(
          email: widget.driverEmail,
        ),
        appBar: AppBar(
          backgroundColor: BackgroundColor,
          elevation: 10,
          title: Text("ORDERS"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                ))
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(11),
          child: Column(
            children: [
              Expanded(
                  child: Allordersdetail(
                orderStream: OrderStream,
              ))
            ],
          ),
        ));
  }
}
