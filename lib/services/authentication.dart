import 'package:counter_app/services/authentication_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 29/ 4/ 2023
///------------------------------------------------------------------

/// Class's document:
/// A concrete authentication service class that implements the [AuthenticationApi] abstract class
class AuthenticationService implements AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  @override
  Future<String?> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final User user = (await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password)) as User;
      return user.uid;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return "";
    }
  }

  @override
  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    try {
      final User user = (
          await _firebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password
          )
      ) as User;
      return user.uid;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return "";
    }
  }

  @override
  Future<String?> currentUserUid() async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return "";
    }
  }

  @override
  Future<bool?> isEmailVerified() async {
    return  _firebaseAuth.currentUser?.emailVerified;
  }

  @override
  Future<void> sendEmailVerification() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();
}
