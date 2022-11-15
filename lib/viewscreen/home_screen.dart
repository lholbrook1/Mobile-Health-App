import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Model/user.dart';
import 'package:mobile_health_app/controller/firestore_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.user,
    Key? key,
  }) : super(key: key);

  static const routeName = '/homeScreen';
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  late _Controller con;
  late UserProfile myProfile =
      FirestoreController.getUser(email: widget.user.email!) as UserProfile;
  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) {
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              "Distance traveled today",
              style: TextStyle(
                fontFamily: 'MontserratAlternates',
                fontSize: 40.0,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _HomeState state;
  _Controller(this.state);
}
