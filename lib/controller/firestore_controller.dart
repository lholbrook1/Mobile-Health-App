import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/constant.dart';
import '../Model/accelerometer.dart';

class FirestoreController {
  static addUser({
    required Accelerometer userProf,
  }) async {
    try {
      DocumentReference ref = await FirebaseFirestore.instance
          .collection(Constants.Accelerometer)
          .add(userProf.toFirestoreDoc());
      return ref.id; // doc id auto-generated.
    } catch (e) {
      rethrow;
    }
  }

  static Future<Accelerometer> getUser({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constants.Accelerometer)
        .where(DocKeyAccelerometer.email.name, isEqualTo: email)
        .get();

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var u = Accelerometer.fromFirestoreDoc(doc: document, docId: doc.id);
        if (u != null) return u;
      }
    }
    return Accelerometer();
  }
}
