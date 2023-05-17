part of 'pomodoro_bloc.dart';

abstract class PomodoroState {}

class PomodoroInitial extends PomodoroState {}

class PomodoroRunning extends PomodoroState {
  final int secondsRemaining;

  PomodoroRunning(this.secondsRemaining);
}

class PomodoroPaused extends PomodoroState {
  final int secondsRemaining;

  PomodoroPaused(this.secondsRemaining, ) : super();

  @override
  List<Object> get props => [secondsRemaining];
}

class PomodoroStopped extends PomodoroState {

  PomodoroStopped() : super();
}

class PomodoroNotStarted extends PomodoroState {

  PomodoroNotStarted() : super();
}


class Break extends PomodoroState {
  final int secondsRemaining;

  Break(this.secondsRemaining);
}


