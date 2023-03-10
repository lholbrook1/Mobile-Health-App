import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/firestore_controller.dart';
import '../model/accelerometer.dart';
import '../model/constant.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.user,
    required this.accelerometer,
    Key? key,
  }) : super(key: key);

  final User user;
  final Accelerometer accelerometer;
  static const routeName = '/settingsScreen';

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsScreen> {
  late _Controller con;
  late String interval;
  late String dataSend;
  late String email;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    email = widget.user.email ?? 'No email';
    interval = widget.accelerometer.collectionInterval ??= '5';
    dataSend = widget.accelerometer.sendInterval ??= '16';
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
                "Set data collection interval",
                style: TextStyle(
                  fontFamily: 'MontserratAlternates',
                  fontSize: 20.0,
                  color: Colors.blueAccent,
                ),
              ),
              DropdownButton(
                items: Constants.collectMenuItems,
                value: widget.accelerometer.collectionInterval,
                onChanged: con.changeCollectionInterval,
                hint: const Text('Timestamps'),
              ),
              const Divider(
                height: 100,
              ),
              const Text(
                "Set data transmission interval",
                style: TextStyle(
                  fontFamily: 'MontserratAlternates',
                  fontSize: 20.0,
                  color: Colors.blueAccent,
                ),
              ),
              DropdownButton(
                items: Constants.sendMenuItems,
                value: widget.accelerometer.sendInterval,
                onChanged: con.changeSendInterval,
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

  void changeCollectionInterval(String? value) {
    if (value != null) {
      state.widget.accelerometer.setCollectionInterval(value);
      state.interval = value;
      state.render(() {});
    }
  }

  void changeSendInterval(String? value) {
    if (value != null) {
      state.widget.accelerometer.setSendInterval(value);
      state.dataSend = value;
      state.render(() {});
    }
  }
}
