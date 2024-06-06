import 'package:cloud_firestore/cloud_firestore.dart';

class OrderseMethods {
  //creat
  Future addOrderDetails(Map<String, dynamic> OrderInfomap, String? id) async {
    return await FirebaseFirestore.instance
        .collection("orders")
        .doc(id)
        .set(OrderInfomap); // store order details
  }

  Future<Stream<QuerySnapshot>> getOederDetails() async {
    return await FirebaseFirestore.instance
        .collection(
          "orders",
        )
        .snapshots(); // fetching order details
  }

  Future<DocumentReference<Map<String, dynamic>>> getnegotiatedPrice() async {
    return await FirebaseFirestore.instance
        .collection(
          "orders",
        )
        .doc('negotiationPrice'); // store negotiation details
  }
}
