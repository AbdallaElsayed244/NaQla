import 'package:Mowasil/helper/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({
    Key? key,
    required this.startAnimation,
    required this.onPressed,
    required this.driveremail,
  }) : super(key: key);

  final bool startAnimation;
  final List<Function()> onPressed;
  final String? driveremail;

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _animations;

  int _selectedIndex = 0; // Track the selected index

  List<String> texts = [
    "Did You picked up the order?",
    "Are You on the way?",
    "Did You arrive?",
    "Order completed thanks for your service",
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animations = List.generate(texts.length, (index) {
      final start = index * 0.1;
      final end = start + 0.3;
      return Tween<Offset>(
        begin: const Offset(0.0, 1.0), // Start from below
        end: const Offset(0.0, 0.0), // End at the original position
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });

    if (widget.startAnimation) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            elevation: 5,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  AutoSizeText(
                    "Inform the user with your progress",
                    style: TextStyle(fontSize: 20),
                  ),
                  AutoSizeText("press Yes after completing each step"),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _selectedIndex + 1,
            itemBuilder: (context, index) {
              return SlideTransition(
                position: _animations[index],
                child: item(index),
              );
            },
          ),
        ),
        Visibility(
          visible: _selectedIndex == texts.length - 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await FirebaseFirestore.instance
                    .collection('Acceptance')
                    .doc(widget.driveremail)
                    .delete();
              },
              child: const Text(
                "GO Back",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                backgroundColor: MaterialStateProperty.all(ButtonsColor2),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black, width: 1),
                )),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget item(int index) {
    return Card(
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${texts[index]}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (index < texts.length - 1)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = index + 1; // Increment selectedIndex
                  });
                  widget.onPressed[index]();
                },
                child: const Text(
                  "yes",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(80, 50)),
                  backgroundColor: MaterialStateProperty.all(ButtonsColor2),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black, width: 1),
                  )),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
