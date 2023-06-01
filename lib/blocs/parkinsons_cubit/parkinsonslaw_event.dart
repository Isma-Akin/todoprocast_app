import '../../models/todo_models.dart';

abstract class ParkinsonsLawEvent {}

class StartCountdownEvent extends ParkinsonsLawEvent {
  final Todo todo;

  StartCountdownEvent(this.todo);
}

class StopCountdownEvent extends ParkinsonsLawEvent {
  final int todoId;

  StopCountdownEvent(this.todoId);
}

class StopAllCountdownEvent extends ParkinsonsLawEvent {}

class TickEvent extends ParkinsonsLawEvent {
  final int todoId;
  final Duration duration;

  TickEvent(this.todoId, this.duration);
}
