import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/constant.dart';
import '../Model/user.dart';

class FirestoreController {
  static addUser({
    required UserProfile userProf,
  }) async {
    try {
      DocumentReference ref = await FirebaseFirestore.instance
          .collection(Constants.USERPROFILE_COLLECTION)
          .add(userProf.toFirestoreDoc());
      return ref.id; // doc id auto-generated.
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserProfile> getUser({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constants.USERPROFILE_COLLECTION)
        .where(DocKeyUserprof.email.name, isEqualTo: email)
        .get();

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var u = UserProfile.fromFirestoreDoc(doc: document, docId: doc.id);
        if (u != null) return u;
      }
    }
    return UserProfile();
  }
}
