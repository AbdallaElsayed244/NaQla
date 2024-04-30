import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child, required body});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color(0xff3F6596),
        leading: IconButton(
          onPressed: () {},
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