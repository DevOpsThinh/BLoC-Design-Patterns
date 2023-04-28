///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 28/ 4/ 2023
///------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/database.dart';
import 'edit_entry.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Database _database;

  @override
  void initState() {
    super.initState();

    _database = Database(journals: []);
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
        title: const Text('Me & Journal'),
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
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(padding: EdgeInsets.all(24.0)),
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
