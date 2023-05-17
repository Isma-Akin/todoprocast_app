part of 'pomodoro_bloc.dart';

abstract class PomodoroEvent {}

class StartPomodoro extends PomodoroEvent {
  final Todo? todo;

  StartPomodoro({required this.todo});
}

class PausePomodoro extends PomodoroEvent {}

class ResumePomodoro extends PomodoroEvent {}

class TickPomodoro extends PomodoroEvent {}

class TickBreak extends PomodoroEvent {}

class PomodoroCompleted extends PomodoroEvent {}

class ResetPomodoro extends PomodoroEvent {}

class StopPomodoro extends PomodoroEvent {}

