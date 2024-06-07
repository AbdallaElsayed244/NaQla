import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/helper/show_message.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:loading_indicator/loading_indicator.dart';

class OrderConfirmation extends StatelessWidget {
  OrderConfirmation({
    super.key,
    required this.Acceptance,
    this.price,
    this.onPressed,
    required this.driveremail,
  });

  final Map<String, dynamic>? Acceptance;
  final String? price;
  final void Function()? onPressed;
  final String? driveremail;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 20, 14, 14),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Acceptance?['profilephoto'] != null
                    ? ClipOval(
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          height: screenHeight * 0.08,
                          width: screenWidth * 0.17,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => const LoadingIndicator(
                                indicatorType: Indicator.ballPulse,
                                colors: [Color.fromARGB(255, 62, 99, 64)],
                                strokeWidth: 0.6,
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                pathBackgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                              ),
                              imageUrl: Acceptance?['profilephoto'],
                              imageBuilder: (context, imageProvider) =>
                                  InstaImageViewer(
                                child: Image.network(
                                  Acceptance?['profilephoto'],
                                  scale: 5,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Acceptance?['username']} accepted your offer for: ${price} EGP',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${Acceptance?['username']}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 82, 177, 82),
                      ),
                    ),
                    Text(
                      '${Acceptance?['phone']}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    showMessage(
                        context, 'Are you sure you want to delete this offer?',
                        () async {
                      await FirebaseFirestore.instance
                          .collection('Acceptance')
                          .doc(driveremail)
                          .delete();
                    }, () {}, "", "Yes", "cancle", DialogType.error);
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(fontSize: 19, color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 70, 64, 57),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5), // Add spacing between buttons if needed
              Expanded(
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: const Text(
                    "Proceed",
                    style: TextStyle(fontSize: 19, color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      ButtonsColor2,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
