part of 'pomodoro_bloc.dart';

abstract class PomodoroEvent {}

// class StartPomodoro extends PomodoroEvent {
//   final Todo todo;
//   final String timerId;
//
//   StartPomodoro(this.todo, {required this.timerId});
//
//   @override
//   List<Object> get props => [timerId, todo];
// }
class StartPomodoro extends PomodoroEvent {
  final String timerId;
  final String todoId;

  StartPomodoro({required this.timerId, required this.todoId});

  List<Object> get props => [timerId, todoId];
}

class CreatePomodoro extends PomodoroEvent {
  final String timerId;
  final String todoId;

  CreatePomodoro({required this.timerId, required this.todoId});
}

class LoadPomodoro extends PomodoroEvent {
  final String timerId;

  LoadPomodoro({required this.timerId});
}

class PausePomodoro extends PomodoroEvent {
  final String timerId;

  PausePomodoro(this.timerId);
}

class ResumePomodoro extends PomodoroEvent {
  final String timerId;

  ResumePomodoro({required this.timerId});

  List<Object> get props => [timerId];
}

class TickPomodoro extends PomodoroEvent {
  final String timerId;

  TickPomodoro(this.timerId);
}

class TickBreak extends PomodoroEvent {}

class PomodoroCompleted extends PomodoroEvent {}

class ResetPomodoro extends PomodoroEvent {
  final String timerId;

  ResetPomodoro(this.timerId);
}

class StopPomodoro extends PomodoroEvent {
  final String timerId;

  StopPomodoro(this.timerId);
}

