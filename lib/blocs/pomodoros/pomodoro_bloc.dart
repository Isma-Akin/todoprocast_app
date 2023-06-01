import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../models/sharedpreferences_helper.dart';
import '../../models/todo_models.dart';
import '../blocs.dart';

part 'pomodoro_event.dart';
part 'pomodoro_state.dart';

class PomodoroBloc extends HydratedBloc<PomodoroEvent, PomodoroState> {
  PomodoroBloc() : super(PomodoroInitial()) {
    on<StartPomodoroEvent>(_mapStartPomodoroToState);
    on<StopPomodoroEvent>(_mapStopPomodoroToState);
    on<StopAllPomodorosEvent>(_mapStopAllPomodorosToState);
    on<TickPomodoroEvent>(_mapTickPomodoroToState);
    on<PausePomodoroEvent>(_mapPausePomodoroToState);
    on<ResumePomodoroEvent>(_mapResumePomodoroToState);
    on<ResetPomodoroEvent>(_mapResetPomodoroToState);
  }
  final Map<int, Timer> activePomodoros = {};

  void _mapStartPomodoroToStateOld(StartPomodoroEvent event, Emitter<PomodoroState> emit) async {
    activePomodoros[event.todo.id]?.cancel();
    Duration duration = const Duration(minutes: 25);
    final timer = Timer.periodic(
        const Duration(seconds: 1),
            (timer) {
          add(TickPomodoroEvent(event.todo.id, duration));
          duration = duration - const Duration(seconds: 1);
        });

    activePomodoros[event.todo.id] = timer;
  }
  void _mapStartPomodoroToState(StartPomodoroEvent event, Emitter<PomodoroState> emit) async {
    activePomodoros[event.todo.id]?.cancel();
    Duration duration = const Duration(minutes: 25);
    final timer = Timer.periodic(
        const Duration(seconds: 1),
            (timer) {
          add(TickPomodoroEvent(event.todo.id, duration));
          duration = duration - const Duration(seconds: 1);
        });

    activePomodoros[event.todo.id] = timer;
    event.todo.updateTaskActivity('Pomodoro');
  }

  void _mapStopPomodoroToStateOld(StopPomodoroEvent event, Emitter<PomodoroState> emit) {
    final newActiveTodos = Map<int, Duration>.from(state.activeTodos);
    newActiveTodos.remove(event.todoId);
    emit(PomodoroInitial(activeTodos: newActiveTodos));

    activePomodoros[event.todoId]?.cancel();
    activePomodoros.remove(event.todoId);
  }
  void _mapStopPomodoroToState(StopPomodoroEvent event, Emitter<PomodoroState> emit) {
    activePomodoros[event.todo.id]?.cancel();
    activePomodoros.remove(event.todo.id);
    final newActiveTodos = Map<int, Duration>.from(state.activeTodos);
    newActiveTodos.remove(event.todo.id);
    emit(PomodoroInitial(activeTodos: newActiveTodos));
    event.todo.removeTaskActivity('Pomodoro');
  }

  void _mapStopAllPomodorosToState(StopAllPomodorosEvent event, Emitter<PomodoroState> emit) {
    emit(PomodoroInitial());

    activePomodoros.forEach((key, value) {
      value.cancel();
    });
    activePomodoros.clear();
  }

  void _mapTickPomodoroToState(TickPomodoroEvent event, Emitter<PomodoroState> emit) {
    if (event.duration.isNegative) {
      activePomodoros[event.todoId]?.cancel();
      activePomodoros.remove(event.todoId);
      emit(PomodoroFinished(todoId: event.todoId));
    } else {
      final newActiveTodos = Map<int, Duration>.from(state.activeTodos);
      newActiveTodos[event.todoId] = event.duration;
      emit(PomodoroInProgress(todoId: event.todoId, remainingTime: event.duration, activeTodos: newActiveTodos));
    }
  }

  void _mapPausePomodoroToStateOld(PausePomodoroEvent event, Emitter<PomodoroState> emit) {
    activePomodoros[event.todoId]?.cancel();
  }
  void _mapPausePomodoroToState(PausePomodoroEvent event, Emitter<PomodoroState> emit) {
    Timer? timer = activePomodoros[event.todoId];
    timer?.cancel();

    final currentDuration = state.activeTodos[event.todoId];
    if (currentDuration != null) {
      emit(PomodoroPaused(todoId: event.todoId, remainingTime: currentDuration));
    }
  }

  void _mapResumePomodoroToStateOld(ResumePomodoroEvent event, Emitter<PomodoroState> emit) {
    final duration = state.activeTodos[event.todoId];
    if (duration != null) {
      final timer = Timer.periodic(
        const Duration(seconds: 1),
            (timer) => add(TickPomodoroEvent(event.todoId, duration)),
      );
      activePomodoros[event.todoId] = timer;
    }
  }

  void _mapResumePomodoroToState(ResumePomodoroEvent event, Emitter<PomodoroState> emit) {
    Duration? remainingTime;
    if (state is PomodoroPaused && (state as PomodoroPaused).todoId == event.todoId) {
      remainingTime = (state as PomodoroPaused).remainingTime;
    } else {
      remainingTime = state.activeTodos[event.todoId];
    }

    if (remainingTime != null) {
      final timer = Timer.periodic(
        const Duration(seconds: 1),
            (Timer timer) {
          remainingTime = remainingTime! - Duration(seconds: 1);
          if (remainingTime! <= Duration.zero) {
            timer.cancel();
            emit(PomodoroFinished(activeTodos: state.activeTodos..remove(event.todoId), todoId: event.todoId));
          } else {
            add(TickPomodoroEvent(event.todoId, remainingTime ?? Duration.zero));
          }
        },
      );
      activePomodoros[event.todoId] = timer;
      emit(PomodoroInProgress(todoId: event.todoId, remainingTime: remainingTime ?? Duration.zero));
    }
  }


  void _mapResetPomodoroToState(ResetPomodoroEvent event, Emitter<PomodoroState> emit) {
    activePomodoros[event.todoId]?.cancel();
    activePomodoros.remove(event.todoId);
    final newActiveTodos = Map<int, Duration>.from(state.activeTodos);
    newActiveTodos.remove(event.todoId);
    emit(PomodoroInitial(activeTodos: newActiveTodos));
  }


  @override
  PomodoroState? fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'PomodoroInProgress') {
      return PomodoroInProgress(
        todoId: json['todoId'],
        remainingTime: Duration(seconds: json['remainingTime']),
        activeTodos: Map<int, Duration>.from(
          json['activeTodos'].map((key, value) => MapEntry(int.parse(key), Duration(seconds: value))),
        ),
      );
    } else if (json['type'] == 'PomodoroFinished') {
      return PomodoroFinished(
        todoId: json['todoId'],
        activeTodos: Map<int, Duration>.from(
          json['activeTodos'].map((key, value) => MapEntry(int.parse(key), Duration(seconds: value))),
        ),
      );
    } else {
      return PomodoroInitial(
        activeTodos: Map<int, Duration>.from(
          json['activeTodos'].map((key, value) => MapEntry(int.parse(key), Duration(seconds: value))),
        ),
      );
    }
  }

  @override
  Map<String, dynamic>? toJson(PomodoroState state) {
    if (state is PomodoroInProgress) {
      return {
        'type': 'PomodoroInProgress',
        'todoId': state.todoId,
        'remainingTime': state.remainingTime.inSeconds,
        'activeTodos': state.activeTodos.map((key, value) => MapEntry(key.toString(), value.inSeconds)),
      };
    } else if (state is PomodoroFinished) {
      return {
        'type': 'PomodoroFinished',
        'todoId': state.todoId,
        'activeTodos': state.activeTodos.map((key, value) => MapEntry(key.toString(), value.inSeconds)),
      };
    } else {
      return {
        'type': 'PomodoroInitial',
        'activeTodos': state.activeTodos.map((key, value) => MapEntry(key.toString(), value.inSeconds)),
      };
    }
  }

  @override
  Future<void> close() {
    for (var timer in activePomodoros.values) {
      timer.cancel();
    }
    activePomodoros.clear();
    return super.close();
  }
}