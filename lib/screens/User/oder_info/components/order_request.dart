import 'package:Naqla/helper/app_colors.dart';
import 'package:Naqla/helper/show_message.dart';
import 'package:Naqla/screens/User/OrderStatus/order_timeline.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:loading_indicator/loading_indicator.dart';

class OrderRequests extends StatefulWidget {
  const OrderRequests({
    super.key,
    required this.negotiationPriceData,
    this.price,
    this.email,
    this.index,
    this.Driveremail,
  });

  final Map<String, dynamic>? negotiationPriceData;
  final price;
  final String? email;
  final String? index;
  final dynamic Driveremail;

  @override
  _OrderRequestsState createState() => _OrderRequestsState();
}

class _OrderRequestsState extends State<OrderRequests> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('No data available'));
        }

        Map<String, dynamic> userData =
            snapshot.data!.data() as Map<String, dynamic>;

        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 20, 14, 14),
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: widget.negotiationPriceData?['profilephoto'] != null
                        ? ClipOval(
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              height: 60,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      const LoadingIndicator(
                                    indicatorType: Indicator.ballPulse,
                                    colors: [Color.fromARGB(255, 62, 99, 64)],
                                    strokeWidth: 0.6,
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    pathBackgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  imageUrl: widget
                                      .negotiationPriceData?['profilephoto'],
                                  imageBuilder: (context, imageProvider) =>
                                      InstaImageViewer(
                                    child: Image.network(
                                      widget.negotiationPriceData?[
                                          'profilephoto'],
                                      scale: 5,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return const Center(
                                            child: LoadingIndicator(
                                              indicatorType:
                                                  Indicator.ballPulse,
                                              colors: [
                                                Color.fromARGB(255, 62, 99, 64)
                                              ],
                                              strokeWidth: 0.6,
                                              backgroundColor: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              pathBackgroundColor:
                                                  Color.fromARGB(
                                                      255, 255, 255, 255),
                                            ),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Flexible(
                          child: AutoSizeText(
                            'Driver price : ${widget.price} EGP',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 50,
                              ),
                              Row(
                                children: [
                                  AutoSizeText(
                                    '${widget.negotiationPriceData?['username']}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Color.fromARGB(255, 82, 177, 82),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              AutoSizeText(
                                '${widget.negotiationPriceData?['vehicletype']} - ${widget.negotiationPriceData?['vehiclenum']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                          AutoSizeText(
                            '${widget.negotiationPriceData?['phone']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          widget.negotiationPriceData?['rating'] != null
                              ? Row(
                                  children: [
                                    AutoSizeText(
                                      '${widget.negotiationPriceData?['rating']} -',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                    RatingBarIndicator(
                                      direction: Axis.horizontal,
                                      itemSize: 15,
                                      rating: (widget.negotiationPriceData?[
                                                  'rating'] !=
                                              null)
                                          ? double.tryParse(widget
                                                  .negotiationPriceData![
                                                      'rating']
                                                  .toString()) ??
                                              0.0
                                          : 0.0,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    const AutoSizeText(
                                      '0.0 -',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                    RatingBarIndicator(
                                      direction: Axis.horizontal,
                                      itemSize: 15,
                                      rating: (widget.negotiationPriceData?[
                                                  'rating'] !=
                                              null)
                                          ? double.tryParse(widget
                                                  .negotiationPriceData![
                                                      'rating']
                                                  .toString()) ??
                                              0.0
                                          : 0.0,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    showMessage(
                        context, 'Are you sure you want to accept this offer?',
                        () async {
                      await OfferAcceptance(context, userData);
                    }, () {}, 'Accept Offer', "Accept", "cancle",
                        DialogType.noHeader);
                  },
                  child: const AutoSizeText(
                    "Accept",
                    style: TextStyle(fontSize: 19, color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      ButtonsColor2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> OfferAcceptance(
      BuildContext context, Map<String, dynamic> user) async {
    await FirebaseFirestore.instance
        .collection("Acceptance")
        .doc(widget.Driveremail)
        .set({
      'offer': widget.price,
      'profilephoto': user['profilePhoto'] ?? null,
      'username': user['username'],
      'email': user['email'],
      'phone': user['phone'],
    });

    Fluttertoast.showToast(
      msg: "Offer Accepted",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: MessageColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    // Debugging print statement to ensure navigation is being called
    print('Navigating to TimelineComponent');

    // Ensure that the Navigator push is called after all async operations
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TimelineComponent(
              email: widget.email, driverEmail: widget.Driveremail)),
    );
  }
}
