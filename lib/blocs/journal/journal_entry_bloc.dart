import 'dart:async';

import 'package:counter_app/models/journal.dart';
import 'package:counter_app/services/db_firestore_api.dart';

///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 30/ 4/ 2023
///------------------------------------------------------------------

/// Class's document:
/// Monitoring the journal edit page to add a new entry or save an existing entry.
class JournalEditBloc {
  final DatabaseApi databaseApi;
  final bool isAdd;
  Journal selectedJournal;

  final StreamController<String> _saveJournalController =
      StreamController<String>.broadcast();
  final StreamController<String> _dateController =
      StreamController<String>.broadcast();
  final StreamController<String> _moodController =
      StreamController<String>.broadcast();
  final StreamController<String> _noteController =
      StreamController<String>.broadcast();

  Sink<String> get saveJournalChanged => _saveJournalController.sink;

  Sink<String> get dateEditChanged => _dateController.sink;

  Sink<String> get moodEditChanged => _dateController.sink;

  Sink<String> get noteEditChanged => _dateController.sink;

  Stream<String> get saveJournal => _saveJournalController.stream;

  Stream<String> get dateEdit => _dateController.stream;

  Stream<String> get moodEdit => _moodController.stream;

  Stream<String> get noteEdit => _noteController.stream;

  JournalEditBloc(this.isAdd, this.selectedJournal, this.databaseApi) {
    _startEditListeners().then((done) => _getJournal(isAdd, selectedJournal));
  }

  void _getJournal(bool isAdd, Journal journal) {
    if (isAdd) {
      selectedJournal = Journal(
          documentID: journal.documentID,
          date: DateTime.now().toString(),
          mood: "Very Satisfied",
          note: "Really ?",
          uid: journal.uid);
    } else {
      selectedJournal.date = journal.date;
      selectedJournal.mood = journal.mood;
      selectedJournal.note = journal.note;
    }

    dateEditChanged.add(selectedJournal.date);
    moodEditChanged.add(selectedJournal.mood);
    noteEditChanged.add(selectedJournal.note);
  }

  void _saveJournal() {
    Journal journal = Journal(
        documentID: selectedJournal.documentID,
        date: DateTime.parse(selectedJournal.date).toIso8601String(),
        mood: selectedJournal.mood,
        note: selectedJournal.note,
        uid: selectedJournal.uid);
    isAdd
        ? databaseApi.addJournal(journal)
        : databaseApi.updateJournal(journal);
  }

  Future<bool> _startEditListeners() async {
    _dateController.stream.listen((d) {
      selectedJournal.date = d;
    });
    _moodController.stream.listen((m) {
      selectedJournal.mood = m;
    });
    _noteController.stream.listen((n) {
      selectedJournal.note = n;
    });

    _saveJournalController.stream.listen((action) {
      if (action == "Save") {
        _saveJournal();
      }
    });
    return true;
  }

  void dispose() {
    _dateController.close();
    _moodController.close();
    _noteController.close();
    _saveJournalController.close();
  }
}
