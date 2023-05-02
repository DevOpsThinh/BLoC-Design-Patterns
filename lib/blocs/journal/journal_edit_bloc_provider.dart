import 'package:counter_app/blocs/journal/journal_entry_bloc.dart';
import 'package:flutter/material.dart';

///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 30/ 4/ 2023
///------------------------------------------------------------------

/// Class's document:
/// Passing the State between widgets & pages.
/// As the provider for the [JournalEditBloc] class.
class JournalEditBlocProvider extends InheritedWidget {
  final JournalEditBloc journalEditBloc;

  const JournalEditBlocProvider(
      {super.key, required this.journalEditBloc, required super.child});

  static JournalEditBlocProvider? of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<JournalEditBlocProvider>());

  @override
  bool updateShouldNotify(JournalEditBlocProvider oldWidget) => false;
}
