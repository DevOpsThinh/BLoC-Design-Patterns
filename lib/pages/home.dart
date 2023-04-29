///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 28/ 4/ 2023
///------------------------------------------------------------------

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/database.dart';
import 'edit_entry.dart';

/// Class's document:
/// The Journal Home Page
class HomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const HomePage({super.key, required this.analytics, required this.observer});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Database _database;
  late String _message;

  @override
  void initState() {
    super.initState();

    _message = "Send Analytics event";
    _database = Database(journals: []);
  }

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<void> _sendAnalyticsEvent() async {
    // Only strings and numbers (longs & doubles for android, ints and doubles for iOS) are supported for GA custom event parameters:
    // https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Classes/FIRAnalytics#+logeventwithname:parameters:
    // https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics#public-void-logevent-string-name,-bundle-params
    await widget.analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        // Only strings and numbers (ints & doubles) are supported for GA custom event parameters:
        // https://developers.google.com/analytics/devguides/collection/analyticsjs/custom-dims-mets#overview
        'bool': true.toString(),
      },
    );

    setMessage('logEvent succeeded');
  }

  Future<List<Journal>> _loadJournals() async {
    await DatabaseFileRoutines().readJournals().then((journalsJson) {
      _database = databaseFromJson(journalsJson);
      _database.journals
          .sort((comp1, comp2) => comp2.date.compareTo(comp1.date));
    });
    return _database.journals;
  }

  void _addOrEditJournal(
      {required bool add, required int index, required Journal journal}) async {
    JournalEdit journalEdit = JournalEdit(action: ' ', journal: journal);
    journalEdit = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditJournalEntry(
                add: add,
                index: index,
                journalEdit: journalEdit,
              ),
          fullscreenDialog: true),
    );

    switch (journalEdit.action) {
      case 'Save':
        if (add) {
          setState(() {
            _database.journals.add(journalEdit.journal);
          });
        } else {
          setState(() {
            _database.journals[index] = journalEdit.journal;
          });
        }
        DatabaseFileRoutines().writeJournals(databaseToJson(_database));
        _sendAnalyticsEvent();
        break;
      case 'Cancel':
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Me & Journal',
            style: TextStyle(color: Colors.lightGreen.shade800)),
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32.0),
          child: Container(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.lightGreen, Colors.lightGreen.shade50],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // TODO: Add logout method
              setMessage("Logged out");
              _sendAnalyticsEvent();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.lightGreen.shade800,
            ),
            tooltip: "Sign Out",
          )
        ],
      ),
      body: FutureBuilder(
        initialData: const [],
        future: _loadJournals(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : _buildListViewSeparated(snapshot);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 3.0,
        child: Container(
          height: 44.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.lightGreen.shade50, Colors.lightGreen],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Journal Entry",
        child: const Icon(Icons.add),
        onPressed: () async {
          _addOrEditJournal(
              add: true,
              index: -1,
              journal: Journal(id: "", date: "", mood: "", note: ""));
          _sendAnalyticsEvent();
        },
      ),
    );
  }

  /// Build the ListView with Separator
  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          String titleDate = DateFormat.yMMMd()
              .format(DateTime.parse(snapshot.data[index].date));
          String subtitle =
              snapshot.data[index].mood + "\n" + snapshot.data[index].note;

          return Dismissible(
            key: Key(snapshot.data[index].id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(right: 16.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: ListTile(
              leading: Column(
                children: <Widget>[
                  Text(
                    DateFormat.d()
                        .format(DateTime.parse(snapshot.data[index].date)),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                        color: Colors.blue),
                  ),
                  Text(DateFormat.E()
                      .format(DateTime.parse(snapshot.data[index].date))),
                ],
              ),
              title: Text(
                titleDate,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(subtitle),
              onTap: () async {
                _addOrEditJournal(
                  add: false,
                  index: index,
                  journal: snapshot.data[index],
                );
              },
            ),
            onDismissed: (direction) {
              setState(() {
                _database.journals.removeAt(index);
              });
              DatabaseFileRoutines().writeJournals(databaseToJson(_database));
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            color: Colors.blueGrey,
          );
        },
        itemCount: snapshot.data.length);
  }
}
