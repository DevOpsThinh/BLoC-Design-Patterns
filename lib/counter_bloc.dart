import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

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
/// CounterBloc is managed by the  bloc library - provides automatic stream management for us.
/// Reference: https://github.com/felangel/bloc/issues/2526
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  // Initializing initial CounterState class
  CounterBloc(CounterState initialState): super(initialState) {
    // Mapping events to theirs corresponding state based on the business logic
    on<IncrementEvent>(_onIncrement);
    on<DecrementEvent>(_onDecrement);
    on<ResetEvent>(_onReset);
  }

  void _onIncrement(IncrementEvent event, Emitter<CounterState> emit) {
    emit(CounterState(counter: state.counter + 1));
  }

  void _onDecrement(DecrementEvent event, Emitter<CounterState> emit) {
    emit(CounterState(counter: state.counter - 1));
  }

  void _onReset(ResetEvent event, Emitter<CounterState> emit) {
    emit(const CounterState(counter: 0));
  }
}