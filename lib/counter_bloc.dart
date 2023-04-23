import 'dart:async';

///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 23/ 4/ 2023
///------------------------------------------------------------------

/// Enumeration's document:
/// CounterEvent is used to declare the event to increment/ decrement the count.
enum CounterEvent {
  increment,
  decrement,
  reset
}

/// Class's document:
/// CounterBloc manages both the event & state streams with respective StreamController(s).
class CounterBloc {
  int _counter = 0;
  final _eventController = StreamController<CounterEvent>();
  final _stateController = StreamController<int>();
  Sink<CounterEvent> get eventSink => _eventController.sink;
  StreamSink<int> get _stateSink => _stateController.sink;
  Stream<int> get counter => _stateController.stream;

  CounterBloc() {
    _eventController.stream.listen((event) {
      _mapEventToState(event);
    });
    // _eventController.stream.listen(_mapEventToState);
  }

  /// Mapping event to state
  void _mapEventToState(CounterEvent event) {
    if (event == CounterEvent.increment) {
      _counter ++;
    } else if (event == CounterEvent.decrement) {
      _counter--;
    } else if (event == CounterEvent.reset) {
      _counter = 0;
    }

    _stateSink.add(_counter);
  }
  /// Closing the stream controllers for the event & state streams (avoid memory leaks).
  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}