import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

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
  }

  void _mapStartPomodoroToState(StartPomodoro event, Emitter<PomodoroState> emit) {
    emit(PomodoroRunning(1500));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TickPomodoro());
    });
  }

  void _mapPausePomodoroToState(PausePomodoro event, Emitter<PomodoroState> emit) {
    if (state is PomodoroRunning) {
      final secondsRemaining = (state as PomodoroRunning).secondsRemaining;
      _timer?.cancel();
      emit(PomodoroPaused(secondsRemaining));
    } else if (state is PomodoroPaused) {
      final secondsRemaining = (state as PomodoroPaused).secondsRemaining;
      emit(PomodoroRunning(secondsRemaining));
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if(state is PomodoroRunning) {
          final remaining = (state as PomodoroRunning).secondsRemaining;
          if (remaining > 0) {
            emit(PomodoroRunning(remaining - 1));
          } else {
            _timer?.cancel();
            emit(PomodoroStopped());
          }
        }
      });
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
        emit(PomodoroStopped());
      }
    }
  }

  void _mapResetPomodoroToState(ResetPomodoro event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    emit(PomodoroRunning(25 * 60));
  }

  void _mapStopPomodoroToState(StopPomodoro event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    emit(PomodoroInitial());
  }
}
