import 'package:Mowasil/screens/login/to_login.dart';
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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showOriginalContainer = true;
  bool _isImageLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preloadImage();
  }

  Future<void> _preloadImage() async {
    await precacheImage(const AssetImage('images/Truck.jpg'), context);
    setState(() {
      _isImageLoaded = true;
    });
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
            child: _isImageLoaded
                ? Image.asset(
                    'images/Truck.jpg',
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Colors.black, // A solid color placeholder
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
          const ToLogin(),
        ],
      ),
    );
  }
}
