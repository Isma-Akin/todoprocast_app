import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String task;
  final String description;
  bool? taskCompleted;
  bool? taskCancelled;

  Todo({
    required this.id,
    required this.task,
    required this.description,
    this.taskCompleted,
    this.taskCancelled,
})

}
