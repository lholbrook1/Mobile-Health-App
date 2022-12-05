import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/constant.dart';
import '../model/accelerometer.dart';

class FirestoreController {
  static addUser({
    required Accelerometer userProf,
  }) async {
    try {
      DocumentReference ref = await FirebaseFirestore.instance
          .collection(Constants.accelerometerCollection)
          .add(userProf.toFirestoreDoc());
      return ref.id; // doc id auto-generated.
    } catch (e) {
      rethrow;
    }
  }

    static Future<void> updateUser(
      {required String docId, required Map<String, dynamic> updateInfo}) async {
    await FirebaseFirestore.instance
        .collection(Constants.accelerometerCollection)
        .doc(docId)
        .update(updateInfo);
  }

  static Future<Accelerometer> getUser({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constants.accelerometerCollection)
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
