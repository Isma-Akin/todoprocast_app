import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../api/custom_serializer.dart';
import 'group_models.dart';


class Todo extends Equatable {
  late int id;
  final String task;
  final String description;
  final Group? group;
  final DateTime dateCreated;
  final DateTime? dueDate;
  final DateTime deadline;
  Duration timer;
  late bool isImportant;
  late bool isUrgent;
  late bool isFrog;
  late bool isParkinson;
  late bool isEisenhower;
  late bool isPomodoro;
  late bool isTimeBlock;
  late bool isPareto;
  bool? taskCompleted;
  bool? taskCancelled;
  bool? isFavourite;
  bool isSynced;
  bool isTempId;
  bool isApplied;
  bool isSelected;
  String groupId;
  List<String> steps;
  List<String> taskActivity;
  // final List<TimeBlock> timeBlocks;

  Todo({
    required this.id,
    // this.pomodoros = 0,
    required this.task,
    required this.deadline,
    this.timer = const Duration(seconds: 0),
    this.isImportant = false,
    this.isUrgent = false,
    this.isFrog = false,
    this.isParkinson = false,
    this.isEisenhower = false,
    this.isPomodoro = false,
    this.isTimeBlock = false,
    this.isPareto = false,
    required this.description,
    this.group,
    required this.dateCreated,
    this.dueDate,
    this.taskCompleted,
    this.taskCancelled,
    this.isFavourite,
    this.isSynced = false,
    this.isTempId = false,
    this.isApplied = false,
    this.isSelected = false,
    this.groupId = '',
    this.steps = const <String>[],
    this.taskActivity = const <String>[],
    // this.timeBlocks = const <TimeBlock>[],
  }) {
    taskCompleted = taskCompleted ?? false;
    taskCancelled = taskCancelled ?? false;
    isFavourite = isFavourite ?? false;
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      task: json['task'],
      deadline: _dateTimeFromJson(json['deadline']),
      timer: Duration(seconds: json['timer']),
      isImportant: json['isImportant'],
      isUrgent: json['isUrgent'],
      isFrog: json['isFrog'],
      isParkinson: json['isParkinson'],
      isEisenhower: json['isEisenhower'],
      isPomodoro: json['isPomodoro'],
      isTimeBlock: json['isTimeBlock'],
      isPareto: json['isPareto'],
      description: json['description'],
      group: json['group'] != null ? Group.fromJson(json['group']) : null,
      dateCreated: _dateTimeFromJson(json['dateCreated']),
      dueDate: _dateTimeFromJson(json['dueDate']),
      // timer: Duration(seconds: json['timer']),
      taskCompleted: json['taskCompleted'],
      taskCancelled: json['taskCancelled'],
      isFavourite: json['isFavourite'],
      steps: json['steps'] != null ? List<String>.from(json['steps']) : [],
      taskActivity: json['taskActivity'] != null ? List<String>.from(json['taskActivity']) : [],
      // taskActivity: json['taskActivity'],
      // taskActivity: 'No task activity applied',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task': task,
      'deadline': _dateTimeToJson(deadline),
      'timer': timer.inSeconds,
      'isImportant': isImportant,
      'isUrgent': isUrgent,
      'isFrog': isFrog,
      'isParkinson': isParkinson,
      'isEisenhower': isEisenhower,
      'isPomodoro': isPomodoro,
      'isTimeBlock': isTimeBlock,
      'isPareto': isPareto,
      'description': description,
      'group': group != null ? group!.toJson() : null,
      'dateCreated': _dateTimeToJson(dateCreated),
      'dueDate': _dateTimeToJson(dueDate!),
      'taskCompleted': taskCompleted,
      'taskCancelled': taskCancelled,
      'isFavourite': isFavourite,
      'steps': steps,
      'taskActivity': taskActivity,
    };
  }

  Todo copyWith({
    int? id,
    String? task,
    String? description,
    DateTime? dateCreated,
    DateTime? dueDate,
    bool? isFrog,
    bool? isImportant,
    bool? isUrgent,
    bool? isParkinson,
    bool? isEisenhower,
    bool? isPomodoro,
    bool? isTimeBlock,
    bool? isPareto,
    bool? taskCompleted,
    bool? taskCancelled,
    Group? group,
    bool? isFavourite,
    bool? isSynced,
    bool? isTempId,
    bool isSelected = false,
    List<String>? steps,
    // List<TimeBlock> timeBlocks = const <TimeBlock>[],
    String? groupId,
    List<String>? taskActivity,
  }) {
    return Todo(
      id: id ?? this.id,
      task: task ?? this.task,
      deadline: deadline,
      timer: timer,
      description: description ?? this.description,
      group: group,
      dateCreated: dateCreated ?? this.dateCreated,
      dueDate: dueDate ?? this.dueDate,
      isFrog: isFrog ?? this.isFrog,
      taskCompleted: taskCompleted ?? this.taskCompleted,
      taskCancelled: taskCancelled ?? this.taskCancelled,
      isFavourite: isFavourite ?? this.isFavourite,
      isSynced: isSynced ?? this.isSynced,
      isTempId: isTempId ?? this.isTempId,
      isApplied: isApplied,
      groupId: groupId ?? this.groupId,
      steps: steps ?? this.steps,
      taskActivity: taskActivity ?? this.taskActivity,
      // timeBlocks: timeBlocks,
    );
  }

  static Todo decode(String todoJson) {
    Map<String, dynamic> jsonMap = jsonDecode(todoJson);
    return Todo.fromJson(jsonMap);
  }

  static String encode(Todo todo) {
    String jsonString = jsonEncode(todo.toJson());
    return jsonString;
  }

  static DateTime _dateTimeFromJson(String json) =>
      const DateTimeConverter().fromJson(json);

  static String _dateTimeToJson(DateTime object) =>
      const DateTimeConverter().toJson(object);

  String get formattedDateCreated => DateFormat('dd-MM-yyy HH:mm').format(dateCreated.toLocal());
  // String get formattedDueDate => DateFormat.yMMMEd().format(dueDate?.toLocal());
  String get formattedDueDate =>
      dueDate != null ? DateFormat.yMMMEd().format(dueDate!.toLocal()) : '';

  // void applyPomodoro() {
  //   taskActivity = 'pomodoro applied';
  // }

  // set id(int newId) {
  //   id = newId;
  // }

  // void updateTaskActivity(String activityName) {
  //   taskActivity = activityName as List<String>;
  // }

  void updateTaskActivity(String activityName) {
    taskActivity.add(activityName);
  }
  void removeTaskActivity(String activityName) {
    taskActivity.remove(activityName);
  }

  void setFrog(bool newValue) {
    isFrog = newValue;
  }

  void setParkinson(bool newValue) {
    isParkinson = newValue;
  }

  void setEisenhower(bool newValue) {
    isEisenhower = newValue;
  }

  void setPomodoro(bool newValue) {
    isPomodoro = newValue;
  }

  void setTimeBlock(bool newValue) {
    isTimeBlock = newValue;
  }

  void setPareto(bool newValue) {
    isPareto = newValue;
  }

  List<String> getTaskActivities() {
    List<String> activities = [];
    if (isFrog) {
      activities.add('Eat that Frog');
    }
    if (isParkinson) {
      activities.add('Parkinsons Law');
    }
    if (isEisenhower) {
      activities.add('Eisenhower Matrix');
    }
    if (isPomodoro) {
      activities.add('Pomodoro');
    }
    if (isTimeBlock) {
      activities.add('Time Block');
    }
    if (isPareto) {
      activities.add('Pareto Analysis');
    }
    return activities;
  }

  @override
  List<Object?> get props => [
        id,
        task,
        description,
        dateCreated,
        dueDate,
        deadline,
        isFrog,
        group,
        timer,
        isImportant,
        isUrgent,
        taskCompleted,
        taskCancelled,
        isFavourite,
        isSynced,
        isTempId,
        isApplied,
        steps,
        groupId,
        taskActivity,
      ];

  Todo copy() {
    return Todo(
      id: id,
      task: task,
      deadline: deadline,
      timer: timer,
      isImportant: isImportant,
      isUrgent: isUrgent,
      description: description,
      group: group,
      dateCreated: dateCreated,
      dueDate: dueDate,
      taskCompleted: taskCompleted,
      taskCancelled: taskCancelled,
      isFavourite: isFavourite,
      isSynced: isSynced,
      isTempId: isTempId,
      isApplied: isApplied,
      steps: steps,
      taskActivity: taskActivity,
      groupId: groupId,
    );
  }
}