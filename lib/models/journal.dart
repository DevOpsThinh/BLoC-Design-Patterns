///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 29/ 4/ 2023
///------------------------------------------------------------------

/// Class's document:
/// Tracking individual journal entries & mapping a Cloud Firestore
/// document to a [Journal] entry.
class Journal {
  String documentID;
  String date;
  String mood;
  String note;
  String uid;

  Journal({required this.documentID,
    required this.date,
    required this.mood,
    required this.note,
    required this.uid});

  factory Journal.fromDoc(dynamic doc) =>
      Journal(documentID: doc.documentID,
          date: doc["date"],
          mood: doc["mood"],
          note: doc["note"],
          uid: doc["uid"]);
}
