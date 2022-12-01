import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Model/accelerometer.dart';
import 'package:mobile_health_app/Model/datapoinst.dart';
import 'package:mobile_health_app/controller/firestore_controller.dart';
import 'package:mobile_health_app/viewscreen/view_util.dart';
import '../Model/constant.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.user,
    Key? key,
  }) : super(key: key);
  final User user;

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Distance traveled today",
                    style: TextStyle(
                      fontFamily: 'MontserratAlternates',
                      fontSize: 40.0,
                      color: Colors.blueAccent,
                    ),
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
    try {
      await Navigator.pushNamed(
        state.context,
        SettingsScreen.routeName,
        arguments: {
          ARGS.USER: state.widget.user,
        },
      );
      Navigator.of(state.context).pop(); // push in drawer
    } catch (e) {
      if (Constants.devMode)
        print('======== Settings screen navigation error: $e');
      showSnackBar(
        context: state.context,
        seconds: 20,
        message: 'Settings screen navigation error: $e',
      );
    }
  }
}
