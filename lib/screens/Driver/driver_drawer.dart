import 'package:Naqla/helper/service/auth_methods.dart';
import 'package:Naqla/screens/HomeScreen/home_screen.dart';
import 'package:Naqla/screens/Driver/order_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DriverDrawer extends StatefulWidget {
  const DriverDrawer({super.key, this.email, this.driverEmail});
  final String? email;
  final String? driverEmail;
  @override
  State<DriverDrawer> createState() => _DriverDrawerState();
}

class _DriverDrawerState extends State<DriverDrawer> {
  Stream<DocumentSnapshot<Map<String, dynamic>>>?
      orderStream; // Stream to hold negotiationPrice data

  @override
  void initState() {
    super.initState();
    orderStream = FirebaseFirestore.instance
        .collection("Users")
        .doc("${widget.email}Driver")
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
                      ? CachedNetworkImage(
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          imageUrl: userData?['profilePhoto'],
                          imageBuilder: (context, imageProvider) =>
                              InstaImageViewer(
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
                              size: 80,
                              color: Color.fromARGB(255, 90, 115, 138)),
                        ),
                ),
                const SizedBox(
                  height: 13,
                ),
                // const ListTile(
                //   dense: false,
                //   style: ListTileStyle.list,
                //   leading: Icon(
                //     Icons.account_circle_outlined,
                //     size: 40,
                //   ),
                //   title: Text(
                //     'Your Profile',
                //     style: TextStyle(fontSize: 20),
                //   ),
                // ),
                const SizedBox(
                  height: 13,
                ),
                ListTile(
                  dense: false,
                  style: ListTileStyle.list,
                  leading: const Icon(
                    Icons.fact_check_outlined,
                    size: 40,
                  ),
                  title: const Text(
                    ' Accepted offers',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.of(context).push(PageAnimationTransition(
                        page: OrderStatus(driverEmail: widget.email),
                        pageAnimationType: RightToLeftTransition()));
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
