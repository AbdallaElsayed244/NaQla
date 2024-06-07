import 'package:Naqla/helper/service/auth_methods.dart';
import 'package:Naqla/screens/HomeScreen/home_screen.dart';
import 'package:Naqla/screens/User/OrderStatus/order_timeline.dart';
import 'package:Naqla/screens/User/frieght/frieght_page.dart';
import 'package:Naqla/screens/User/oder_info/orderinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key, this.email, this.driverEmail});
  final String? email;
  final String? driverEmail;
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Stream<DocumentSnapshot<Map<String, dynamic>>>?
      orderStream; // Stream to hold negotiationPrice data

  @override
  void initState() {
    super.initState();
    orderStream = FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.email ?? "${widget.driverEmail}Driver")
        .snapshots();

    print(orderStream);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: Colors.white,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: orderStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final userData = snapshot.data!.data();
            return ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration:
                      const BoxDecoration(color: Color.fromARGB(255, 75, 133, 115)),
                  accountName: Text(userData?['username'] ?? ""),
                  accountEmail: Text(userData?['email'] ?? "not signed in"),
                  arrowColor: Colors.black,
                  currentAccountPicture: userData?['profilePhoto'] != null
                      ? Container(
                          child: InstaImageViewer(
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                userData?['profilePhoto'],
                              ),
                            ),
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(.0),
                          child: Icon(Icons.account_circle_rounded,
                              size: 80, color: Colors.black),
                        ),
                ),
                const SizedBox(
                  height: 13,
                ),
                const ListTile(
                  dense: false,
                  style: ListTileStyle.list,
                  leading: Icon(
                    Icons.account_circle_outlined,
                    size: 40,
                  ),
                  title: Text(
                    'Your Profile',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 13,
                ),
                ListTile(
                  dense: false,
                  style: ListTileStyle.list,
                  leading: const Icon(
                    Icons.trolley,
                    size: 40,
                  ),
                  title: const Text(
                    'Add Order',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Frieght(
                              email: widget.email ?? widget.driverEmail)),
                    );
                  },
                ),
                const SizedBox(
                  height: 13,
                ),
                ListTile(
                  dense: false,
                  style: ListTileStyle.list,
                  leading: const Icon(
                    Icons.moped,
                    size: 40,
                  ),
                  title: const Text(
                    'Order Requests',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Orderinfo(email: widget.email)),
                    );
                  },
                ),
                const SizedBox(
                  height: 13,
                ),
                ListTile(
                  dense: false,
                  style: ListTileStyle.list,
                  leading: const Icon(
                    Icons.timeline_rounded,
                    size: 40,
                  ),
                  title: const Text(
                    'Order TimeLine',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TimelineComponent(
                                email: widget.email,
                                driverEmail: widget.driverEmail,
                              )),
                    );
                  },
                ),
                const SizedBox(
                  height: 13,
                ),
                ListTile(
                  dense: false,
                  style: ListTileStyle.list,
                  leading: const Icon(
                    Icons.logout,
                    size: 40,
                  ),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    AuthMethods.instance.logout();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
