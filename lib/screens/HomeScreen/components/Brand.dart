import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class Brand extends StatelessWidget {
  final String imagePath;
  final double baseFontSize;
  final double scalingFactor;

  const Brand({
    super.key,
    this.imagePath = "images/Truck.jpg",
    this.baseFontSize = 25.0,
    this.scalingFactor = 0.03,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final maxWidth = constraints.maxWidth;
        final imageWidth = maxWidth * 0.6;
        final imageHeight = imageWidth * (190 / 210);

        return Stack(
          children: [
            Expanded(
              child: Image.asset(
                imagePath,
                width: maxWidth + 100,
                height: maxHeight,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error); // Simple error icon
                },
              ),
            ),
            Positioned(
              bottom: maxWidth / 1.7,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Best Solution',
                        style: TextStyle(
                          fontFamily: "organetto-light",
                          color: Colors.white,
                          fontSize: adaptFontSize(maxWidth),
                          height: 2,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'To Deliver',
                          style: TextStyle(
                            fontFamily: "organetto-light",
                            color: Colors.white,
                            fontSize: adaptFontSize(maxWidth),
                            height: 2,
                          ),
                        ),
                      ),
                      Text(
                        'Your Cargo',
                        style: TextStyle(
                          fontFamily: "organetto-light",
                          color: Colors.white,
                          fontSize: adaptFontSize(maxWidth),
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  double adaptFontSize(double maxWidth) {
    return baseFontSize + (maxWidth * scalingFactor);
  }
}
