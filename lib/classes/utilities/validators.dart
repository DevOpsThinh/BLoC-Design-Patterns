import 'dart:async';

///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 30/ 4/ 2023
///------------------------------------------------------------------

/// Class's document:
/// Handles validating the email & password will be provided by the user.
class Validators {
  final validatePassword =
      StreamTransformer<String, String>.fromHandlers(handleData: (pass, sink) {
    if (pass.length >= 8) {
      sink.add(pass);
    } else if (pass.isEmpty) {
      sink.addError("Password needs to be at least 8 characters!");
    }
  });

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains("@") && email.contains(".")) {
      sink.add(email);
    } else if (email.isEmpty) {
      sink.addError("Enter a valid email!");
    }
  });
}
