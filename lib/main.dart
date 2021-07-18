///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 18/ 7/ 2021
///------------------------------------------------------------------

///----------------------------------------------------------------///
///                    Import Library                             ///
///--------------------------------------------------------------///

import 'package:counter_app/fancy_button.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/// Class's document:
/// MyApp is a widget
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learning Flutter',
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
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: "Thinh's Home Page"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final List<Color> colors = [
    Colors.amberAccent,
    Colors.cyan,
    Colors.deepOrangeAccent
  ];
  bool _reversed = false;
  List<UniqueKey> _buttonKeys = [UniqueKey(), UniqueKey()];

  ///----------------------------------------------------------------///
  ///                    setState() methods                         ///
  ///--------------------------------------------------------------///

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() => _counter--);
  }

  void _resetCounter() {
    setState(() => _counter = 0);

    /// Turns around and calls (invoke) _swap() method
    /// which will swap the button's locations.
    _swap();
  }

  /// private swap() method
  /// This method updates the _reversed Boolean and call setState()
  /// which triggers a rebuild!
  void _swap() {
    setState(() {
      _reversed = !_reversed;
    });
  }

  ///----------------------------------------------------------------///
  ///                    Build Context                              ///
  ///--------------------------------------------------------------///

  @override
  Widget build(BuildContext context) {
    // FancyButton: increments counter by one unit
    final incrementButton = FancyButton(
      key: _buttonKeys.first,
      child: Text(
        "Increment",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: _incrementCounter,
    );
    //FancyButton: decrements counter by one unit
    final decrementButton = FancyButton(
      key: _buttonKeys.last,
      child: Text(
        "Decrement",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: _decrementCounter,
    );
    // Buttons which will be passed into a Row and displays these widgets
    var _buttons = <Widget>[incrementButton, decrementButton];

    /// If the _reversed is true, reverses the order of the buttons.
    /// Since this happens in the build method,
    /// they're swapped whenever setState is called and _reversed has been updated.
    if (_reversed) {
      _buttons = _buttons.reversed.toList();
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: this.colors[_counter % this.colors.length],
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
            Container(
              margin: EdgeInsets.only(bottom: 50.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(4.0)),
              child: Image.asset(
                'flutter_logo_1080.png',
                width: 100.0,
              ),
            ),

            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline1,
            ),
            // ElevatedButton(
            //   child: Text("Dec Counter"),
            //   onPressed: _decrementCounter,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buttons,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetCounter,
        tooltip: 'Reset Counter',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
