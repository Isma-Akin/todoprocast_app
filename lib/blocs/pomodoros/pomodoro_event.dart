part of 'pomodoro_bloc.dart';

abstract class PomodoroEvent {}

class StartPomodoroEvent extends PomodoroEvent {
  final Todo todo;


  StartPomodoroEvent(this.todo);
}

class StopPomodoroEvent extends PomodoroEvent {
  final Todo todo;
  final int todoId;

  StopPomodoroEvent(this.todoId, this.todo);
}

class StopAllPomodorosEvent extends PomodoroEvent {}

class TickPomodoroEvent extends PomodoroEvent {
  final int todoId;
  final Duration duration;

  TickPomodoroEvent(this.todoId, this.duration);
}

class PausePomodoroEvent extends PomodoroEvent {
  final int todoId;

  PausePomodoroEvent(this.todoId);
}

class ResumePomodoroEvent extends PomodoroEvent {
  final int todoId;

  ResumePomodoroEvent(this.todoId);
}

class ResetPomodoroEvent extends PomodoroEvent {
  final int todoId;

  ResetPomodoroEvent(this.todoId);
}
