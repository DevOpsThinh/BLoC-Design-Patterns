///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 28/ 4/ 2023
///------------------------------------------------------------------

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Class's document:
/// Handles getting the path to the device's local documents directory,
/// saving & reading the database file by using the [File] class.
class DatabaseFileRoutines {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/local_persistence.json');
  }

  Future<String> readJournals() async {
    try {
      final file = await _localFile;

      if (!file.existsSync()) {
        // print("File does not Exist: ${file.absolute}");
        await writeJournals('{"journals": []}');
      }
      // Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // print("error readJournals: $e");
      return "";
    }
  }

  Future<File> writeJournals(String json) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(json);
  }
}

// Local Storage JSON Database file and Journal class

/// To read and parse from JSON data
Database databaseFromJson(String stringToDecode) {
  final dataFromJson = json.decode(stringToDecode);
  return Database.fromJson(dataFromJson);
}
/// To save and parse to JSON data
String databaseToJson(Database data) {
  final dataToJson = data.toJson();
  return json.encode(dataToJson);
}
/// Class's document:
/// Handles decoding & encoding the JSON objects, and converting them to a [List] of [Journal] entries.
class Database {
  List<Journal> journals;

  Database({
    required this.journals,
  });

  factory Database.fromJson(Map<String, dynamic> json) => Database(
        journals: List<Journal>.from(json["journals"].map((d) => Journal.fromJson(d))),
      );

  Map<String, dynamic> toJson() => {
        "journals": List<dynamic>.from(journals.map((e) => e.toJson())),
      };
}
/// Class's document:
/// Handles decoding & encoding the JSON objects for each journal entry.
class Journal {
  String id;
  String date;
  String mood;
  String note;

  Journal({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
  });

  factory Journal.fromJson(Map<String, dynamic> json) => Journal(
        id: json["id"],
        date: json["date"],
        mood: json["mood"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "mood": mood,
        "note": note,
      };
}
/// Class's document:
/// Used for Data Entry to pass between pages
class JournalEdit {
  String action;
  Journal journal;

  JournalEdit({required this.action, required this.journal});
}
