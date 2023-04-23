///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 18/ 7/ 2021
///------------------------------------------------------------------

///----------------------------------------------------------------///
///                    Import Library                             ///
///--------------------------------------------------------------///

import 'package:counter_app/counter_bloc.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// Class's document:
/// MyApp is a widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.

        //primarySwatch: Colors.blue,
        primarySwatch: Colors.indigo,
      ),
      home: const ThinhHomePage(title: "Thinh's Home"),
    );
  }
}

class ThinhHomePage extends StatefulWidget {
  const ThinhHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  ThinhHomePageState createState() => ThinhHomePageState();
}

class ThinhHomePageState extends State<ThinhHomePage> {
  final CounterBloc _bloc = CounterBloc();

  // int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _bloc.eventSink.add(IncrementEvent());
    });
  }

  void _decrementCounter() {
    setState(() => _bloc.eventSink.add(DecrementEvent()));
  }

  void _resetCounter() {
    setState(() => _bloc.eventSink.add(ResetEvent()));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgNGdH6wUBTLeEpqTb-53rFi3FoaGBJywyEA&usqp=CAU",
              width: 100.0,
              scale: 1.5,
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder(
              stream: _bloc.counter,
              initialData: CounterState.initial(),
              builder: (BuildContext context, AsyncSnapshot<CounterState> snapshot) {
                return Text(
                  '${snapshot.data?.counter}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red)),
                  onPressed: _decrementCounter,
                  child: const Text(
                    "Decrement",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                  onPressed: _incrementCounter,
                  child: const Text(
                    "Increment",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetCounter,
        tooltip: 'Reset Counter',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    super.dispose();
    //  Close bloc's stream controllers
    _bloc.dispose();
  }
}
