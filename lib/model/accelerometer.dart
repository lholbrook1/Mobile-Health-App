import 'package:flutter/cupertino.dart';
import 'package:mobile_health_app/controller/firestore_controller.dart';

enum DocKeyAccelerometer {
  uid,
  email,
  collectionInterval,
  sendInterval,
  dataPoints,
  distanceRecords,
  totalDayDistance,
  totalDistance,
}

class Accelerometer {
  static const UID = 'uid';
  static const EMAIL = 'email';
  static const DATAPOINTS = 'dataPoints';
  static const INTERVAL = 'collectionInterval';
  static const DISTANCERECS = 'distanceRecords';
  static const DAYDISTANCE = 'totalDayDistance';
  static const TOTALDISTANCE = 'totalDistance';

  String? uid; //firestore auto generated id
  String? docId;
  String? email;
  late List<dynamic> dataPoints;
  String? collectionInterval;
  String? sendInterval;
  late List<double> distanceRecords;
  late double totalDayDistance;
  late double totalDistance;

  Accelerometer({
    this.uid,
    this.docId,
    this.email = '',
    this.collectionInterval = '60',
    this.sendInterval = '60',
    this.totalDayDistance = 0,
    this.totalDistance = 0,
    List<dynamic>? dataPoints,
    List<dynamic>? distanceRecords,
  }) {
    distanceRecords = distanceRecords == null ? [] : [...distanceRecords];
    dataPoints = dataPoints == null ? [] : [...dataPoints];
  }

  Accelerometer.set(this.email) {
    this.uid;
    this.docId;
    this.collectionInterval;
    this.sendInterval;
    this.totalDayDistance;
    this.totalDistance;
    dataPoints = [];
    distanceRecords = [];
  }

  Accelerometer.clone(Accelerometer p) {
    uid = p.uid;
    docId = p.docId;
    email = p.email;
    collectionInterval = p.collectionInterval;
    sendInterval = p.sendInterval;
    distanceRecords = distanceRecords == null ? [] : [...distanceRecords];
    totalDayDistance = p.totalDayDistance;
    totalDistance = p.totalDistance;
    dataPoints = dataPoints == null ? [] : [...dataPoints];
  }

  //a.copyFrom(b) ==> a = b
  void copyFrom(Accelerometer p) {
    uid = p.uid;
    docId = p.docId;
    email = p.email;
    collectionInterval = p.collectionInterval;
    sendInterval = p.sendInterval;
    totalDayDistance = p.totalDayDistance;
    totalDistance = p.totalDistance;
    dataPoints.clear();
    dataPoints.addAll(p.dataPoints);
    distanceRecords.clear();
    distanceRecords.addAll(p.distanceRecords);
  }

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyAccelerometer.email.name: email,
      DocKeyAccelerometer.uid.name: uid,
      DocKeyAccelerometer.collectionInterval.name: collectionInterval,
      DocKeyAccelerometer.sendInterval.name: sendInterval,
      DocKeyAccelerometer.dataPoints.name: dataPoints,
      DocKeyAccelerometer.distanceRecords.name: distanceRecords,
      DocKeyAccelerometer.totalDayDistance.name: totalDayDistance,
      DocKeyAccelerometer.totalDistance.name: totalDistance,
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
      sendInterval: doc[DocKeyAccelerometer.sendInterval.toString()] ??= '60',
      dataPoints: doc[DocKeyAccelerometer.dataPoints.name] ??= [],
      distanceRecords: doc[DocKeyAccelerometer.distanceRecords.name] ??= [],
      totalDayDistance: doc[DocKeyAccelerometer.totalDayDistance.name] ??= 0,
      totalDistance: doc[DocKeyAccelerometer.totalDistance.name] ??= 0,
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
}
