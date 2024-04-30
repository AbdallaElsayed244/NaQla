import 'package:Mowasil/helper/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:Mowasil/screens/HomeScreen/components/Brand.dart';
import 'package:animate_gradient/animate_gradient.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class BackGround extends StatelessWidget {
  const BackGround({super.key});

// ignore: non_constant_identifier_names
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWeight = MediaQuery.of(context).size.width;
    return SizedBox(
      width: 1600.h,
      height: screenHeight / 2,
      child: AnimateGradient(
        duration: const Duration(seconds: 10),
        reverse: true,
        primaryColors: [
          BackgroundColor,
          BackgroundColor,
        ],
        secondaryColors: const [Color(0xff5994C0), Color(0xff5994C0)],
        child: Row(
          children: [
            Container(
                decoration: const BoxDecoration(),
                width: screenWeight / 1.01,
                height: screenHeight / .9,
                child: const Brand()),
          ],
        ),
      ),
    );
  }
}
