import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/helper/service/orders_methods.dart';
import 'package:Mowasil/Driver/OrdersList/components/driver_drawer.dart';
import 'package:Mowasil/Driver/order_status.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:badges/badges.dart' as badges;

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

  @override
  void initState() {
    super.initState();
    getonload();
  }

  Widget Allordersdetail({required Stream<dynamic>? orderStream}) {
    return RefreshIndicator(
      onRefresh: () async {
        await getonload();
      },
      child: StreamBuilder(
        stream: orderStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.only(top: 20), // Added padding at the top
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
                      return SizedBox(
                        width: 200.0,
                        height: 100.0,
                        child: Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 231, 224, 224),
                          highlightColor: Color.fromARGB(255, 223, 222, 216),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                )),
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ' ${ds['offer']} EGP',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(214, 10, 48, 1),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _showDialog(context, index, ds);
                                        },
                                        child: Text(
                                          "Start",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                    Size(80, 50)),
                                            backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => ButtonsColor2),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: BorderSide(
                                                        color: Colors.black,
                                                        width: 1)))),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  buildDetailRow('       ', '             '),
                                  buildDetailRow(
                                      '                   ', '            '),
                                  buildDetailRow('      ', '            '),
                                  buildDetailRow('          ', '           '),
                                  SizedBox(height: 20),
                                  Divider(
                                      color: Colors.black,
                                      thickness: 1.0,
                                      height: 5),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
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

                    final userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) => (ds),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.black,
                              width: 2,
                            )),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ' ${ds['offer']} EGP',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(214, 10, 48, 1),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showDialog(context, index, ds);
                                    },
                                    child: Text(
                                      "Start",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                            Size(80, 50)),
                                        backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => ButtonsColor2),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color: Colors.black,
                                                    width: 1)))),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              buildDetailRow("PickUp:", ds['pickup']),
                              buildDetailRow("Location:", ds['destination']),
                              buildDetailRow("Time:", ds['date']),
                              buildDetailRow("Additional Notes:", ds['cargo']),
                              SizedBox(height: 20),
                              Divider(
                                  color: Colors.black,
                                  thickness: 1.0,
                                  height: 5),
                              SizedBox(height: 20),
                              buildUserInfo(userData),
                            ],
                          ),
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
                'No Orders Right Now',
                style: TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 145, 136, 136),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label ",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 19,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUserInfo(Map<String, dynamic> userData) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 20, 14, 14),
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: userData['profilePhoto'] != null
              ? ClipOval(
                  child: Container(
                    height: 60,
                    width: 60,
                    child: CachedNetworkImage(
                      placeholder: (context, url) => LoadingIndicator(
                        indicatorType: Indicator.ballPulse,
                        colors: [Color.fromARGB(255, 62, 99, 64)],
                        strokeWidth: 0.6,
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        pathBackgroundColor: Color.fromARGB(255, 255, 255, 255),
                      ),
                      imageUrl: userData['profilePhoto'],
                      imageBuilder: (context, imageProvider) =>
                          InstaImageViewer(
                        child: Image.network(
                          userData['profilePhoto'],
                          scale: 5,
                          fit: BoxFit.contain,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballPulse,
                                  colors: [Color.fromARGB(255, 62, 99, 64)],
                                  strokeWidth: 0.6,
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                  pathBackgroundColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                ),
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
        Text(
          userData['username'] ?? 'Unknown',
          style: TextStyle(
            fontSize: 19,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ],
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
                } else {
                  if (kDebugMode) {
                    print('User data does not exist.');
                  }
                }
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
                  'email': user?['email'],
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
      extendBodyBehindAppBar: true,
      drawer: DriverDrawer(
        email: widget.driverEmail,
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("ORDERS"),
        centerTitle: true,
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Acceptance")
                .doc(widget.driverEmail)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final bool hasEmailInTimeline = snapshot.data?.exists ?? false;
              return badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.circle,
                    badgeColor: Colors.blue,
                    padding: EdgeInsets.all(4),
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white, width: 1),
                    borderGradient: badges.BadgeGradient.linear(colors: [
                      Color.fromARGB(255, 12, 68, 133),
                      const Color.fromARGB(255, 136, 38, 38)
                    ]),
                    badgeGradient: badges.BadgeGradient.linear(
                      colors: [
                        Color.fromARGB(255, 152, 189, 30),
                        Color.fromARGB(255, 69, 150, 110)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  position: badges.BadgePosition.topEnd(top: -4, end: 2),
                  showBadge: hasEmailInTimeline,
                  badgeContent: Text('1',
                      style: TextStyle(color: Color.fromARGB(255, 15, 15, 15))),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(PageAnimationTransition(
                          page: OrderStatus(driverEmail: widget.driverEmail),
                          pageAnimationType: RightToLeftTransition()));
                    },
                    icon: Icon(
                      Icons.fact_check_outlined,
                      size: 30,
                    ),
                  ));
            },
          ),
        ],
      ),
      body: Stack(
        // Use Stack to overlay the image behind the content
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "images/Order-info.jpg", // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Your existing content
          SafeArea(
            child: Container(
              margin: EdgeInsets.all(11),
              child: Column(
                children: [
                  Expanded(
                    child: Allordersdetail(
                      orderStream: OrderStream,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
