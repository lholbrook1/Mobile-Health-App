// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB0WmH_CE0Ioc4EnzuwPYIjEy0I0ASIPSk',
    appId: '1:843473749436:web:3dec5f90077836202d97b9',
    messagingSenderId: '843473749436',
    projectId: 'seii-mobile-health-app',
    authDomain: 'seii-mobile-health-app.firebaseapp.com',
    storageBucket: 'seii-mobile-health-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBEqhCB4aDQePECkcdcVWHrd_G0oobIHy4',
    appId: '1:843473749436:android:ef392ba5a5c391b62d97b9',
    messagingSenderId: '843473749436',
    projectId: 'seii-mobile-health-app',
    storageBucket: 'seii-mobile-health-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDEBU1D_DighM2t9oYfP2_nseBmaBcRuyk',
    appId: '1:843473749436:ios:3340d7a2b918bbe22d97b9',
    messagingSenderId: '843473749436',
    projectId: 'seii-mobile-health-app',
    storageBucket: 'seii-mobile-health-app.appspot.com',
    iosClientId: '843473749436-37enrjerr38tu93mnsppa8vr6h6q3caq.apps.googleusercontent.com',
    iosBundleId: 'edu.uco.lholbrook1.se2.mobileHealthApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDEBU1D_DighM2t9oYfP2_nseBmaBcRuyk',
    appId: '1:843473749436:ios:3340d7a2b918bbe22d97b9',
    messagingSenderId: '843473749436',
    projectId: 'seii-mobile-health-app',
    storageBucket: 'seii-mobile-health-app.appspot.com',
    iosClientId: '843473749436-37enrjerr38tu93mnsppa8vr6h6q3caq.apps.googleusercontent.com',
    iosBundleId: 'edu.uco.lholbrook1.se2.mobileHealthApp',
  );
}
