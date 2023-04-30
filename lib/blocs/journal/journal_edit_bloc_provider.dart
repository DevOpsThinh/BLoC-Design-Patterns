///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 30/ 4/ 2023
///------------------------------------------------------------------

import 'package:counter_app/blocs/journal/journal_entry_bloc.dart';
import 'package:flutter/material.dart';

/// Class's document:
/// Passing the State between widgets & pages.
/// As the provider for the [JournalEditBloc] class.
class JournalEditBlocProvider extends InheritedWidget {
  final JournalEditBloc journalEditBloc;

  const JournalEditBlocProvider(
      {required Key key, required Widget child, required this.journalEditBloc})
      : super(key: key, child: child);

  static JournalEditBlocProvider of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType(
          aspect: JournalEditBlocProvider) as JournalEditBlocProvider);

  @override
  bool updateShouldNotify(JournalEditBlocProvider oldWidget) => false;
}
