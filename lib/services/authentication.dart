import 'package:counter_app/services/authentication_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 29/ 4/ 2023
///------------------------------------------------------------------

/// Class's document:
/// A concrete authentication service class that implements the [AuthenticationApi] abstract class
class AuthenticationService extends AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  @override
  Future<String?> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    final User user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password)) as User;
    notifyListeners();
    return user.uid;
  }

  @override
  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    final User user = (
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password
        )
    ) as User;
    notifyListeners();
    return user.uid;
  }

  @override
  Future<String?> currentUserUid() async {
    return _firebaseAuth.currentUser?.uid;
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
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }
}
