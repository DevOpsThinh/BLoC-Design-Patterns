import 'package:counter_app/blocs/auth/authentication_bloc.dart';
import 'package:flutter/material.dart';

///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 30/ 4/ 2023
///------------------------------------------------------------------

/// Class's document:
/// Passing the State between widgets & pages.
/// As the provider for the [AuthenticationBloc] class to identify
/// logged-in user credentials & monitoring user authentication login status.
class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc authenticationBloc;

  const AuthenticationBlocProvider(
      {super.key, required this.authenticationBloc, required super.child});

  static AuthenticationBlocProvider? of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>());
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider oldWidget) =>
      authenticationBloc != oldWidget.authenticationBloc;
}
