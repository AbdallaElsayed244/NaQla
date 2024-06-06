import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/helper/functions/loading_indicator.dart';
import 'package:Mowasil/helper/service/auth_methods.dart';
import 'package:Mowasil/screens/HomeScreen/home_screen.dart';
import 'package:Mowasil/Driver/order_status.dart';
import 'package:Mowasil/User/frieght/frieght_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:page_animation_transition/animations/left_to_right_transition.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/animations/scale_animation_transition.dart';
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
                      BoxDecoration(color: Color.fromARGB(255, 75, 133, 115)),
                  accountName: Text(userData?['username'] ?? ""),
                  accountEmail: Text(userData?['email'] ?? "not signed in"),
                  arrowColor: Colors.black,
                  currentAccountPicture: userData?['profilePhoto'] != null
                      ? CachedNetworkImage(
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
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
                      : Padding(
                          padding: const EdgeInsets.all(.0),
                          child: Icon(Icons.account_circle_rounded,
                              size: 80,
                              color: Color.fromARGB(255, 90, 115, 138)),
                        ),
                ),
                SizedBox(
                  height: 13,
                ),
                ListTile(
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
                SizedBox(
                  height: 13,
                ),
                ListTile(
                  dense: false,
                  style: ListTileStyle.list,
                  leading: Icon(
                    Icons.fact_check_outlined,
                    size: 40,
                  ),
                  title: Text(
                    ' Accepted offers',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.of(context).push(PageAnimationTransition(
                        page: OrderStatus(driverEmail: widget.email),
                        pageAnimationType: RightToLeftTransition()));
                  },
                ),
                SizedBox(
                  height: 13,
                ),
                ListTile(
                  dense: false,
                  style: ListTileStyle.list,
                  leading: Icon(
                    Icons.logout,
                    size: 40,
                  ),
                  title: Text(
                    'Log Out',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    AuthMethods.instance.logout();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
