import 'package:todoprocast_app/models/timeblock_models.dart';

import '../../models/todo_models.dart';

abstract class TimeBlocksEvent {}

class LoadTimeBlocks extends TimeBlocksEvent {
  final Todo todo;

  LoadTimeBlocks(this.todo);
}

class AddTimeBlock extends TimeBlocksEvent {
  final Todo todo;
  final TaskModel taskModel;

  AddTimeBlock({required this.todo, required this.taskModel});

  @override
  List<Object> get props => [todo, taskModel];
}

class UpdateTimeBlock extends TimeBlocksEvent {
  final Todo todo;
  final TaskModel taskModel;

  UpdateTimeBlock(this.todo, this.taskModel);
}

class DeleteTimeBlock extends TimeBlocksEvent {
  final Todo todo;
  final TaskModel taskModel;

  DeleteTimeBlock(this.todo, this.taskModel);
}
