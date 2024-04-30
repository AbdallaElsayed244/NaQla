import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/screens/HomeScreen/home_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final imagePath = "images/delivery-car.png";
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LayoutBuilder(builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final imageWidth = maxWidth * 0.8;
          final imageHeight = imageWidth * (190 / 210);

          return AnimatedSplashScreen(
              backgroundColor: BackgroundColor,
              splashTransition: SplashTransition.slideTransition,
              splashIconSize: 300,
              splash: Container(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  imagePath,
                  width: imageWidth,
                  height: imageHeight,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error); // Simple error icon
                  },
                ),
              ),
              nextScreen: const HomeScreen());
        }));
  }
}
