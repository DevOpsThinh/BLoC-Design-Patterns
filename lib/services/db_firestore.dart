import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/journal.dart';
import 'db_firestore_api.dart';

///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 29/ 4/ 2023
///------------------------------------------------------------------

/// Class's document:
/// A concrete firebase firestore database service class that implements the [DatabaseApi] abstract class
class DbFirestoreService implements DatabaseApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionJournals = "journals";

  DbFirestoreService() {
    _firestore.settings;
  }

  @override
  Stream<List<Journal>> getJournalList(String uid) {
    return _firestore
        .collection(_collectionJournals)
        .where("uid", isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Journal> journalDocs =
          snapshot.docs.map((e) => Journal.fromDoc(e)).toList();
      journalDocs.sort((comp1, comp2) => comp2.date.compareTo(comp1.date));

      return journalDocs;
    });
  }

  @override
  Future<bool> addJournal(Journal journal) async {
    DocumentReference docRef =
        await _firestore.collection(_collectionJournals).add({
      "date": journal.date,
      "mood": journal.mood,
      "note": journal.note,
      "uid": journal.uid
    });

    return docRef.id.isNotEmpty;
  }

  @override
  void deleteJournal(Journal journal) async {
    await _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .delete()
        .catchError((onError) => {
              // print("Error updating: $onError")
            });
  }

  @override
  Future<Journal> getJournal(String documentID) {
    return _firestore
        .collection(_collectionJournals)
        .doc(documentID)
        .get()
        .then((documentSnapshot) {
      return Journal.fromDoc(documentSnapshot);
    });
  }

  @override
  void updateJournal(Journal journal) async {
    await _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .update({
      "date": journal.date,
      "mood": journal.mood,
      "note": journal.note,
    }).catchError((onError) => {
              // print("Error updating: $onError")
            });
  }

  @override
  void updateJournalWithTransaction(Journal journal) async {
    DocumentReference docRef =
        _firestore.collection(_collectionJournals).doc(journal.documentID);
    var journalData = {
      "date": journal.date,
      "mood": journal.mood,
      "note": journal.note,
    };

    _firestore.runTransaction((transaction) async {
      transaction.update(docRef, journalData);
    });
  }
}
