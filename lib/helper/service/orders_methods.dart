import 'package:cloud_firestore/cloud_firestore.dart';

class OrderseMethods {
  //creat
  Future addOrderDetails(Map<String, dynamic> OrderInfomap, String? id) async {
    return await FirebaseFirestore.instance
        .collection("orders")
        .doc(id)
        .set(OrderInfomap);
  }

//read
  Future<Stream<QuerySnapshot>> getOederDetails() async {
     
    return await FirebaseFirestore.instance.collection("orders",).snapshots();
  }
  Future<DocumentReference<Map<String, dynamic>>> getnegotiatedPrice() async {
     
    return await FirebaseFirestore.instance.collection("orders",).doc('negotiationPrice');
  }

  //update
  Future updateUsersDetail(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .update(updateInfo);
  }

  //delete
  Future deleteUsersDetail(String id) async {
    return await FirebaseFirestore.instance.collection("Users").doc(id);
  }
}
