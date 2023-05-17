import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/todo_models.dart';

part 'pomodoro_event.dart';
part 'pomodoro_state.dart';

class PomodoroBloc extends Bloc<PomodoroEvent, PomodoroState> {
  Timer? _timer;

  PomodoroBloc() : super(PomodoroInitial()) {
    on<StartPomodoro>(_mapStartPomodoroToState);
    on<PausePomodoro>(_mapPausePomodoroToState);
    on<ResumePomodoro>(_mapResumePomodoroToState);
    on<ResetPomodoro>(_mapResetPomodoroToState);
    on<StopPomodoro>(_mapStopPomodoroToState);
    on<TickPomodoro>(_mapTickPomodoroToState);
    on<PomodoroCompleted>(_mapPomodoroCompletedToState);
    on<TickBreak>(_mapTickBreakToState);

  }

  void _mapStartPomodoroToState(StartPomodoro event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TickPomodoro());
    });
    emit(PomodoroRunning(25 * 60));
  }

  void _mapPausePomodoroToState(PausePomodoro event, Emitter<PomodoroState> emit) {
    if (state is PomodoroRunning) {
      final secondsRemaining = (state as PomodoroRunning).secondsRemaining;
      _timer?.cancel();
      emit(PomodoroPaused(secondsRemaining));
    }
  }

  void _mapResumePomodoroToState(ResumePomodoro event, Emitter<PomodoroState> emit) {
    if (state is PomodoroPaused) {
      final secondsRemaining = (state as PomodoroPaused).secondsRemaining;
      emit(PomodoroRunning(secondsRemaining));
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        add(TickPomodoro());
      });
    }
  }

  void _mapTickPomodoroToState(TickPomodoro event, Emitter<PomodoroState> emit) {
    if (state is PomodoroRunning) {
      final secondsRemaining = (state as PomodoroRunning).secondsRemaining - 1;
      if (secondsRemaining > 0) {
        emit(PomodoroRunning(secondsRemaining));
      } else {
        _timer?.cancel();
        add(PomodoroCompleted());
      }
    }
  }

  void _mapResetPomodoroToState(ResetPomodoro event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    emit(PomodoroRunning(25 * 60));
  }

  void _mapPomodoroCompletedToState(PomodoroCompleted event, Emitter<PomodoroState> emit) {
    emit(Break(5 * 60)); // let's say the break is 5 minutes
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

  void _mapStopPomodoroToState(StopPomodoro event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    emit(PomodoroStopped());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}