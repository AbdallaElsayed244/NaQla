import 'package:Naqla/helper/app_colors.dart';
import 'package:Naqla/screens/User/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OrdersHistory extends StatefulWidget {
  final String? email;

  OrdersHistory({Key? key, this.email}) : super(key: key);

  @override
  State<OrdersHistory> createState() => _OrdersHistoryState();
}

class _OrdersHistoryState extends State<OrdersHistory> {
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
          .doc(widget.email)
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
                    .doc(widget.email)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ShimmerCard();
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
      drawer: CustomDrawer(email: widget.email),
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
                  Expanded(
                    child: buildOrdersList(orderStream: orderStream),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: const Color.fromARGB(255, 231, 224, 224),
        highlightColor: const Color.fromARGB(255, 223, 222, 216),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' EGP',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(214, 10, 48, 1),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        "Start",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(80, 50)),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => ButtonsColor2),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side:
                                const BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                buildDetailRow('       ', '             '),
                buildDetailRow('                   ', '            '),
                buildDetailRow('      ', '            '),
                buildDetailRow('          ', '           '),
                const SizedBox(height: 90),
                const Divider(color: Colors.black, thickness: 1.0, height: 5),
                const SizedBox(height: 20),
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
                      child: order != null &&
                              order['status'] != null &&
                              order['status'].toLowerCase() == 'completed'
                          ? Text(
                              '✅Completed  ',
                              style: const TextStyle(
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
                            ))
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
            ],
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

  void _showDialog(BuildContext context) {
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
                // Add negotiation logic here
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
