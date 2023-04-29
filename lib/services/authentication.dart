///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 29/ 4/ 2023
///------------------------------------------------------------------

import 'package:counter_app/services/authentication_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Class's document:
/// A concrete authentication service class that implements the [AuthenticationApi] abstract class
class AuthenticationService extends AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  @override
  Future<String> createUserWithEmailAndPassword(
      {String email = "invalid.email@gmail.com",
      String password = "production1ready1app"}) async {
    User user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password)) as User;
    return user.uid;
  }

  @override
  Future<String> currentUserUid() async {
    await null;
    User user = _firebaseAuth.currentUser!;
    return user.uid;
  }

  @override
  Future<bool> isEmailVerified() async {
    await null;
    User user = _firebaseAuth.currentUser!;
    return user.emailVerified;
  }

  @override
  Future<void> sendEmailVerification() async {
    await null;
    User user = _firebaseAuth.currentUser!;
    user.sendEmailVerification();
  }

  @override
  Future<String> signInWithEmailAndPassword(
      {String email = "invalid.email@gmail.com",
      String password = "production1ready1app"}) async {
    User user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)) as User;
    return user.uid;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
