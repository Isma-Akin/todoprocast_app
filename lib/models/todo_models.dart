import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Todo extends Equatable {
  final String id;
  final String task;
  final String description;
  final DateTime dateCreated;
  bool? taskCompleted;
  bool? taskCancelled;
  bool? isFavourite;
  final List<String> steps;

  Todo({
    required this.id,
    required this.task,
    required this.description,
    required this.dateCreated,
    this.taskCompleted,
    this.taskCancelled,
    this.isFavourite,
    this.steps = const <String>[],
  }) {
    taskCompleted = taskCompleted ?? false;
    taskCancelled = taskCancelled ?? false;
    isFavourite = isFavourite ?? false;
  }

  // DateTime get dateCreatedInLocal => dateCreated.toLocal();
  String get formattedDateCreated =>
      DateFormat('dd-MM-yyy HH:mm').format(dateCreated.toLocal());

  Todo copyWith({
    String? id,
    String? task,
    String? description,
    DateTime? dateCreated,
    bool? taskCompleted,
    bool? taskCancelled,
    bool? isFavourite,
    String? steps,
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
        steps,
      ];
}
