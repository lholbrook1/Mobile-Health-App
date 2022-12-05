import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/controller/firestore_controller.dart';
import '../model/accelerometer.dart';
import '../model/constant.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.user,
    required this.accelerometer,
    Key? key,
  }) : super(key: key);

  final User user;
  final Accelerometer accelerometer;
  static const routeName = '/homeScreen';

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  late _Controller con;
  late String email;
  late Accelerometer myProfile =
      FirestoreController.getUser(email: widget.user.email!) as Accelerometer;
  var formKey = GlobalKey<FormState>();
  //Future<List<DataPoints>> dataCSVDatabase = DataPoints.getDataPointsDatabase();
  //String chosenStamp = '';*/

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    email = widget.user.email ?? 'No email';
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
            title: Text("$email's feed"),
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
                  accountName: const Text('no profile'),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  height: 150.0,
                                  width: 150.0,
                                ),
                                Positioned(
                                  top: 35,
                                  left: 35,
                                  child: const Text(
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
                                  left: 35,
                                  child: Text(
                                    "${widget.accelerometer.totalDayDistance.toString()} km",
                                    style: TextStyle(
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
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  height: 150.0,
                                  width: 150.0,
                                ),
                                Positioned(
                                  top: 35,
                                  left: 35,
                                  child: const Text(
                                    "Total",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 20.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      /*DropdownButton(
                    items: Constants.menuItems,
                    value: chosenStamp,
                    onChanged: con.nothing,
                    hint: const Text('Time Intervals'),
                  )*/
                    ],
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

  /*void populateDataPoints() async {
    if (state.dataCSVDatabase.isEmpty) {
      state.dataCSVDatabase = await DataPoints.getDataPointsDatabase();
    }
  }*/

  /*List<DropdownMenuItem<String>>? getTimestamps() {
    //populateDataPoints();
    var timeStampset = <DropdownMenuItem<String>>[];
    state.dataCSVDatabase.forEach(point) {
      timeStampset.add(DropdownMenuItem(
        value: point.timestamp.toString(),
        child: Text(point.timestamp.toString()),
      ));
    }

    //timeStampset = ({...timeStampset}.toList());
    //timeStampset.sort((b, a) => a.compareTo(b));

    return timeStampset;
  }*/

  /*void nothing(String? value) {
    if (value != null) {
      state.chosenStamp = value;
      state.render(() {});
    }
  }*/

  void settingsPage() async {
    await Navigator.pushNamed(
      state.context,
      SettingsScreen.routeName,
      arguments: {
        ARGS.USER: state.widget.user,
      },
    );
    Navigator.of(state.context).pop(); // push in drawer
  }
}
