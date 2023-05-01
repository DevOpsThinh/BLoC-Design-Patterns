///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 30/ 4/ 2023
///------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'home_bloc.dart';

/// Class's document:
/// Passing the State between widgets & pages
/// As the provider for the [HomeBloc] class to retrieve the list of journals
/// and delete individual entries.
class HomeBlocProvider extends InheritedWidget {
  final HomeBloc homeBloc;
  final String uid;

  const HomeBlocProvider(
      {super.key, required Widget child,
      required this.homeBloc,
      required this.uid})
      : super(child: child);

  static HomeBlocProvider? of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<HomeBlocProvider>());
  }

  @override
  bool updateShouldNotify(HomeBlocProvider oldWidget) =>
      homeBloc != oldWidget.homeBloc;
}
