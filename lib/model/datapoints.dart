import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

enum DocKeyData {
  xvalue,
  yvalue,
  zvalue,
  timestamp,
}

class DataPoints {
  String? docID;
  String? xValue;
  String? yValue;
  String? zValue;
  DateTime? timestamp;

  DataPoints({
    this.docID,
    this.xValue,
    this.yValue,
    this.zValue,
    this.timestamp,
  });

  static const X_VALUE = 'x-value';
  static const Y_VALUE = 'y-value';
  static const Z_VALUE = 'z-value';
  static const TIMESTAMP = 'timestamp';

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      X_VALUE: xValue,
      Y_VALUE: yValue,
      Z_VALUE: zValue,
      TIMESTAMP: timestamp,
    };
  }

  //deserialization
  static DataPoints fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    return DataPoints(
        docID: docId,
        xValue: doc[X_VALUE],
        yValue: doc[Y_VALUE],
        zValue: doc[Z_VALUE],
        timestamp: doc[TIMESTAMP]);
  }

  static Future<List<DataPoints>> getDataPointsDatabase() async {
    var pointsList = <DataPoints>[];
    final rawData =
        // ignore: unnecessary_string_escapes
        await rootBundle.loadString("lib/model/datapoints.csv");
    List<List<dynamic>> _rawList = const CsvToListConverter().convert(rawData);
    for (var rowInfo in _rawList) {
      var oneDataPoint = DataPoints(
        xValue: rowInfo[0].toString(),
        yValue: rowInfo[1].toString(),
        zValue: rowInfo[2].toString(),
        timestamp: DateTime.fromMillisecondsSinceEpoch(rowInfo[3].toInt()),
      );
      //print(oneDataPoint.timestamp);
      pointsList.add(oneDataPoint);
    }
    return pointsList;
  }
}
