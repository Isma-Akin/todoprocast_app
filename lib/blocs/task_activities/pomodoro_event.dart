part of 'pomodoro_bloc.dart';

abstract class PomodoroEvent {}

class StartPomodoro extends PomodoroEvent {}

class PausePomodoro extends PomodoroEvent {}

class ResumePomodoro extends PomodoroEvent {}

class TickPomodoro extends PomodoroEvent {}

class ResetPomodoro extends PomodoroEvent {}

class StopPomodoro extends PomodoroEvent {}

class PomodoroCompleted extends PomodoroEvent {}
