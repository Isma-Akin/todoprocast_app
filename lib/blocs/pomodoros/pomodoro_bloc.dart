import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../models/sharedpreferences_helper.dart';
import '../../models/timer_models.dart';

part 'pomodoro_event.dart';
part 'pomodoro_state.dart';

class PomodoroBloc extends Bloc<PomodoroEvent, PomodoroState> {
  Timer? _timer;
  String? _activeTimerId;
  Map<String, String> todoTimerMap = {}; // Add this line here
  final SharedPreferencesHelper _prefsHelper = SharedPreferencesHelper();

  PomodoroBloc() : super(PomodoroInitial()) {
    on<StartPomodoro>(_mapStartPomodoroToState);
    on<CreatePomodoro>(_mapCreatePomodoroToState);
    on<LoadPomodoro>(_mapLoadPomodoroToState);
    on<PausePomodoro>(_mapPausePomodoroToState);
    on<ResumePomodoro>(_mapResumePomodoroToState);
    on<ResetPomodoro>(_mapResetPomodoroToState);
    on<StopPomodoro>(_mapStopPomodoroToState);
    on<TickPomodoro>(_mapTickPomodoroToState);
    on<PomodoroCompleted>(_mapPomodoroCompletedToState);
    on<TickBreak>(_mapTickBreakToState);

  }

  // void _mapStartPomodoroToState(StartPomodoro event, Emitter<PomodoroState> emit) async {
  //   _timer?.cancel();
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     add(TickPomodoro(event.timerId));
  //   });
  //
  //   var uuid = const Uuid();
  //   String timerId = uuid.v4();
  //   TimerModel timer = TimerModel(timerId, DateTime.now(), 25 * 60, TimerStatus.running);
  //   await _prefsHelper.saveTimer(timer);
  //
  //   emit(PomodoroRunning(25 * 60));
  // }
  // void _mapStartPomodoroToState(StartPomodoro event, Emitter<PomodoroState> emit) async {
  //   // Cancel the currently active timer
  //   if (_activeTimerId != null) {
  //     add(StopPomodoro(_activeTimerId!));
  //   }
  //
  //   var uuid = const Uuid();
  //   String timerId = uuid.v4();
  //   TimerModel timer = TimerModel(timerId, DateTime.now(), 25 * 60, TimerStatus.running);
  //   await _prefsHelper.saveTimer(timer);
  //
  //   // Save the ID of the currently active timer
  //   _activeTimerId = timerId;
  //
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     add(TickPomodoro(_activeTimerId!));
  //   });
  //
  //   emit(PomodoroRunning(25 * 60));
  // }
  // void _mapStartPomodoroToState2(StartPomodoro event, Emitter<PomodoroState> emit) async {
  //   // Cancel the currently active timer
  //   if (_activeTimerId != null) {
  //     add(StopPomodoro(_activeTimerId!));
  //   }
  //
  //   var uuid = const Uuid();
  //   String timerId = uuid.v4();
  //   TimerModel timer = TimerModel(timerId, DateTime.now(), 25 * 60, TimerStatus.running);
  //   await _prefsHelper.saveTimer(timer);
  //
  //   // Save the ID of the currently active timer
  //   _activeTimerId = timerId;
  //
  //   // Save the todo ID for this timer in SharedPreferences
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('selectedTodoId', event.todoId);
  //
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     add(TickPomodoro(_activeTimerId!));
  //   });
  //
  //   emit(PomodoroRunning(25 * 60));
  // }
  void _mapStartPomodoroToState(StartPomodoro event, Emitter<PomodoroState> emit) async {
    // Cancel the currently active timer
    if (_activeTimerId != null) {
      add(StopPomodoro(_activeTimerId!));
    }

    TimerModel timer = TimerModel(event.timerId, event.todoId, DateTime.now(), 25 * 60, TimerStatus.running);
    await _prefsHelper.saveTimer(timer);

    // Save the ID of the currently active timer
    _activeTimerId = event.timerId;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TickPomodoro(_activeTimerId!));
    });

    emit(PomodoroRunning(25 * 60));
  }



  void _mapCreatePomodoroToState(CreatePomodoro event, Emitter<PomodoroState> emit) async {
    int duration = 25 * 60;

    TimerModel timer = TimerModel(event.timerId, event.todoId, DateTime.now(), 25 * 60, TimerStatus.running);
    await _prefsHelper.saveTimer(timer);

    // Add the new timerId to the map
    todoTimerMap[event.todoId] = event.timerId;

    emit(PomodoroRunning(duration));
  }

  void _mapLoadPomodoroToState(LoadPomodoro event, Emitter<PomodoroState> emit) async {
    TimerModel? timer = await _prefsHelper.getTimer(event.timerId);
    if (timer != null) {
      if (timer.status == TimerStatus.running) {
        emit(PomodoroRunning(timer.duration));
      } else if (timer.status == TimerStatus.paused) {
        emit(PomodoroPaused(timer.duration));
      }
      // add more conditions for timer states
    }
  }


  // void _mapStopPomodoroToState(StopPomodoro event, Emitter<PomodoroState> emit) async {
  //   _timer?.cancel();
  //
  //   TimerModel? timer = await _prefsHelper.getTimer(event.timerId);
  //   if (timer != null) {
  //     timer.status = TimerStatus.stopped;
  //     await _prefsHelper.saveTimer(timer);
  //   }
  //
  //   emit(PomodoroStopped());
  // }
  void _mapStopPomodoroToState(StopPomodoro event, Emitter<PomodoroState> emit) async {
    _timer?.cancel();

    TimerModel? timer = await _prefsHelper.getTimer(event.timerId);
    if (timer != null) {
      timer.status = TimerStatus.stopped;
      await _prefsHelper.saveTimer(timer);
    }

    // Clear the ID of the currently active timer
    _activeTimerId = null;

    emit(PomodoroStopped());
  }

  void _mapPausePomodoroToState(PausePomodoro event, Emitter<PomodoroState> emit) async {
    if (state is PomodoroRunning) {
      final secondsRemaining = (state as PomodoroRunning).secondsRemaining;
      _timer?.cancel();

      TimerModel? timer = await _prefsHelper.getTimer(event.timerId);
      if (timer != null) {
        timer.status = TimerStatus.paused;
        timer.duration = secondsRemaining;
        await _prefsHelper.saveTimer(timer);
      }

      emit(PomodoroPaused(secondsRemaining));
    }
  }

  // void _mapResumePomodoroToState(ResumePomodoro event, Emitter<PomodoroState> emit) async {
  //   if (state is PomodoroPaused) {
  //     final secondsRemaining = (state as PomodoroPaused).secondsRemaining;
  //
  //     TimerModel? timer = await _prefsHelper.getTimer(event.timerId);
  //     if (timer != null) {
  //       timer.status = TimerStatus.running;
  //       timer.startTime = DateTime.now();
  //       await _prefsHelper.saveTimer(timer);
  //     }
  //
  //     emit(PomodoroRunning(secondsRemaining));
  //     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //       add(TickPomodoro(event.timerId));
  //     });
  //   }
  // }
  void _mapResumePomodoroToState(ResumePomodoro event, Emitter<PomodoroState> emit) async {
    if (state is PomodoroPaused) {
      final secondsRemaining = (state as PomodoroPaused).secondsRemaining;

      TimerModel? timer = await _prefsHelper.getTimer(event.timerId);
      if (timer != null) {
        TimerModel newTimer = TimerModel(
          timer.id,
          timer.todoId,
          DateTime.now(),
          timer.duration,
          TimerStatus.running,
        );
        await _prefsHelper.saveTimer(newTimer);

        emit(PomodoroRunning(secondsRemaining));
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          add(TickPomodoro(event.timerId));
        });
      }
    }
  }

  void _mapTickPomodoroToState(TickPomodoro event, Emitter<PomodoroState> emit) async {
    if (state is PomodoroRunning) {
      final secondsRemaining = (state as PomodoroRunning).secondsRemaining - 1;

      TimerModel? timer = await _prefsHelper.getTimer(event.timerId);
      if (timer != null) {
        timer.duration = secondsRemaining;
        await _prefsHelper.saveTimer(timer);
      }

      if (secondsRemaining > 0) {
        emit(PomodoroRunning(secondsRemaining));
      } else {
        _timer?.cancel();
        add(PomodoroCompleted());
      }
    }
  }


  // void _mapResetPomodoroToState(ResetPomodoro event, Emitter<PomodoroState> emit) async {
  //   _timer?.cancel();
  //
  //   TimerModel? timer = await _prefsHelper.getTimer(event.timerId);
  //   if (timer != null) {
  //     timer.status = TimerStatus.running;
  //     timer.startTime = DateTime.now();
  //     timer.duration = 25 * 60;
  //     await _prefsHelper.saveTimer(timer);
  //   }
  //
  //   emit(PomodoroRunning(25 * 60));
  // }
  void _mapResetPomodoroToState(ResetPomodoro event, Emitter<PomodoroState> emit) async {
    _timer?.cancel();

    TimerModel? timer = await _prefsHelper.getTimer(event.timerId);
    if (timer != null) {
      TimerModel newTimer = TimerModel(
        timer.id,
        timer.todoId,
        DateTime.now(),
        25 * 60,
        TimerStatus.running,
      );
      await _prefsHelper.saveTimer(newTimer);

      emit(PomodoroRunning(25 * 60));
    }
  }

  void _mapPomodoroCompletedToState(PomodoroCompleted event, Emitter<PomodoroState> emit) {
    emit(Break(5 * 60));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if(state is Break) {
        final remaining = (state as Break).secondsRemaining;
        if (remaining > 0) {
          emit(Break(remaining - 1));
        } else {
          _timer?.cancel();
          emit(PomodoroInitial());
        }
      }
    });
  }

  void _mapTickBreakToState(TickBreak event, Emitter<PomodoroState> emit) {
    if (state is Break) {
      final secondsRemaining = (state as Break).secondsRemaining - 1;
      if (secondsRemaining > 0) {
        emit(Break(secondsRemaining));
      } else {
        _timer?.cancel();
        emit(PomodoroInitial());
      }
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}