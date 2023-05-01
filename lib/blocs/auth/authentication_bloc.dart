import 'dart:async';
import 'package:counter_app/services/authentication_api.dart';

///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 30/ 4/ 2023
///------------------------------------------------------------------

/// Class's document:
/// Identifying logged-in user credentials & monitoring user authentication login status.
class AuthenticationBloc {
  final AuthenticationApi authenticationApi;

  final StreamController<String> _authController = StreamController<String>();
  final StreamController<bool> _logoutController = StreamController<bool>();

  Sink<String> get addUser => _authController.sink;

  Sink<bool> get logoutUser => _logoutController.sink;

  Stream<String> get user => _authController.stream;

  Stream<bool> get listLogoutUser => _logoutController.stream;

  AuthenticationBloc(this.authenticationApi) {
    onAuthChanged();
  }

  void onAuthChanged() {
    authenticationApi
        .getFirebaseAuth()
        .authStateChanges()
        .listen((user) {
      final String uid = user?.uid;
      addUser.add(uid);
    });
    _logoutController.stream.listen((logout) {
      if (logout == true) {
        _signOut();
      }
    });
  }

  void _signOut() {
    authenticationApi.signOut();
  }

  void dispose() {
    _authController.close();
    _logoutController.close();
  }
}
