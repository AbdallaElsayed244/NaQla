import 'package:cloud_firestore/cloud_firestore.dart';

class OrderData {
  Future addOrder(Map<String, dynamic> OrderInfomap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(id)
        .set(OrderInfomap);
  }
}
