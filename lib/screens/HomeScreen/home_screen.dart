import 'package:Mowasil/screens/login/to_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.baseFontSize = 25.0,
    this.scalingFactor = 0.03,
  });
  static String id = "HomeScreen";

  final double baseFontSize;
  final double scalingFactor;

  @override
  State<HomeScreen> createState() => _AnimatedContainerReplacementState();
}

class _AnimatedContainerReplacementState extends State<HomeScreen> {
  bool _showOriginalContainer = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Preload the image after dependencies have been established
    precacheImage(AssetImage('images/Truck.jpg'), context);
  }

  void _toggleContainers() {
    setState(() {
      _showOriginalContainer = !_showOriginalContainer;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              fit: BoxFit.cover,
              'images/Truck.jpg',
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, top: screenHeight / 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Best Solution',
                    style: TextStyle(
                      fontFamily: "organetto-light",
                      color: Colors.white,
                      fontSize: screenWidth / 11,
                      height: 2,
                    ),
                  ),
                  Text(
                    'To Deliver',
                    style: TextStyle(
                      fontFamily: "organetto-light",
                      color: Colors.white,
                      fontSize: screenWidth / 11,
                      height: 2,
                    ),
                  ),
                  Text(
                    'Your Cargo',
                    style: TextStyle(
                      fontFamily: "organetto-light",
                      color: Colors.white,
                      fontSize: screenWidth / 11,
                      height: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ToLogin(),
        ],
      ),
    );
  }
}
