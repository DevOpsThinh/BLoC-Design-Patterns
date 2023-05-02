import 'dart:async';
import 'package:counter_app/models/journal.dart';
import 'package:counter_app/services/authentication_api.dart';
import 'package:counter_app/services/db_firestore_api.dart';

///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 30/ 4/ 2023
///------------------------------------------------------------------

/// Class's document:
/// Retrieving the list of journals and delete individual entries.
class HomeBloc {
  final DatabaseApi databaseApi;
  final AuthenticationApi authenticationApi;

  final StreamController<List<Journal>> _journalsController =
      StreamController<List<Journal>>.broadcast();
  final StreamController<Journal> _deleteJournalController =
      StreamController<Journal>.broadcast();

  Sink<Journal> get deleteJournal => _deleteJournalController.sink;

  Sink<List<Journal>> get _addListJournal => _journalsController.sink;

  Stream<List<Journal>> get listJournal => _journalsController.stream;

  HomeBloc(this.databaseApi, this.authenticationApi) {
    _startListeners();
  }

  void _startListeners() {
    // Retrieve Firebase Firestore Journal Records as List<Journal> not DocumentSnapshot
    authenticationApi.getFirebaseAuth().currentUser.then((user) {
      databaseApi.getJournalList(user.uid).listen((journalDocs) {
        _addListJournal.add(journalDocs);
      });

      _deleteJournalController.stream.listen((j) {
        databaseApi.deleteJournal(j);
      });
    });
  }

  void dispose() {
    _journalsController.close();
    _deleteJournalController.close();
  }
}
