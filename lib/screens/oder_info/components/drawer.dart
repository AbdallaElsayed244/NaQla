import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/helper/functions/loading_indicator.dart';
import 'package:Mowasil/helper/service/auth_methods.dart';
import 'package:Mowasil/screens/HomeScreen/home_screen.dart';
import 'package:Mowasil/screens/frieght/frieght_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        .doc(widget.email)
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
                  decoration: BoxDecoration(color: BackgroundColor),
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
                      : Padding(
                          padding: const EdgeInsets.all(.0),
                          child: Icon(Icons.account_circle_rounded,
                              size: 80, color: Colors.black),
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
                    Icons.local_shipping_outlined,
                    size: 40,
                  ),
                  title: Text(
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
