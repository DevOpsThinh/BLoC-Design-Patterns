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
      {required String email, required String password}) async {
    final UserCredential user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password)) ;
    return user.credential.toString();
  }

  @override
  Future<String> currentUserUid() async {
    final User user = _firebaseAuth.currentUser!;
    return user.uid;
  }

  @override
  Future<bool> isEmailVerified() async {
    final User user = _firebaseAuth.currentUser!;
    return user.emailVerified;
  }

  @override
  Future<void> sendEmailVerification() async {
    final User user = _firebaseAuth.currentUser!;
    user.sendEmailVerification();
  }

  @override
  Future<String> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    final UserCredential user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password));
    return user.credential.toString();
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
