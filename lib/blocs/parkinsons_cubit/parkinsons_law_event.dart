import '../../models/todo_models.dart';

abstract class ParkinsonEvent {}
class StartParkinson extends ParkinsonEvent {
  final int timerId;
  final DateTime deadline;
  final Todo? todo;
  StartParkinson(this.timerId, this.deadline, this.todo);
}

class PauseParkinson extends ParkinsonEvent {}
class ResumeParkinson extends ParkinsonEvent {}

class StopParkinson extends ParkinsonEvent {
  final int todoId;
  StopParkinson(this.todoId);
}

class TickParkinson extends ParkinsonEvent {
  final int todoId;
  TickParkinson(this.todoId);
}