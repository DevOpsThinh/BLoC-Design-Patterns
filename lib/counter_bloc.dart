import 'dart:async';

///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 23/ 4/ 2023
///------------------------------------------------------------------

/// Abstract class's document:
/// CounterEvent is used to support multiple different types of events handled by the app.
abstract class CounterEvent {}
class IncrementEvent extends CounterEvent {}
class DecrementEvent extends CounterEvent {}
class ResetEvent extends CounterEvent {}
/// Class's document:
/// The counter's state is defined using a CounterState class
class CounterState {
  final int counter;
  const CounterState({ required this.counter });
  factory CounterState.initial() => const CounterState(counter: 0);
}
/// Class's document:
/// CounterBloc manages both the event & state streams with respective StreamController(s).
class CounterBloc {
  // Setting the initial state for the CounterState class
  CounterState _currentState = const CounterState(counter: 0);
  // Managing input event stream
  final _eventController = StreamController<CounterEvent>();
  final _stateController = StreamController<CounterState>();
  // UI  interaction events are pushed into sink _eventController's sink
  Sink<CounterEvent> get eventSink => _eventController.sink;
  StreamSink<CounterState> get _stateSink => _stateController.sink;
  Stream<CounterState> get counter => _stateController.stream;

  /// Listening to incoming UI events and mapping them into corresponding output States
  CounterBloc() {
    _eventController.stream.listen((event) {
      _mapEventToState(event);
    });
    // _eventController.stream.listen(_mapEventToState);
  }
  /// Mapping event to state
  void _mapEventToState(CounterEvent event) {
    if (event is IncrementEvent) {
      _currentState = CounterState(counter: _currentState.counter + 1);
    } else if (event is DecrementEvent) {
      _currentState = CounterState(counter: _currentState.counter - 1);
    } else if (event is ResetEvent) {
      _currentState = const CounterState(counter: 0);
    }

    _stateSink.add(_currentState);
  }
  /// Closing the stream controllers for the event & state streams (avoid memory leaks).
  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}