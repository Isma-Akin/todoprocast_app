import 'package:equatable/equatable.dart';

abstract class ParkinsonsLawState extends Equatable {
  final Map<int, Duration> activeTodos;

  ParkinsonsLawState({this.activeTodos = const {}});

  @override
  List<Object> get props => [activeTodos];
}

class ParkinsonsInitial extends ParkinsonsLawState {
  ParkinsonsInitial({Map<int, Duration> activeTodos = const {}})
      : super(activeTodos: activeTodos);
}

class ParkinsonInProgress extends ParkinsonsLawState {
  final int todoId;
  final DateTime? dueDate;
  final Duration remainingTime;

  ParkinsonInProgress({
    required this.todoId,
    required this.remainingTime,
    required this.dueDate,
    Map<int, Duration> activeTodos = const {},
  }) : super(activeTodos: activeTodos);

  @override
  List<Object> get props => super.props..addAll([todoId, remainingTime, dueDate!]);
}

class ParkinsonFinished extends ParkinsonsLawState {
  final int todoId;

  ParkinsonFinished({
    required this.todoId,
    Map<int, Duration> activeTodos = const {},
  }) : super(activeTodos: activeTodos);

  @override
  List<Object> get props => super.props..add(todoId);
}

