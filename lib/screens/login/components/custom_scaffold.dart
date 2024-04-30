import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/screens/HomeScreen/home_screen.dart';
import 'package:Mowasil/screens/login/components/2ndPageregistration1.dart';
import 'package:Mowasil/screens/login/driver_registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child, required body});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: BackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(PageAnimationTransition(
                page: const HomeScreen(),
                pageAnimationType: RightToLeftTransition()));
          },
          icon: Icon(Icons.arrow_back),
          iconSize: 29,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.6,
            decoration: BoxDecoration(
              color: Color(0xff3F6596),
              borderRadius: BorderRadius.circular(70),
            ),
          ),
          SafeArea(child: child!)
        ],
      ),
    );
  }
}
