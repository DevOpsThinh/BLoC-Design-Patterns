///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 30/ 4/ 2023
///------------------------------------------------------------------

import 'package:counter_app/blocs/auth/authentication_bloc.dart';
import 'package:flutter/material.dart';

/// Class's document:
/// Passing the State between widgets & pages.
/// As the provider for the [AuthenticationBloc] class to identify
/// logged-in user credentials & monitoring user authentication login status.
class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc authenticationBloc;

  const AuthenticationBlocProvider(
      {super.key, required Widget child,
      required this.authenticationBloc})
      : super(child: child);

  static AuthenticationBlocProvider? of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>());
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider oldWidget) =>
      authenticationBloc != oldWidget.authenticationBloc;
}
