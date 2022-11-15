enum DocKeyUserprof {
  uid,
  email,
}

class UserProfile {
  String? uid; //firestore auto generated id
  String? docId;
  late String email;

  UserProfile({
    this.uid,
    this.docId,
    this.email = '',
  });

  UserProfile.set(this.email) {
    this.uid;
    this.docId;
  }

  UserProfile.clone(UserProfile p) {
    uid = p.uid;
    docId = p.docId;
    email = p.email;
  }

  //a.copyFrom(b) ==> a = b
  void copyFrom(UserProfile p) {
    uid = p.uid;
    docId = p.docId;
    email = p.email;
  }

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyUserprof.email.name: email,
      DocKeyUserprof.uid.name: uid,
    };
  }

  //deserialization
  static UserProfile? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    return UserProfile(
      uid: docId,
      docId: docId,
      email: doc[DocKeyUserprof.email.name] ??= 'N/A',
    );
  }
}
