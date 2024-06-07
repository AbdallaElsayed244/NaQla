import 'package:Naqla/helper/app_colors.dart';
import 'package:Naqla/helper/show_message.dart';
import 'package:Naqla/screens/User/OrderStatus/components/timeLine.dart';
import 'package:Naqla/screens/User/oder_info/components/drawer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

TextStyle style = const TextStyle(color: Colors.white);

class TimelineComponent extends StatefulWidget {
  TimelineComponent({Key? key, this.email, this.driverEmail}) : super(key: key);
  final String? email;
  final String? driverEmail;
  @override
  State<TimelineComponent> createState() => _TimelineComponentState();
}

class _TimelineComponentState extends State<TimelineComponent> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDay = DateFormat('EEEE').format(now); // e.g. Monday
    String formattedDate =
        DateFormat('MMMM yyyy').format(now).toUpperCase(); // e.g. FEBRUARY 2015
    String formattedTime = DateFormat('h').format(now); // e.g. 03:45 PM
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/Order-info.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        endDrawerEnableOpenDragGesture: true,
        drawer: CustomDrawer(
          email: widget.email,
          driverEmail: widget.driverEmail,
        ),
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: const Text('Order Timeline'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
              )
            ]),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('TimeLine')
              .doc(widget.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/Order-info2.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                    child: AutoSizeText(
                  'Wait for the driver to confirm',
                  style: TextStyle(fontSize: 22),
                )),
              );
            }

            var data = snapshot.data!.data() as Map<String, dynamic>;
            bool? boolean1 = data['Confirmed'];
            bool? boolean2 = data['Pickup'];
            bool? boolean3 = data['arrived'];
            bool? boolean4 = data['coming'];
            String? driveremail = data['email'];

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.only(
                      top: kToolbarHeight +
                          50), // Add padding equal to the height of the AppBar
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: size.height * 0.28,
                        width: double.infinity,
                        child: Image.asset("images/pickup2.jpg",
                            fit: BoxFit.fitWidth),
                      ),
                      Positioned(
                        top: 60,
                        left: 30,
                        child: Row(children: <Widget>[
                          Text(formattedTime,
                              style: style.copyWith(fontSize: 70.0)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                AutoSizeText(formattedDay,
                                    style: style.copyWith(fontSize: 25.0)),
                                AutoSizeText(formattedDate.toUpperCase(),
                                    style: style.copyWith(fontSize: 12.0)),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.1,
                        isFirst: true,
                        indicatorStyle: IndicatorStyle(
                          width: 20,
                          color: boolean1 == true
                              ? const Color.fromARGB(255, 203, 216, 209)
                              : const Color.fromARGB(255, 31, 95, 63),
                          padding: const EdgeInsets.all(6),
                        ),
                        endChild: RightChild(
                          asset: Image.asset("images/order_placed.png",
                              height: 50),
                          title: 'Order Confirmed',
                          message: 'Your order has been confirmed.',
                          disabled: boolean1 ?? true,
                        ),
                        beforeLineStyle: LineStyle(
                          color: boolean1 == true
                              ? const Color.fromARGB(255, 203, 216, 209)
                              : const Color.fromARGB(255, 31, 95, 63),
                        ),
                      ),
                      TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.1,
                        indicatorStyle: IndicatorStyle(
                          width: 20,
                          color: boolean2 == true
                              ? const Color.fromARGB(255, 203, 216, 209)
                              : const Color.fromARGB(255, 31, 95, 63),
                          padding: const EdgeInsets.all(6),
                        ),
                        endChild: RightChild(
                          asset: Image.asset('images/order_confirmed.png',
                              height: 50),
                          title: 'Pick up',
                          message: 'Your cargo has been picked up.',
                          disabled: boolean2 ?? true,
                        ),
                        beforeLineStyle: LineStyle(
                          color: boolean2 == true
                              ? const Color.fromARGB(255, 203, 216, 209)
                              : const Color.fromARGB(255, 31, 95, 63),
                        ),
                      ),
                      TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.1,
                        indicatorStyle: IndicatorStyle(
                          width: 20,
                          color: boolean3 == true
                              ? const Color.fromARGB(255, 203, 216, 209)
                              : const Color.fromARGB(255, 31, 95, 63),
                          padding: const EdgeInsets.all(6),
                        ),
                        endChild: RightChild(
                          asset: Image.asset('images/output-onlinepngtools.png',
                              height: 65),
                          title: 'Order Coming',
                          message: 'Your order is on the way.',
                          disabled: boolean3 ?? true,
                        ),
                        beforeLineStyle: LineStyle(
                            color: boolean3 == true
                                ? const Color.fromARGB(255, 203, 216, 209)
                                : const Color.fromARGB(255, 31, 95, 63)),
                      ),
                      TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.1,
                        isLast: true,
                        indicatorStyle: IndicatorStyle(
                          width: 20,
                          color: boolean4 == true
                              ? const Color.fromARGB(255, 203, 216, 209)
                              : const Color.fromARGB(255, 31, 95, 63),
                          padding: const EdgeInsets.all(6),
                        ),
                        endChild: RightChild(
                          disabled: boolean4 ?? true,
                          asset: Image.asset('images/ready_to_pickup.png',
                              height: 50),
                          title: 'Order Delivered',
                          message: 'Your order has arrived.',
                        ),
                        beforeLineStyle: LineStyle(
                          color: boolean4 == true
                              ? const Color.fromARGB(255, 203, 216, 209)
                              : const Color.fromARGB(255, 31, 95, 63),
                        ),
                      ),
                    ],
                  ),
                ),
                if (boolean4 == false)
                  Padding(
                    padding: const EdgeInsets.all(19.0),
                    child: ElevatedButton(
                      onPressed: () {
                        showMessage(context, 'Did the order delivered to you?',
                            () async {
                          _showRatingBar(context, driveremail, widget.email);
                        }, () {}, '', "yes", "No", DialogType.noHeader);
                      },
                      child: const Text(
                        "Confirm Delivery",
                        style: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(ButtonsColor2),
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 40)),
                          shape:
                              WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ))),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  void _showRatingBar(
      BuildContext context, String? driveremail, String? userEmail) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const AutoSizeText(
                    'Rate the driver',
                    style: TextStyle(fontSize: 28.0),
                  ),
                  const SizedBox(height: 16.0),
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    maxRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) async {
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc("${driveremail}Driver")
                          .update({
                        'rating': rating.toString(),
                      });

                      print(rating);
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    child: const AutoSizeText(
                      'Submit',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(ButtonsColor2),
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('TimeLine')
                          .doc(userEmail)
                          .delete();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
