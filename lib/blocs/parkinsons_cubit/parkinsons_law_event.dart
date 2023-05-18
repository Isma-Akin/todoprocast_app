import '../../models/todo_models.dart';

abstract class ParkinsonEvent {}
class StartParkinson extends ParkinsonEvent {
  final DateTime deadline;
  final Todo? todo;
  StartParkinson(this.deadline, this.todo);
}
class PauseParkinson extends ParkinsonEvent {}
class ResumeParkinson extends ParkinsonEvent {}
class StopParkinson extends ParkinsonEvent {}
class TickParkinson extends ParkinsonEvent {}