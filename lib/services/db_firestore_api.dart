import '../models/journal.dart';

///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 29/ 4/ 2023
///------------------------------------------------------------------

/// Class's document:
///  Database service abstract class
abstract class DatabaseApi {
  Stream<List<Journal>> getJournalList(String uid);

  Future<Journal> getJournal(String documentID);
  Future<bool> addJournal(Journal journal);
  void updateJournal(Journal journal);
  void updateJournalWithTransaction(Journal journal);
  void deleteJournal(Journal journal);
}