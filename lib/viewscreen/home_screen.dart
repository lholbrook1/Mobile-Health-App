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

import 'package:sensors/sensors.dart';

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
  StreamSubscription? accel;
  AccelerometerEvent? event;

  late _Controller con;
  bool run = false;
  late String email;
  late List<dynamic> userPoints;
  late List<dynamic> collecetedPoints = [];
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
          userPoints[i]['t'] = DateTime.fromMillisecondsSinceEpoch(
              userPoints[i]['t'].millisecondsSinceEpoch);
        }
      }
      print('======userpoints length: ${userPoints.length}');
      print('======userpoints 1: ${userPoints[0]}');
    }
    email = widget.user.email ?? 'No email';
  }

  void render(fn) {
    setState(fn);
  }

  @override
  void dispose() {
    accel?.cancel();
    super.dispose();
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
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: ElevatedButton(
                                child: Text("Start"),
                                onPressed: () {
                                  con.startTimer();
                                },
                              ),
                            ),
                            ElevatedButton(
                              child: Text("End"),
                              onPressed: () {
                                con.collect.cancel();
                                con.send.cancel();
                              },
                            ),
                          ],
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
                                      "STEPS",
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
                            itemCount: widget.accelerometer.magList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return (index + 1 <=
                                      widget.accelerometer.magList.length)
                                  ? Card(
                                      child: ListTile(
                                        isThreeLine: true,
                                        leading: Icon(
                                          Icons.run_circle_outlined,
                                          color: Colors.blueAccent,
                                          size: 50,
                                        ),
                                        title: Text(
                                          'From ${DateFormat.yMd().add_jms().format(userPoints[index]['t'])} to ${DateFormat.yMd().add_jms().format(userPoints[index + 1]['t'])}',
                                          style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 10.0,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        subtitle: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Text(
                                                'You took ?? steps!',
                                                style: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '[x: ${widget.accelerometer.dataPoints[index]['x'].substring(0, 3)} y: ${widget.accelerometer.dataPoints[index]['y'].substring(0, 3)} z: ${widget.accelerometer.dataPoints[index]['z'].substring(0, 3)}] to [x: ${widget.accelerometer.dataPoints[index + 1]['x'].substring(0, 3)} y: ${widget.accelerometer.dataPoints[index + 1]['y'].substring(0, 3)} z: ${widget.accelerometer.dataPoints[index + 1]['z'].substring(0, 3)}]',
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 10.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Text("");
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

  List<dynamic> stepsList = [];
  List<dynamic> magnitudeList = [];
  Map<int, Map<String, dynamic>> tempPoints = {};
  late Timer collect;
  int steps = 0;
  late Timer send;

  void testButton() {
    print("tf");
  }

  void startTimer() async {
    //accelerometer stuff
    if (state.accel == null) {
      state.accel = accelerometerEvents.listen((AccelerometerEvent e) {
        state.event = e;
      });
    } else {
      state.accel!.resume();
    }

    // int randNum = Random().nextInt(6700); //starts at random point of data
    int randNum = 0;
    Map<int, Map<String, dynamic>> tempPoints = {};
    print('collect seconds = ');
    print(int.parse(state.widget.accelerometer.collectionInterval!));
    //timer to collect data points
    collect = Timer.periodic(
        Duration(
            seconds: int.parse(state.widget.accelerometer.collectionInterval!)),
        (timer) {
      int index = 0;
      Map<String, dynamic> tempPoint = {
        'x': state.event!.x.toStringAsFixed(3),
        'y': state.event!.y.toStringAsFixed(3),
        'z': state.event!.z.toStringAsFixed(3),
        "t": DateTime.now()
      };

      print(" || x: " +
          tempPoint['x'] +
          " || y: " +
          tempPoint['y'] +
          " || z: " +
          tempPoint['z']);

      print('x: ${state.widget.database[randNum].xValue}');
      print('y: ${state.widget.database[randNum].yValue}');
      print('z: ${state.widget.database[randNum].zValue}');

      if (tempPoint.isEmpty) {
        tempPoints[index] = {
          'x': state.widget.database[randNum].xValue,
          'y': state.widget.database[randNum].yValue,
          'z': state.widget.database[randNum].zValue,
          "t": DateTime.now()
        };
      } else {
        tempPoints[index] = tempPoint;
      }

      state.collecetedPoints.add(tempPoints[index]);
      randNum++;
      index++;
      state.render(() {});
    });

    send = Timer.periodic(
        Duration(seconds: int.parse(state.widget.accelerometer.sendInterval!)),
        (timer) {
      magCount();
      stepCount();
      if (state.widget.accelerometer.dataPoints.isNotEmpty) {
        state.collecetedPoints.removeAt(0);
      }
      state.widget.accelerometer.sendToCloud(state.collecetedPoints);
      state.userPoints.addAll(state.collecetedPoints);

      //temp object gets last thing in collectedPoints
      //clear collectedPoints
      //add object back in list
      var tempCollectedPoint =
          state.collecetedPoints[state.collecetedPoints.length - 1];
      state.collecetedPoints.clear();
      state.collecetedPoints.add(tempCollectedPoint);
      state.render(() {
        state.userPoints = state.widget.accelerometer.dataPoints;
        state.con.stepsList = state.widget.accelerometer.stepsList;
      });
    });
  }

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

  void magCount() async {
    magnitudeList.clear();
    for (int i = 0; i < state.collecetedPoints.length - 1; i++) {
      var x = double.parse(state.collecetedPoints[i]['x']) -
          double.parse(state.collecetedPoints[i + 1]['x']);
      var y = double.parse(state.collecetedPoints[i]['y']) -
          double.parse(state.collecetedPoints[i + 1]['y']);
      var z = double.parse(state.collecetedPoints[i]['z']) -
          double.parse(state.collecetedPoints[i + 1]['z']);

      var c2 = pow(x, 2) + pow(y, 2) + pow(z, 2);
      var c = sqrt(c2);

      magnitudeList.add(c);
    }
    state.widget.accelerometer.magList.addAll(magnitudeList);
    Map<String, dynamic> updateInfo = {};
    updateInfo[Accelerometer.MAGNILIST] = state.widget.accelerometer.magList;
    await FirestoreController.updateUser(
        docId: state.widget.accelerometer.docId!, updateInfo: updateInfo);
  }

  void stepCount() async {
    stepsList.clear();
    for (int i = 0; i < state.widget.accelerometer.magList.length; i++) {
      print('====MAGNITUDE: ${state.widget.accelerometer.magList[i]}');
      steps = 0;
      if (state.widget.accelerometer.magList[i] > 3) {
        steps++;
      }
      stepsList.add(steps);
    }
    //testing stuff
    Map<String, dynamic> updateInfo = {};
    updateInfo[Accelerometer.STEPS] = stepsList;
    await FirestoreController.updateUser(
        docId: state.widget.accelerometer.docId!, updateInfo: updateInfo);
  }
}
