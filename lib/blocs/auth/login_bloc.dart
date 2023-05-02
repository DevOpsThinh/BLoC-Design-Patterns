import 'dart:async';

import 'package:counter_app/classes/utilities/validators.dart';
import 'package:counter_app/services/authentication_api.dart';

///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 30/ 4/ 2023
///------------------------------------------------------------------

/// Class's document:
/// Calling the Firebase Authentication service to log in or create a new user.
class LoginBloc with Validators {
  final AuthenticationApi authenticationApi;
  String _email = "ahu@gmail.com";
  String _password = "12345678";
  bool _isValidEmail = true;
  bool _isValidPassword = true;

  final StreamController<String> _loginOrCreateController =
      StreamController<String>();
  final StreamController<String> _loginOrCreateButtonController =
      StreamController<String>();
  final StreamController<bool> _enableLoginCreateButtonController =
      StreamController<bool>.broadcast();
  final StreamController<String> _emailController =
      StreamController<String>.broadcast();
  final StreamController<String> _passwordController =
      StreamController<String>.broadcast();

  Sink<String> get loginOrCreateChanged => _loginOrCreateController.sink;

  Sink<String> get loginOrCreateButtonChanged =>
      _loginOrCreateButtonController.sink;

  Sink<bool> get enableLoginCreateButtonChanged =>
      _enableLoginCreateButtonController.sink;

  Sink<String> get emailChanged => _emailController.sink;

  Sink<String> get passwordChanged => _passwordController.sink;

  Stream<String> get loginOrCreate => _loginOrCreateController.stream;

  Stream<String> get loginOrCreateButton =>
      _loginOrCreateButtonController.stream;

  Stream<bool> get enableLoginCreateButton =>
      _enableLoginCreateButtonController.stream;

  Stream<String> get email => _emailController.stream.transform(validateEmail);

  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  LoginBloc(this.authenticationApi) {
    _startListenersIfEmailPasswordAreValid();
  }

  Future<String> _logIn() async {
    String result = "";

    if (_isValidEmail && _isValidPassword) {
      await authenticationApi
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        result = "Success";
      }).catchError((e) {
        result = e;
      });
      return result;
    } else {
      return "Email & Password are not valid!";
    }
  }

  Future<String> _createAccount() async {
    String result = "";

    if (_isValidEmail && _isValidPassword) {
      await authenticationApi
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        result = "New user: $user";
        authenticationApi
            .signInWithEmailAndPassword(email: _email, password: _password)
            .then((user) {})
            .catchError((e) async {
          result = e + "! ";
        });
      }).catchError((e) async {
        result += e;
      });
      return result;
    } else {
      return "Error creating user!";
    }
  }

  void _updateEnableLoginCreateButtonStream() {
    if (_isValidEmail == true && _isValidPassword == true) {
      enableLoginCreateButtonChanged.add(true);
    } else {
      enableLoginCreateButtonChanged.add(false);
    }
  }

  void _startListenersIfEmailPasswordAreValid() {
    email.listen((e) {
      _email = e;
      _isValidEmail = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _email = "";
      _isValidEmail = false;
      _updateEnableLoginCreateButtonStream();
    });

    password.listen((pass) {
      _password = pass;
      _isValidPassword = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _password = "";
      _isValidPassword = false;
      _updateEnableLoginCreateButtonStream();
    });

    loginOrCreate.listen((action) {
      action == "Login" ? _logIn() : _createAccount();
    });
  }

  void dispose() {
    _loginOrCreateController.close();
    _loginOrCreateButtonController.close();
    _enableLoginCreateButtonController.close();
    _emailController.close();
    _passwordController.close();
  }
}
