import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/viewscreen/timestamps_screen.dart';
import '../controller/firestore_controller.dart';
import '../model/accelerometer.dart';
import '../model/constant.dart';
import '../model/datapoints.dart';
import 'settings_screen.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import 'start_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.user,
    required this.accelerometer,
    required this.database,
    Key? key,
  }) : super(key: key);

  final User user;
  final Accelerometer accelerometer;
  final List<DataPoints> database;
  static const routeName = '/homeScreen';

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  late _Controller con;
  bool run = false;
  late String email;
  late List<dynamic> userPoints;
  late List<dynamic> collecetedPoints = [];
  late List<dynamic> distRecs;
  double totalDis = 0;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    if (widget.accelerometer.dataPoints.isEmpty) {
      userPoints = [];
    } else {
      userPoints = widget.accelerometer.dataPoints;
      for (int i = 0; i < userPoints.length; i++) {
        if (userPoints[i]['t'] is Timestamp) {
          userPoints[i]['t'] = DateTime.fromMillisecondsSinceEpoch(userPoints[i]['t'].millisecondsSinceEpoch);
        }
      }
      print('======userpoints length: ${userPoints.length}');
      print('======userpoints 1: ${userPoints[0]}');
    }
    
    email = widget.user.email ?? 'No email';
    int randNum = Random().nextInt(6700); //starts at random point of data
    Map<int, Map<String, dynamic>> tempPoints = {};
    print('collect seconds = ');
    print(int.parse(widget.accelerometer.collectionInterval!));
    //timer to collect data points
    Timer collect = Timer.periodic(
        Duration(seconds: int.parse(widget.accelerometer.collectionInterval!)),
        (timer) {
      int index = 0;

      print(widget.database[randNum].xValue);
      print(widget.database[randNum].yValue);
      totalDis = widget.accelerometer.totalDistance;

      tempPoints[index] = {
        'x': widget.database[randNum].xValue,
        'y': widget.database[randNum].yValue,
        "t": DateTime.now()
      };

      collecetedPoints.add(tempPoints[index]);
      randNum++;
      index++;
      render(() {});
    });

    Timer send = Timer.periodic(
        Duration(seconds: int.parse(widget.accelerometer.sendInterval!)),
        (timer) {
      con.distanceCalc();
      if (widget.accelerometer.dataPoints.isNotEmpty) {
        collecetedPoints.removeAt(0);
      }
      widget.accelerometer.sendToCloud(collecetedPoints);
      userPoints.addAll(collecetedPoints);

      //temp object gets last thing in collectedPoints
      //clear collectedPoints
      //add object back in list
      var tempCollectedPoint = collecetedPoints[collecetedPoints.length - 1];
      collecetedPoints.clear();
      collecetedPoints.add(tempCollectedPoint);
      render(() {});
    });
  }

  void render(fn) {
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Your Progress",
              style: TextStyle(
                fontFamily: 'MontserratBlack',
                fontSize: 20.0,
              ),
            ),
          ),
          //        DRAWER      --------------------------------------------------
          drawer: Drawer(
            child: ListView(
              children: [
                //        USER ACCOUNT HEADER      -----------------------------
                UserAccountsDrawerHeader(
                  currentAccountPicture: const Icon(
                    Icons.person,
                    size: 70.0,
                  ),
                  accountName: const Text('User'),
                  accountEmail: Text(email),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: con.settingsPage,
                ),
                ListTile(
                  leading: const Icon(Icons.list_alt_outlined),
                  title: const Text('Timestamps'),
                  onTap: con.timestampsPage,
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Log Out'),
                  onTap: con.logOut,
                ),
              ],
            ),
          ),
          body: Form(
            key: formKey,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Divider(),
                        ),
                        const Text(
                          "Distance Traveled",
                          style: TextStyle(
                            fontFamily: 'MontserratBlack',
                            fontSize: 20.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 25.0,
                                      horizontal: 25.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlue[50],
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.blueGrey
                                                .withOpacity(0.15),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 3)),
                                      ],
                                    ),
                                    height: 150.0,
                                    width: 150.0,
                                  ),
                                  const Positioned(
                                    top: 35,
                                    left: 35,
                                    child: Text(
                                      "Today",
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 20.0,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 85,
                                    left: 40,
                                    child: Text(
                                      "${widget.accelerometer.totalDayDistance.toStringAsFixed(2)} km",
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 30.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 25.0,
                                      horizontal: 25.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlue[50],
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.blueGrey.withOpacity(0.15),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    height: 150.0,
                                    width: 150.0,
                                  ),
                                  const Positioned(
                                    top: 35,
                                    left: 35,
                                    child: Text(
                                      "Total",
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 20.0,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 85,
                                    left: 40,
                                    child: Text(
                                      "${totalDis.toStringAsFixed(2)} km",
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 30.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "Activity Review (Day/Week/Month)",
                          style: TextStyle(
                            fontFamily: 'MontserratBlack',
                            fontSize: 20.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 25.0,
                            horizontal: 25.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.lightBlue[50],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.withOpacity(0.15),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          height: 100.0,
                          width: 350.0,
                        ),
                        const Text(
                          "Steps",
                          style: TextStyle(
                            fontFamily: 'MontserratBlack',
                            fontSize: 20.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                        //Listview builder for entries from datapoints
                        ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount:
                                widget.accelerometer.distanceRecords.length,
                            itemBuilder: (BuildContext context, int index) {
                              return 
                              (index + 1 <= widget.accelerometer.distanceRecords.length) ?
                              Card(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.run_circle_outlined,
                                    color: Colors.blueAccent,
                                    size: 50,
                                  ),
                                  title: Text(
                                    'From ${DateFormat.yMd().add_jms().format(userPoints[index]['t'])} to ${DateFormat.yMd().add_jms().format(userPoints[index +1]['t'])}',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 10.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'You walked ${widget.accelerometer.distanceRecords[index].toStringAsFixed(2)} km!',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ) : Text("");
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class _Controller {
  _HomeState state;
  _Controller(this.state);
  DataPoints newPoint = DataPoints();

  late List<DataPoints> pointsList;
  List<dynamic> distancesList = [];
  int randNum = Random().nextInt(6700); //starts at random point of data
  List<dynamic> userPoints = [];
  Map<int, Map<String, dynamic>> tempPoints = {};

  void settingsPage() async {
    await Navigator.pushNamed(
      state.context,
      SettingsScreen.routeName,
      arguments: {
        ARGS.USER: state.widget.user,
        ARGS.ACCELEROMETER: state.widget.accelerometer,
      },
    );
    Navigator.of(state.context).pop(); // push in drawer
  }

  void timestampsPage() async {
    await Navigator.pushNamed(
      state.context,
      TimeStampsScreen.routeName,
      arguments: {
        ARGS.USER: state.widget.user,
        ARGS.ACCELEROMETER: state.widget.accelerometer,
      },
    );
    Navigator.of(state.context).pop(); // push in drawer
  }

  void logOut() async {
    Navigator.of(state.context).pop();
    await Navigator.pushNamed(
      state.context,
      StartScreen.routeName,
    );
    Navigator.of(state.context).pop(); // push in drawer
  }

  void distanceCalc() async {
    //1.0 degrees = 111km
    //0.1 degree = 11.1km
    //http://wiki.gis.com/wiki/index.php/Decimal_degrees

    distancesList.clear();
    for (int i = 0; i < state.collecetedPoints.length - 1; i++) {
      var x = double.parse(state.collecetedPoints[i]['x']) -
          double.parse(state.collecetedPoints[i + 1]['x']);
      var y = double.parse(state.collecetedPoints[i]['y']) -
          double.parse(state.collecetedPoints[i + 1]['y']);

      var c2 = pow(x, 2) * pow(y, 2);
      var c = sqrt(c2);

      var cKm = 111 * c;
      distancesList.add(cKm);
    }
    state.widget.accelerometer.distanceRecords.addAll(distancesList);
    Map<String, dynamic> updateInfo = {};
    updateInfo[Accelerometer.DISTANCERECS] =
        state.widget.accelerometer.distanceRecords;
    await FirestoreController.updateUser(
        docId: state.widget.accelerometer.docId!, updateInfo: updateInfo);
  }
}
