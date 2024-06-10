import 'package:Naqla/helper/app_colors.dart';
import 'package:Naqla/helper/service/orders_methods.dart';
import 'package:Naqla/screens/Driver/driver_drawer.dart';
import 'package:Naqla/screens/Driver/order_status.dart';
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
              padding:
                  const EdgeInsets.only(top: 20), // Added padding at the top
              itemCount: snapshot.data?.docs?.length ?? 0,
              itemBuilder: (context, index) {
                final DocumentSnapshot Orders = snapshot.data.docs[index];
                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(Orders['id'])
                      .get(),
                  builder:
                      (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SizedBox(
                        width: 200.0,
                        height: 100.0,
                        child: Shimmer.fromColors(
                          baseColor: const Color.fromARGB(255, 231, 224, 224),
                          highlightColor:
                              const Color.fromARGB(255, 223, 222, 216),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                )),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ' ${Orders['offer']} EGP',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(214, 10, 48, 1),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _showDialog(context, index, Orders);
                                        },
                                        child: const Text(
                                          "Start",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                            fixedSize: WidgetStateProperty.all(
                                                const Size(80, 50)),
                                            backgroundColor:
                                                WidgetStateColor.resolveWith(
                                                    (states) => ButtonsColor2),
                                            shape: WidgetStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: const BorderSide(
                                                        color: Colors.black,
                                                        width: 1)))),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  buildDetailRow('       ', '             '),
                                  buildDetailRow(
                                      '                   ', '            '),
                                  buildDetailRow('      ', '            '),
                                  buildDetailRow('          ', '           '),
                                  const SizedBox(height: 90),
                                  const Divider(
                                      color: Colors.black,
                                      thickness: 1.0,
                                      height: 5),
                                  const SizedBox(height: 20),
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
                      return const SizedBox();
                    }

                    final userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) => (Orders),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            )),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ' ${Orders['offer']} EGP',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(214, 10, 48, 1),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showDialog(context, index, Orders);
                                    },
                                    child: const Text(
                                      "Start",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                        fixedSize: WidgetStateProperty.all(
                                            const Size(80, 50)),
                                        backgroundColor:
                                            WidgetStateColor.resolveWith(
                                                (states) => ButtonsColor2),
                                        shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: const BorderSide(
                                                    color: Colors.black,
                                                    width: 1)))),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              buildDetailRow("PickUp:", Orders['pickup']),
                              buildDetailRow(
                                  "Location:", Orders['destination']),
                              buildDetailRow("Time:", Orders['date']),
                              buildDetailRow(
                                  "Additional Notes:", Orders['cargo']),
                              const SizedBox(height: 20),
                              const Divider(
                                  color: Colors.black,
                                  thickness: 1.0,
                                  height: 5),
                              const SizedBox(height: 20),
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
            return const Center(
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
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              color: Color.fromARGB(255, 0, 0, 0),
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
                      placeholder: (context, url) => const LoadingIndicator(
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
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(
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
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
        ),
        const SizedBox(width: 15),
        Text(
          userData['username'] ?? 'Unknown',
          style: const TextStyle(
            fontSize: 19,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ],
    );
  }

  void _showDialog(
      BuildContext context, int index, DocumentSnapshot<Object?> Orders) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String _text = '';

        return AlertDialog(
          title: const Text('Negotiate'),
          content: TextFormField(
            onChanged: (value) {
              _text = value;
            },
            decoration:
                const InputDecoration(hintText: 'Enter negotiation price'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
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
                    .doc(Orders['id'])
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
                  'rating': user?['rating'],
                });

                print(
                    'Negotiation price sent to Firestore: $_text (index: $index)');

                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
        title: const Text("ORDERS"),
        centerTitle: true,
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Acceptance")
                .doc(widget.driverEmail)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final bool hasEmailInTimeline = snapshot.data?.exists ?? false;
              return badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.circle,
                    badgeColor: Colors.blue,
                    padding: const EdgeInsets.all(4),
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white, width: 1),
                    borderGradient: const badges.BadgeGradient.linear(colors: [
                      Color.fromARGB(255, 12, 68, 133),
                      Color.fromARGB(255, 136, 38, 38)
                    ]),
                    badgeGradient: const badges.BadgeGradient.linear(
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
                  badgeContent: const Text('1',
                      style: TextStyle(color: Color.fromARGB(255, 15, 15, 15))),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(PageAnimationTransition(
                          page: OrderStatus(driverEmail: widget.driverEmail),
                          pageAnimationType: RightToLeftTransition()));
                    },
                    icon: const Icon(
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
              margin: const EdgeInsets.all(11),
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
