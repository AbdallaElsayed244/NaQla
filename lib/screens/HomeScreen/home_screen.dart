import 'package:Mowasil/screens/HomeScreen/components/h_s_background.dart';
import 'package:Mowasil/screens/login/to_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = "HomeScreen";
  @override
  State<HomeScreen> createState() => _AnimatedContainerReplacementState();
}

class _AnimatedContainerReplacementState extends State<HomeScreen> {
  bool _showOriginalContainer = true;

  // ignore: unused_element
  void _toggleContainers() {
    setState(() {
      _showOriginalContainer = !_showOriginalContainer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          SizedBox(
            child: Column(
              children: [
                Stack(
                  children: [BackGround()],
                ),
              ],
            ),
          ),
          ToLogin(),
        ],
      ),
    );
  }
}
