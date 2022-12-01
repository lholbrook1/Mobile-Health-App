enum DocKeyAccelerometer {
  uid,
  email,
  collectionInterval,
  dataPoints,
}

class Accelerometer {
  String? uid; //firestore auto generated id
  String? docId;
  String? email;
  late List<dynamic> dataPoints;
  String? collectionInterval;

  Accelerometer({
    this.uid,
    this.docId,
    this.email = '',
    this.collectionInterval = '60',
    List<dynamic>? dataPoints,
  }) {
    dataPoints = dataPoints == null ? [] : [...dataPoints];
  }

  Accelerometer.set(this.email) {
    this.uid;
    this.docId;
    this.collectionInterval;
    dataPoints = [];
  }

  Accelerometer.clone(Accelerometer p) {
    uid = p.uid;
    docId = p.docId;
    email = p.email;
    collectionInterval = p.collectionInterval;
    dataPoints = dataPoints == null ? [] : [...dataPoints];
  }

  //a.copyFrom(b) ==> a = b
  void copyFrom(Accelerometer p) {
    uid = p.uid;
    docId = p.docId;
    email = p.email;
    collectionInterval = p.collectionInterval;
    dataPoints.clear();
    dataPoints.addAll(p.dataPoints);
  }

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyAccelerometer.email.name: email,
      DocKeyAccelerometer.uid.name: uid,
      DocKeyAccelerometer.collectionInterval.name: collectionInterval,
      DocKeyAccelerometer.dataPoints.name: dataPoints,
    };
  }

  //deserialization
  static Accelerometer? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    return Accelerometer(
      uid: docId,
      docId: docId,
      email: doc[DocKeyAccelerometer.email.name] ??= 'N/A',
      collectionInterval:
          doc[DocKeyAccelerometer.collectionInterval.toString()] ??= '60',
      dataPoints: doc[DocKeyAccelerometer.dataPoints.name] ??= [],
    );
  }

  void setCollectionInterval(String x) {
    this.collectionInterval = x;
  }
}
