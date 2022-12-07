import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_health_app/viewscreen/start_screen.dart';
import 'firebase_options.dart';
import 'model/constant.dart';
import 'viewscreen/home_screen.dart';
import 'viewscreen/settings_screen.dart';
import 'viewscreen/view_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MobileHealthApp());
}

class MobileHealthApp extends StatelessWidget {
  const MobileHealthApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MaterialApp(
      initialRoute: StartScreen.routeName,
      routes: {
        StartScreen.routeName: (context) => const StartScreen(),
        HomeScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            showSnackBar(
                context: context, message: 'args is null for Home Screen');
          }
          var arguments = args as Map;
          var user = arguments[ARGS.USER];
          var accelerometer = arguments[ARGS.ACCELEROMETER];
          var database = arguments[ARGS.DATABASE];
          return HomeScreen(
            user: user,
            accelerometer: accelerometer,
            database: database,
          );
        },
        SettingsScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            showSnackBar(
                context: context, message: 'args is null for Settings Screen');
          }
          var arguments = args as Map;
          var user = arguments[ARGS.USER];
          var accelerometer = arguments[ARGS.ACCELEROMETER];
          return SettingsScreen(
            user: user,
            accelerometer: accelerometer,
          );
        }
      },
    );
  }
}
