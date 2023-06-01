import 'dart:async';

import 'package:todoprocast_app/blocs/parkinsons_cubit/parkinsonslaw_event.dart';

import '../blocs.dart';
import 'parkinsonslaw_state.dart';

class ParkinsonsLawBloc extends HydratedBloc<ParkinsonsLawEvent, ParkinsonsLawState> {
  ParkinsonsLawBloc() : super(ParkinsonsInitial()) {
    on<StartCountdownEvent>(_mapStartCountdownToState);
    on<StopCountdownEvent>(_mapStopCountdownToState);
    on<StopAllCountdownEvent>(_mapStopAllCountdownToState);
    on<TickEvent>(_mapTickEventToState);
  }

  // keeps track of all active timers
  final Map<int, Timer> activeTimers = {};

  void _mapStartCountdownToState(StartCountdownEvent event, Emitter<ParkinsonsLawState> emit) {
    final newActiveTodos = Map<int, Duration>.from(state.activeTodos);
    final duration = event.todo.dueDate?.difference(DateTime.now());
    newActiveTodos[event.todo.id] = duration!;
    emit(ParkinsonsInitial(activeTodos: newActiveTodos));

    final timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) => add(TickEvent(event.todo.id, const Duration(seconds: 1))),
    );

    activeTimers[event.todo.id] = timer;
  }

  void _mapStopAllCountdownToState(StopAllCountdownEvent event, Emitter<ParkinsonsLawState> emit) {
    final newActiveTodos = Map<int, Duration>.from(state.activeTodos);
    newActiveTodos.clear();
    emit(ParkinsonsInitial(activeTodos: newActiveTodos));

    activeTimers.forEach((key, value) {
      value.cancel();
    });
    activeTimers.clear();
  }

  void _mapStopCountdownToState(StopCountdownEvent event, Emitter<ParkinsonsLawState> emit) {
    final newActiveTodos = Map<int, Duration>.from(state.activeTodos);
    newActiveTodos.remove(event.todoId);
    emit(ParkinsonsInitial(activeTodos: newActiveTodos));

    activeTimers[event.todoId]?.cancel();
    activeTimers.remove(event.todoId);
  }

  void _mapTickEventToState(TickEvent event, Emitter<ParkinsonsLawState> emit) {
    final selectedTodoId = event.todoId;
    final tickDuration = event.duration;

    // we only proceed if the todo is in the activeTodos map
    if (state.activeTodos.containsKey(selectedTodoId)) {
      final remainingTime = state.activeTodos[selectedTodoId];

      // check if the remaining time is not null and more than the tick duration
      if (remainingTime != null && remainingTime > tickDuration) {
        // subtract the duration of the tick from the remaining time
        final newRemainingTime = remainingTime - tickDuration;
        final newActiveTodos = Map<int, Duration>.from(state.activeTodos);
        newActiveTodos[selectedTodoId] = newRemainingTime;

        emit(ParkinsonInProgress(
          todoId: selectedTodoId,
          remainingTime: newRemainingTime,
          activeTodos: newActiveTodos,
          dueDate: DateTime.now().add(newRemainingTime),
        ));
      } else {
        // The time has expired
        final newActiveTodos = Map<int, Duration>.from(state.activeTodos);
        newActiveTodos.remove(selectedTodoId);
        emit(ParkinsonFinished(
          todoId: selectedTodoId,
          activeTodos: newActiveTodos,
        ));

        // dispose of the timer
        activeTimers[selectedTodoId]?.cancel();
        activeTimers.remove(selectedTodoId);
      }
    }
  }

  @override
  ParkinsonsLawState? fromJson(Map<String, dynamic> json) {
    try {
      Map<int, Duration> activeTodos = Map<int, Duration>.from(json['activeTodos'].map((key, value) => MapEntry(int.parse(key), Duration(milliseconds: value))));
      return ParkinsonsInitial(activeTodos: activeTodos);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ParkinsonsLawState state) {
    try {
      Map<String, int> activeTodos = state.activeTodos.map((key, value) => MapEntry(key.toString(), value.inMilliseconds));
      return {'activeTodos': activeTodos};
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> close() {
    for (var timer in activeTimers.values) {
      timer.cancel();
    }
    activeTimers.clear();
    return super.close();
  }

}

