import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String task;
  final String description;
  final DateTime dateCreated;
  bool? taskCompleted;
  bool? taskCancelled;
  bool? isFavourite;

  Todo({
    required this.id,
    required this.task,
    required this.description,
    required this.dateCreated,
    this.taskCompleted,
    this.taskCancelled,
    this.isFavourite,
  }) {
    taskCompleted = taskCompleted ?? false;
    taskCancelled = taskCancelled ?? false;
    isFavourite = isFavourite ?? false;
  }

  DateTime get dateCreatedInLocal => dateCreated.toLocal();

  Todo copyWith({
    String? id,
    String? task,
    String? description,
    DateTime? dateCreated,
    bool? taskCompleted,
    bool? taskCancelled,
    bool? isFavourite,
  }) {
    return Todo(
      id: id ?? this.id,
      task: task ?? this.task,
      description: description ?? this.description,
      dateCreated: dateCreated ?? this.dateCreated,
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
        dateCreated,
        taskCompleted,
        taskCancelled,
        isFavourite,
      ];
}
