///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 28/ 4/ 2023
///------------------------------------------------------------------

import 'package:counter_app/blocs/journal/journal_edit_bloc_provider.dart';
import 'package:counter_app/blocs/journal/journal_entry_bloc.dart';
import 'package:counter_app/classes/utilities/FormatDates.dart';
import 'package:counter_app/classes/utilities/mood_icons.dart';

import 'package:flutter/material.dart';

/// Class's document:
/// The Journal Entry Page
class EditJournalEntry extends StatefulWidget {
  const EditJournalEntry({super.key});

  @override
  EditJournalEntryState createState() => EditJournalEntryState();
}

class EditJournalEntryState extends State<EditJournalEntry> {
  late JournalEditBloc _journalEditBloc;
  late FormatDates _formatDates;
  late MoodIcons _moodIcons;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();

    _formatDates = FormatDates();
    _moodIcons = const MoodIcons(
        title: "Very Satisfied",
        color: Colors.amber,
        rotation: 0.4,
        icon: Icons.sentiment_very_satisfied);
    _noteController = TextEditingController();
    _noteController.text = "";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _journalEditBloc = JournalEditBlocProvider.of(context).journalEditBloc;
  }

  // Date Picker
  Future<String> _selectDate(String selectedDate) async {
    DateTime initialDate = DateTime.parse(selectedDate);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      selectedDate = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedDate.hour,
              pickedDate.minute,
              pickedDate.second,
              pickedDate.millisecond,
              pickedDate.microsecond)
          .toString();
    }
    return selectedDate;
  }

  void _addOrUpdateJournal() {
    _journalEditBloc.saveJournalChanged.add("Save");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Entry",
            style: TextStyle(color: Colors.lightGreen.shade800)),
        automaticallyImplyLeading: false,
        elevation: 3.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                stream: _journalEditBloc.dateEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return TextButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      String pickerDate = await _selectDate(snapshot.data);
                      _journalEditBloc.dateEditChanged.add(pickerDate);
                    },
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0.0),
                        foregroundColor: Colors.black,
                        elevation: 3,
                        backgroundColor: Colors.lightGreen.shade100),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.calendar_today,
                            size: 22.0, color: Colors.black54),
                        const SizedBox(width: 16.0),
                        Text(
                          _formatDates
                              .dateFormatShortMonthDayYear(snapshot.data),
                          style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black54,
                        )
                      ],
                    ),
                  );
                },
              ),
              StreamBuilder(
                stream: _journalEditBloc.moodEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return DropdownButtonHideUnderline(
                      child: DropdownButton<MoodIcons>(
                    value: _moodIcons.getMoodIconsList()[
                      _moodIcons
                        .getMoodIconsList()
                        .indexWhere((e) => e.title == snapshot.data)
                    ],
                    onChanged: (selected) {
                      _journalEditBloc.moodEditChanged.add(selected!.title);
                    },
                    items: _moodIcons
                        .getMoodIconsList()
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Row(
                              children: <Widget>[
                                Transform(
                                  transform: Matrix4.identity()
                                    ..rotateZ(
                                        _moodIcons.getMoodRotation(e.title)),
                                  alignment: Alignment.center,
                                  child: Icon(_moodIcons.getMoodIcon(e.title),
                                      color: _moodIcons.getMoodColor(e.title)),
                                ),
                                const SizedBox(width: 16.0),
                                Text(e.title)
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ));
                },
              ),
              StreamBuilder(
                stream: _journalEditBloc.noteEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _noteController.value =
                      _noteController.value.copyWith(text: snapshot.data);

                  return TextField(
                    controller: _noteController,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: "Note",
                      icon: Icon(Icons.subject),
                    ),
                    maxLines: null,
                    onChanged: (n) => _journalEditBloc.noteEditChanged.add(n),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.grey.shade100),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {
                      _addOrUpdateJournal();
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.grey.shade100,
                        elevation: 3.0),
                    child: const Text("Save"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    _journalEditBloc.dispose();
    super.dispose();
  }
}
