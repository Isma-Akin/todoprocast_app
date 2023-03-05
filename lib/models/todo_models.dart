import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String task;
  final String description;
  bool? taskCompleted;
  bool? taskCancelled;
  bool? isFavourite;

  Todo({
    required this.id,
    required this.task,
    required this.description,
    this.taskCompleted,
    this.taskCancelled,
    this.isFavourite,
  }) {
    taskCompleted = taskCompleted ?? false;
    taskCancelled = taskCancelled ?? false;
    isFavourite = isFavourite ?? false;
  }

  Todo copyWith({
    String? id,
    String? task,
    String? description,
    bool? taskCompleted,
    bool? taskCancelled,
    bool? isFavourite,
  }) {
    return Todo(
      id: id ?? this.id,
      task: task ?? this.task,
      description: description ?? this.description,
      taskCompleted: taskCompleted ?? this.taskCompleted,
      taskCancelled: taskCancelled ?? this.taskCancelled,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        task,
        description,
        taskCompleted,
        taskCancelled,
        isFavourite,
      ];
}
