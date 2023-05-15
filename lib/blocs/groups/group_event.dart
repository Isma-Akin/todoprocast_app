import '../../models/group_models.dart';
import '../../models/todo_models.dart';

abstract class GroupEvent {}

class AddGroup extends GroupEvent {
  final Group group;

  AddGroup(this.group);
}

class RemoveGroup extends GroupEvent {
  final Group group;

  RemoveGroup(this.group);
}

class AddTodoToGroup extends GroupEvent {
  final Todo todo;
  final Group group;

  AddTodoToGroup(this.todo, this.group);
}

class LoadGroups extends GroupEvent {}