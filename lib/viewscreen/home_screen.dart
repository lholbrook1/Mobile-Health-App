import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/firestore_controller.dart';
import '../model/accelerometer.dart';
import '../model/constant.dart';
import '../model/datapoints.dart';
import 'settings_screen.dart';
import 'dart:math';

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
  late String email;
  late List<dynamic> userPoints;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    if (widget.accelerometer.dataPoints.isEmpty) {
      userPoints = [];
    } else {
      userPoints = widget.accelerometer.dataPoints;
    }
    email = widget.user.email ?? 'No email';
    int randNum = Random().nextInt(6700); //starts at random point of data
    List<dynamic> collecetedPoints = [];
    Map<int, Map<String, dynamic>> tempPoints = {};
    print('collect seconds = ');
    print(int.parse(widget.accelerometer.collectionInterval!));
    //timer to collect data points
    Timer collect = Timer.periodic(
        Duration(seconds: int.parse(widget.accelerometer.collectionInterval!)),
        (timer) {
      int index = 1;
      //after 5 seconds

      print(widget.database[randNum].xValue);
      print(widget.database[randNum].yValue);

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
      widget.accelerometer.sendToCloud(collecetedPoints);
      collecetedPoints.clear();
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
                          child:
                              Divider(), /*ElevatedButton(
                            onPressed: () {
                              con.getDataTest();
                              con._startTimer();
                            },
                            child: const Text("Start Run"),
                          ),*/
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
                                          color:
                                              Colors.blueGrey.withOpacity(0.15),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: Offset(0,
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
                                      "${widget.accelerometer.totalDayDistance.toString()} km",
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
                                      "${widget.accelerometer.totalDistance.toString()} km",
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
                            itemCount:
                                3, //not sure how many datapoints we're getting per user
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.run_circle_outlined,
                                    color: Colors.blueAccent,
                                    size: 50,
                                  ),
                                  title: Text(
                                    'From (time) to (time)',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 10.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'You walked (km) km!',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
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

  late Timer _timer;
  late List<DataPoints> pointsList;
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
}
