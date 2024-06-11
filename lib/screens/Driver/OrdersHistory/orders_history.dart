import 'package:Naqla/helper/app_colors.dart';
import 'package:Naqla/screens/Driver/driver_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shimmer/shimmer.dart';

class OrdersHistory2 extends StatefulWidget {
  final String? driveremail;

  OrdersHistory2({
    Key? key,
    this.driveremail,
  }) : super(key: key);

  @override
  State<OrdersHistory2> createState() => _OrdersHistory2State();
}

class _OrdersHistory2State extends State<OrdersHistory2> {
  Stream<QuerySnapshot>? orderStream;

  @override
  void initState() {
    super.initState();
    getOnLoad();
  }

  getOnLoad() {
    setState(() {
      orderStream = FirebaseFirestore.instance
          .collection("orders_History")
          .doc(widget.driveremail)
          .collection("Orders")
          .snapshots();
    });
  }

  Widget buildOrdersList({required Stream<QuerySnapshot>? orderStream}) {
    return RefreshIndicator(
      onRefresh: () async {
        getOnLoad();
      },
      child: StreamBuilder<QuerySnapshot>(
        stream: orderStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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

          return ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final order = snapshot.data!.docs[index];
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(order['id'])
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (userSnapshot.hasError) {
                    return Center(child: Text('Error: ${userSnapshot.error}'));
                  }
                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return const SizedBox();
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  return OrderCard(order: order, userData: userData);
                },
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: DriverDrawer(email: widget.driveremail),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Orders History"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "images/Order-info.jpg",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.all(11),
              child: Column(
                children: [
                  Expanded(child: buildOrdersList(orderStream: orderStream)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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

class OrderCard extends StatelessWidget {
  final DocumentSnapshot order;
  final Map<String, dynamic> userData;

  OrderCard({required this.order, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        // Implement dismissal logic if necessary
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black, width: 2),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' ${order['offer']} EGP',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(214, 10, 48, 1),
                      ),
                    ),
                    Flexible(
                      child: order['status'] != null &&
                              order['status'].toLowerCase() == 'completed'
                          ? const Text(
                              '✅Completed  ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(211, 96, 190, 9),
                              ),
                            )
                          : Text(
                              '❌${order['status']} ', // Display status or 'Unknown' if status is null
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(212, 163, 3, 3),
                              ),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                buildDetailRow("PickUp:", order['pickup']),
                buildDetailRow("Location:", order['destination']),
                buildDetailRow("Time:", order['date']),
                buildDetailRow("Additional Notes:", order['cargo']),
                const SizedBox(height: 20),
                const Divider(color: Colors.black, thickness: 1.0, height: 5),
                const SizedBox(height: 20),
                buildUserInfo(userData),
              ],
            ),
          ),
        ),
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
}
