import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../api/custom_serializer.dart';

class Todo extends Equatable {
  final int id;
  final String task;
  final String description;
  final DateTime dateCreated;
  final DateTime dueDate;
  bool? taskCompleted;
  bool? taskCancelled;
  bool? isFavourite;
  final List<String> steps;

  Todo({
    required this.id,
    required this.task,
    required this.description,
    required this.dateCreated,
    required this.dueDate,
    this.taskCompleted,
    this.taskCancelled,
    this.isFavourite,
    this.steps = const <String>[],
  }) {
    taskCompleted = taskCompleted ?? false;
    taskCancelled = taskCancelled ?? false;
    isFavourite = isFavourite ?? false;
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      task: json['task'],
      description: json['description'],
      dateCreated: _dateTimeFromJson(json['dateCreated']),
      dueDate: _dateTimeFromJson(json['dueDate']),
      taskCompleted: json['taskCompleted'],
      taskCancelled: json['taskCancelled'],
      isFavourite: json['isFavourite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task': task,
      'description': description,
      'dateCreated': _dateTimeToJson(dateCreated),
      'dueDate': _dateTimeToJson(dueDate),
      'taskCompleted': taskCompleted,
      'taskCancelled': taskCancelled,
      'isFavourite': isFavourite,
      // 'steps': steps,
    };
  }

  static DateTime _dateTimeFromJson(String json) =>
      const DateTimeConverter().fromJson(json);

  static String _dateTimeToJson(DateTime object) =>
      const DateTimeConverter().toJson(object);

  String get formattedDateCreated => DateFormat('dd-MM-yyy HH:mm').format(dateCreated.toLocal());
  String get formattedDueDate => DateFormat.yMMMEd().format(dueDate.toLocal());

  Todo copyWith({
    int? id,
    String? task,
    String? description,
    DateTime? dateCreated,
    DateTime? dueDate,
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
      dueDate: dueDate ?? this.dueDate,
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
        dueDate,
        taskCompleted,
        taskCancelled,
        isFavourite,
        steps,
      ];
}
