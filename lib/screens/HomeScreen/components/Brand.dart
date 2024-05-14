import 'package:flutter/material.dart';

class Brand extends StatelessWidget {
  final String imagePath;
  final double baseFontSize;
  final double scalingFactor;

  const Brand({
    super.key,
    this.imagePath = "images/delivery-car.png",
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

        return Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: maxHeight * 0.06),
              child: Image.asset(
                imagePath,
                width: imageWidth,
                height: imageHeight,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error); // Simple error icon
                },
              ),
            ),
            Text(
              'نَقْلة  NaQla',
              style: TextStyle(
                fontFamily: "organetto-light",
                color: Colors.white,
                fontSize: adaptFontSize(maxWidth),
                height: 2,
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
