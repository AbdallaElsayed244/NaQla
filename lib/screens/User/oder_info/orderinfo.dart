import 'package:Naqla/screens/User/OrderStatus/order_timeline.dart';
import 'package:Naqla/screens/User/drawer.dart';
import 'package:Naqla/screens/User/oder_info/components/order_details.dart';
import 'package:Naqla/screens/User/oder_info/components/order_request.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class Orderinfo extends StatefulWidget {
  final String? email;
  const Orderinfo({Key? key, this.email}) : super(key: key);
  static String id = "Orderinfo";

  @override
  State<Orderinfo> createState() => _OrderinfoState();
}

class _OrderinfoState extends State<Orderinfo> {
  Stream<QuerySnapshot>? orderStream;

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  Future<void> _initializeStream() async {
    setState(() {
      orderStream = FirebaseFirestore.instance
          .collection("orders")
          .doc(widget.email)
          .collection('negotiationPrice')
          .snapshots();
    });
  }

  Future<void> _refreshOrders() async {
    await _initializeStream();
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
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/Order-info.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        drawer: CustomDrawer(email: widget.email),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("TimeLine")
                  .doc(widget.email)
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TimelineComponent(email: widget.email),
                        ),
                      );
                    },
                    icon: const Icon(Icons.timeline_rounded, size: 30),
                  ),
                );
              },
            ),
          ],
          elevation: 0,
          title: const AutoSizeText(
            "Your Order Requests",
            style: TextStyle(
              fontSize: 24,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/Order-info.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: RefreshIndicator(
            onRefresh: _refreshOrders,
            child: StreamBuilder<bool>(
              stream: checkOrdersExistence(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData && snapshot.data!) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: orderStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return _buildOtherWidget();
                      }

                      final negotiationPrices = snapshot.data!.docs;

                      return _buildOrderList(negotiationPrices);
                    },
                  );
                } else {
                  return FutureBuilder<Widget>(
                    future: navigateBasedOnOrder(context, widget.email),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      return snapshot.data ?? _buildOtherWidget();
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<Widget> navigateBasedOnOrder(
      BuildContext context, String? email) async {
    final orderCollection = FirebaseFirestore.instance.collection('orders');
    final querySnapshot =
        await orderCollection.where('id', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      return _buildNoDriversYet();
    } else {
      return _buildOtherWidget();
    }
  }

  Widget _buildOtherWidget() {
    return const Center(
      child: Text(
        'No Orders Found add order Now',
        style: TextStyle(
          fontSize: 24,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  Widget _buildNoDriversYet() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
        borderRadius: BorderRadius.circular(50),
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          OrderDetails(widget: widget),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            width: 250,
            child: const Divider(
              color: Colors.black,
              thickness: 1.0,
              height: 5,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'No Drivers Yet',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(255, 145, 136, 136),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  width: 250,
                  child: const Divider(
                    color: Colors.black,
                    thickness: 1.0,
                    height: 5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<DocumentSnapshot> negotiationPrices) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
        borderRadius: BorderRadius.circular(50),
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          OrderDetails(widget: widget),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            width: 250,
            child: const Divider(
              color: Colors.black,
              thickness: 1.0,
              height: 5,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: negotiationPrices.length,
              itemBuilder: (context, index) {
                final doc = negotiationPrices[index];
                final negotiationPriceData =
                    doc.data() as Map<String, dynamic>?;
                final price = negotiationPriceData?['negotiationPrice'];
                final Driveremail = negotiationPriceData?['email'];

                return Dismissible(
                  key: Key(doc.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    FirebaseFirestore.instance
                        .collection("orders")
                        .doc(widget.email)
                        .collection('negotiationPrice')
                        .doc(doc.id)
                        .delete();
                  },
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              OrderRequests(
                                negotiationPriceData: negotiationPriceData,
                                price: price,
                                index: doc.id,
                                email: widget.email,
                                Driveremail: Driveremail,
                              ),
                              const SizedBox(height: 20),
                              Container(
                                alignment: Alignment.center,
                                width: 250,
                                child: const Divider(
                                  color: Colors.black,
                                  thickness: 1.0,
                                  height: 5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
