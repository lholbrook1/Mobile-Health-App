import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/model/accelerometer.dart';

class TimeStampsScreen extends StatefulWidget {
  const TimeStampsScreen({
    required this.user,
    required this.accelerometer,
    Key? key,
  }) : super(key: key);

  final User user;
  final Accelerometer accelerometer;
  static const routeName = '/TimeStampsScreen';

  @override
  State<StatefulWidget> createState() {
    return _TimeStampsState();
  }
}

class _TimeStampsState extends State<TimeStampsScreen> {
  late _Controller con;
  late List<dynamic> userPoints;
  late String email;

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
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$email's Timestamps"),
      ),
      body: userPoints.isEmpty
          ? Text(
              'No Distances collected',
              style: Theme.of(context).textTheme.headline6,
            )
          : ListView.builder(
              itemCount: userPoints.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    elevation: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Data collected at: ${DateTime.parse(userPoints[index]['t'].toDate().toString())}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _Controller {
  _TimeStampsState state;
  _Controller(this.state);
}
