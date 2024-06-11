import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> transferDocument(
  String sourceCollection,
  String? documentId,
  String? documentId2,
  String destinationCollection,
  String statusValue,
) async {
  try {
    // Initialize Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the document from the source collection
    DocumentSnapshot sourceDocSnapshot =
        await firestore.collection(sourceCollection).doc(documentId).get();

    if (sourceDocSnapshot.exists) {
      // Get the document data
      Map<String, dynamic>? data =
          sourceDocSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        // Add the status field to the data
        data['status'] = statusValue;

        // Write the modified document to the destination collection
        await firestore
            .collection(destinationCollection)
            .doc(documentId2)
            .collection("Orders")
            .doc()
            .set(data);

        // Optionally, delete the document from the source collection

        print('Document transferred successfully with status field!');
      } else {
        print('No data found in the document.');
      }
    } else {
      print('Document does not exist in the source collection.');
    }
  } catch (e) {
    print('Error transferring document: $e');
  }
}
