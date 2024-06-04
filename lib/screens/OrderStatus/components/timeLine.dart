import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class RightChild extends StatelessWidget {
  const RightChild({
    required this.asset,
    required this.title,
    required this.message,
    this.disabled,
  });

  final Widget? asset;
  final String title;
  final String message;
  final bool? disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(19.0),
      child: Row(
        children: <Widget>[
          Opacity(
            child: asset,
            opacity: disabled! ? 0.5 : 1,
          ),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: GoogleFonts.yantramanav(
                  color: disabled!
                      ? const Color(0xFFBABABA)
                      : const Color(0xFF636564),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                style: GoogleFonts.yantramanav(
                  color: disabled!
                      ? const Color(0xFFD5D5D5)
                      : const Color(0xFF636564),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
