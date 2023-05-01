///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 28/ 4/ 2023
///------------------------------------------------------------------

import 'package:counter_app/blocs/auth/authentication_bloc.dart';
import 'package:counter_app/blocs/auth/authentication_bloc_provider.dart';
import 'package:counter_app/blocs/home/home_bloc.dart';
import 'package:counter_app/blocs/home/home_bloc_provider.dart';
import 'package:counter_app/blocs/journal/journal_edit_bloc_provider.dart';
import 'package:counter_app/blocs/journal/journal_entry_bloc.dart';
import 'package:counter_app/classes/utilities/FormatDates.dart';
import 'package:counter_app/classes/utilities/mood_icons.dart';
import 'package:counter_app/models/journal.dart';
import 'package:counter_app/services/db_firestore.dart';
import 'package:flutter/material.dart';
import 'edit_entry.dart';

/// Class's document:
/// The Journal Home Page
class HomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late AuthenticationBloc _authBloc;
  late HomeBloc _homeBloc;
  late String _uid;

  final MoodIcons _moodIcons = const MoodIcons(
      title: "Very Satisfied",
      color: Colors.amber,
      rotation: 0.4,
      icon: Icons.sentiment_very_satisfied);
  final FormatDates _formatDates = FormatDates();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _authBloc = AuthenticationBlocProvider.of(context).authenticationBloc;
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
    _uid = HomeBlocProvider.of(context).uid;
  }

  /// Add or Edit Journal Entry and call the Show Entry Dialog
  void _addOrEditJournal({required bool add, required Journal journal}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext builder) => JournalEditBlocProvider(
                journalEditBloc:
                    JournalEditBloc(add, journal, DbFirestoreService()),
                child: const EditJournalEntry(),
              ),
          fullscreenDialog: true),
    );
  }

  Future<bool> _confirmDeleteJournal() async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Delete Journal"),
              content: const Text("Are your sure you would like to Delete?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.lightGreen, elevation: 0.0),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.red, elevation: 3),
                  child: const Text('DELETE'),
                ),
              ]);
        });
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
              _authBloc.logoutUser.add(true);
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.lightGreen.shade800,
            ),
            tooltip: "Sign Out",
          )
        ],
      ),
      body: StreamBuilder(
        stream: _homeBloc.listJournal,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return _buildListViewSeparated(snapshot);
          } else {
            return const Center(child: Text("Add Journals"));
          }
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
              journal: Journal(
                  uid: _uid, documentID: '', date: '', mood: _moodIcons.title, note: ''));
        },
      ),
    );
  }

  /// Build the ListView with Separator
  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return ListView.separated(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          String titleDate = _formatDates
              .dateFormatShortMonthDayYear(snapshot.data[index].date);
          String subtitle =
              snapshot.data[index].mood + "\n" + snapshot.data[index].note;

          return Dismissible(
              key: Key(snapshot.data[index].documentID),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16.0),
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
                      _formatDates
                          .dateFormatDayNumber(snapshot.data[index].date),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32.0,
                          color: Colors.lightGreen),
                    ),
                    Text(_formatDates
                        .dateFormatShortDayName(snapshot.data[index].date)),
                  ],
                ),
                trailing: Transform(
                  transform: Matrix4.identity()
                    ..rotateZ(
                        _moodIcons.getMoodRotation(snapshot.data[index].mood)),
                  alignment: Alignment.center,
                  child: Icon(
                    _moodIcons.getMoodIcon(snapshot.data[index].mood),
                    color: _moodIcons.getMoodColor(snapshot.data[index].mood),
                    size: 42.0,
                  ),
                ),
                title: Text(
                  titleDate,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(subtitle),
                onTap: () {
                  _addOrEditJournal(
                    add: false,
                    journal: Journal(
                        documentID: snapshot.data[index].documentID,
                        date: snapshot.data[index].date,
                        mood: snapshot.data[index].mood,
                        note: snapshot.data[index].note,
                        uid: snapshot.data[index].uid),
                  );
                },
              ),
              confirmDismiss: (direction) async {
                bool isDelete = await _confirmDeleteJournal();
                if (isDelete) {
                  _homeBloc.deleteJournal.add(snapshot.data[index]);
                }
                return isDelete;
              });
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            color: Colors.blueGrey,
          );
        },
    );
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

// void _addOrEditJournal(
//     {required bool add, required int index, required Journal journal}) async {
//   JournalEdit journalEdit = JournalEdit(action: ' ', journal: journal);
//   journalEdit = await Navigator.push(
//     context,
//     MaterialPageRoute(
//         builder: (context) => EditJournalEntry(
//               add: add,
//               index: index,
//               journalEdit: journalEdit,
//             ),
//         fullscreenDialog: true),
//   );
//
//   switch (journalEdit.action) {
//     case 'Save':
//       if (add) {
//         setState(() {
//           _database.journals.add(journalEdit.journal);
//         });
//       } else {
//         setState(() {
//           _database.journals[index] = journalEdit.journal;
//         });
//       }
//       DatabaseFileRoutines().writeJournals(databaseToJson(_database));
//       _sendAnalyticsEvent();
//       break;
//     case 'Cancel':
//       break;
//     default:
//       break;
//   }
// }
}
