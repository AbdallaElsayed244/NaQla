// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, prefer_const_literals_to_create_immutables, unused_local_variable, deprecated_member_use, unused_import, avoid_web_libraries_in_flutter, unnecessary_import, use_super_parameters, must_be_immutable

import 'package:Mowasil/helper/app_colors.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Orderinfo extends StatelessWidget {
  const Orderinfo({Key? key}) : super(key: key);
  static String id = "Orderinfo";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: Myproject(),
    );
  }
}

class Myproject extends StatelessWidget {
  const Myproject({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor,
        elevation: 10,
        title: Text("Your Orders"),
        centerTitle: true,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu, size: 33)),
      ),
      body: Column(
        children: [
          SizedBox(height: kDefaultFontSize / 2),
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
