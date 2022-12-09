import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../controller/firestore_controller.dart';
import '../model/accelerometer.dart';
import '../model/constant.dart';
import '../model/datapoints.dart';
import 'home_screen.dart';
import 'view_util.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  static const routeName = '/startScreen';

  @override
  State<StatefulWidget> createState() {
    return _StartState();
  }
}

class _StartState extends State<StartScreen> {
  late _Controller con;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    con.getDataTest();
    print(con.pointsList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Container(
            height: 475,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.lightBlue,
                  Colors.blueAccent,
                ],
              ),
            ),
          ),
          const Positioned.fill(
            bottom: 150,
            child: Icon(
              Icons.rocket_launch_rounded,
              size: 70,
              color: Colors.white,
            ),
          ),
          const Positioned.fill(
            bottom: 20,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'accellant',
                style: TextStyle(
                  fontFamily: 'MontserratAlternates',
                  fontSize: 40.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Positioned.fill(
            top: 70,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'be the best you',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 400.0,
            child: Align(
              alignment: Alignment.center,
              child: OutlinedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Sign Up'),
                    content: Stack(
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.email),
                                  hintText: 'Enter email',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                validator: con.validateEmail,
                                onSaved: con.saveEmail,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.lock),
                                  hintText: 'Enter password',
                                ),
                                obscureText: true,
                                autocorrect: false,
                                validator: con.validatePassword,
                                onSaved: con.savePassword,
                              ),
                              ElevatedButton(
                                onPressed: con.signUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                ),
                                child: const Text(
                                  'Sign in',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 70,
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 17.0,
                  ),
                ),
                child: const Text('SIGN UP'),
              ),
            ),
          ),
          Positioned(
            top: 563.0,
            left: 147.0,
            child: TextButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Login'),
                  content: Stack(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                icon: Icon(Icons.email),
                                hintText: 'Enter email',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              validator: con.validateEmail,
                              onSaved: con.saveEmail,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                icon: Icon(Icons.lock),
                                hintText: 'Enter password',
                              ),
                              obscureText: true,
                              autocorrect: false,
                              validator: con.validatePassword,
                              onSaved: con.savePassword,
                            ),
                            ElevatedButton(
                              onPressed: con.signIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: const Text(
                                'Sign in',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blueAccent,
                textStyle: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12.0,
                ),
              ),
              child: const Text('Have an account?'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Controller {
  late _StartState state;
  _Controller(this.state);
  String? email;
  String? password;
  List<DataPoints> pointsList = [];

  Accelerometer newAccel = Accelerometer();

  Future<void> signIn() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    if (!currentState.validate()) return;
    currentState.save();
    User? user;
    try {
      user = await AuthController.signIn(
        email: email!,
        password: password!,
      );

      Accelerometer accel = await FirestoreController.getUser(email: email!);
      getDataTest();

      await Navigator.pushNamed(
        state.context,
        HomeScreen.routeName,
        arguments: {
          ARGS.USER: user,
          ARGS.ACCELEROMETER: accel,
          ARGS.DATABASE: pointsList,
        },
      );
    } catch (e) {
      print('$e');
      showSnackBar(context: state.context, message: 'Login not successful: $e');
    }
  }

  void signUp() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    if (!currentState.validate()) return;
    currentState.save();

    try {
      await AuthController.createAccount(
        email: email!,
        password: password!,
      );

      //Accelerometer userprof = Accelerometer.set(email!.trim());
      newAccel.email = email!.trim(); //keeps track of distance traveled for day
      newAccel.dataPoints = [];
      newAccel.uid = FirebaseAuth.instance.currentUser?.uid;
      FirestoreController.addUser(userProf: newAccel);
      showSnackBar(
        context: state.context,
        message: 'Account created!',
        seconds: 10,
      );
    } catch (e) {
      showSnackBar(
        context: state.context,
        message: 'Cannot create account: $e',
        seconds: 10,
      );
    }
  }

  void saveEmail(String? value) {
    email = value;
  }

  void savePassword(String? value) {
    password = value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'No email provided';
    } else if (!(value.contains('@') && value.contains('.'))) {
      return 'Not valid email address';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'No password provided';
    } else if (value.length < 6) {
      return 'Password too short';
    } else {
      return null;
    }
  }

  void getDataTest() async {
    try {
      Future<List<DataPoints>> getPointsList =
          DataPoints.getDataPointsDatabase();
      pointsList = await getPointsList;
    } catch (e) {
      if (Constants.devMode) print('===== failed to getdata: $e');
    }
  }
}
