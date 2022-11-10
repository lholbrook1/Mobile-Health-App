import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  //static User? user;

  static Future<User?> signIn(
      {required String email, required String password}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> createAccount(
      {required String email, required String password}) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> updateAccount(
      {required String fullname, required String photoUrl}) async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.updateDisplayName(fullname);
    await user?.updatePhotoURL(photoUrl);
  }
}
