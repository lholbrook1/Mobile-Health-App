import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controller/firestore_controller.dart';
import '../model/accelerometer.dart';
import '../model/constant.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.user,
    Key? key,
  }) : super(key: key);

  final User user;
  static const routeName = '/settingsScreen';

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsScreen> {
  late _Controller con;
  String interval = "60";
  late String email;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    email = widget.user.email ?? 'No email';
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$email's settings"),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Set collection interval",
                style: TextStyle(
                  fontFamily: 'MontserratAlternates',
                  fontSize: 20.0,
                  color: Colors.blueAccent,
                ),
              ),
              DropdownButton(
                items: Constants.menuItems,
                value: interval,
                onChanged: con.changeInterval,
                hint: const Text('Timestamps'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SettingsState state;
  _Controller(this.state);

  void changeInterval(String? value) {
    Accelerometer myProfile =
        FirestoreController.getUser(email: state.widget.user.email!)
            as Accelerometer;
    if (value != null) {
      myProfile.setCollectionInterval(value);
      state.interval = value;
      state.render(() {});
    }
  }
}
