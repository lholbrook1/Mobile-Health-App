import 'package:flutter/cupertino.dart';
import 'package:mobile_health_app/controller/firestore_controller.dart';

enum DocKeyAccelerometer {
  uid,
  email,
  collectionInterval,
  sendInterval,
  dataPoints,
  magList,
  stepsList,
}

class Accelerometer {
  static const UID = 'uid';
  static const EMAIL = 'email';
  static const DATAPOINTS = 'dataPoints';
  static const INTERVAL = 'collectionInterval';
  static const MAGNILIST = 'magList';
  static const STEPS = 'stepsList';

  String? uid; //firestore auto generated id
  String? docId;
  String? email;
  late List<dynamic> dataPoints;
  String? collectionInterval;
  String? sendInterval;
  late List<dynamic> magList;
  late List<dynamic> stepsList;

  Accelerometer({
    this.uid,
    this.docId,
    this.email = '',
    this.collectionInterval = '60',
    this.sendInterval = '60',
    List<dynamic>? stepsList,
    List<dynamic>? dataPoints,
    List<dynamic>? magList,
  }) {
    this.stepsList = stepsList == null ? [] : [...stepsList];
    this.dataPoints = dataPoints == null ? [] : [...dataPoints];
    this.magList = magList == null ? [] : [...magList];
  }

  Accelerometer.set(this.email) {
    this.uid;
    this.docId;
    this.collectionInterval;
    this.sendInterval;
    stepsList = [];
    dataPoints = [];
    magList = [];
  }

  Accelerometer.clone(Accelerometer p) {
    uid = p.uid;
    docId = p.docId;
    email = p.email;
    collectionInterval = p.collectionInterval;
    sendInterval = p.sendInterval;
    stepsList = p.stepsList == null ? [] : [...stepsList];
    dataPoints = p.dataPoints == null ? [] : [...dataPoints];
    magList = p.magList == null ? [] : [...magList];
  }

  //a.copyFrom(b) ==> a = b
  void copyFrom(Accelerometer p) {
    uid = p.uid;
    docId = p.docId;
    email = p.email;
    collectionInterval = p.collectionInterval;
    sendInterval = p.sendInterval;
    dataPoints.clear();
    dataPoints.addAll(p.dataPoints);
    magList.clear();
    magList.addAll(p.magList);
    stepsList.clear();
    stepsList.addAll(p.stepsList);
  }

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyAccelerometer.email.name: email,
      DocKeyAccelerometer.uid.name: uid,
      DocKeyAccelerometer.collectionInterval.name: collectionInterval,
      DocKeyAccelerometer.sendInterval.name: sendInterval,
      DocKeyAccelerometer.dataPoints.name: dataPoints,
      DocKeyAccelerometer.magList.name: magList,
      DocKeyAccelerometer.stepsList.name: stepsList,
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
          doc[DocKeyAccelerometer.collectionInterval.name.toString()] ??= '60',
      sendInterval: doc[DocKeyAccelerometer.sendInterval.name.toString()] ??=
          '60',
      dataPoints: doc[DocKeyAccelerometer.dataPoints.name] ??= [],
      magList: doc[DocKeyAccelerometer.magList.name] ??= [],
      stepsList: doc[DocKeyAccelerometer.stepsList.name] ??= [],
    );
  }

  void setCollectionInterval(String x) {
    this.collectionInterval = x;
    Map<String, dynamic> info = {
      DocKeyAccelerometer.collectionInterval.name: collectionInterval,
    };
    FirestoreController.updateUser(docId: docId!, updateInfo: info);
  }

  void setSendInterval(String x) {
    this.sendInterval = x;
    Map<String, dynamic> info = {
      DocKeyAccelerometer.sendInterval.name: sendInterval,
    };
    FirestoreController.updateUser(docId: docId!, updateInfo: info);
  }

  void sendToCloud(List<dynamic> x) {
    if (x != []) {
      this.dataPoints.addAll(x);
      Map<String, dynamic> info = {};
      info[Accelerometer.DATAPOINTS] = dataPoints;
      FirestoreController.updateUser(docId: docId!, updateInfo: info);
    }
  }
}
