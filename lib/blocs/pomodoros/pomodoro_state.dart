part of 'pomodoro_bloc.dart';

abstract class PomodoroState {
  final Map<int, Duration> activeTodos;

  PomodoroState({this.activeTodos = const {}});

  @override
  List<Object> get props => [activeTodos];
}

class PomodoroInitial extends PomodoroState {
  PomodoroInitial({Map<int, Duration> activeTodos = const {}})
      : super(activeTodos: activeTodos);
}

class PomodoroInProgress extends PomodoroState {
  final int todoId;
  final Duration remainingTime;

  PomodoroInProgress({
    required this.todoId,
    required this.remainingTime,
    Map<int, Duration> activeTodos = const {},
  }) : super(activeTodos: activeTodos);

  @override
  List<Object> get props => super.props..addAll([todoId, remainingTime]);
}

class PomodoroPaused extends PomodoroState {
  final int todoId;
  final Duration remainingTime;

  PomodoroPaused({
    required this.todoId,
    required this.remainingTime,
    Map<int, Duration> activeTodos = const {},
  }) : super(activeTodos: activeTodos);

  @override
  List<Object> get props => super.props..addAll([todoId, remainingTime]);
}

class PomodoroFinished extends PomodoroState {
  final int todoId;

  PomodoroFinished({
    required this.todoId,
    Map<int, Duration> activeTodos = const {},
  }) : super(activeTodos: activeTodos);

  @override
  List<Object> get props => super.props..add(todoId);
}



