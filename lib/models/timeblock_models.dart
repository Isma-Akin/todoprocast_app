import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:time_planner/time_planner.dart';

class TaskModel {
  final String id;
  final String color;
  final int day;
  final int hour;
  final int minutes;
  final int minutesDuration;
  final int daysDuration;
  final String taskName;

  TaskModel({
    required this.id,
    required this.color,
    required this.day,
    required this.hour,
    required this.minutes,
    required this.minutesDuration,
    required this.daysDuration,
    required this.taskName,
  });

  @override
  String toString() {
    return
      'TaskModel{taskName: $taskName, '
      'day: $day, '
      'hour: $hour, '
      'minutes: $minutes, '
      'minutesDuration: $minutesDuration, '
      'id: $id, '
      'daysDuration: $daysDuration, '
      'color: $color}';
  }

  TimePlannerTask toTimePlannerTask() {
    return TimePlannerTask(
      color: colorFromString(color),
      dateTime: TimePlannerDateTime(day: day, hour: hour, minutes: minutes),
      minutesDuration: minutesDuration,
      daysDuration: daysDuration,
      child: Text(
        taskName,
        style: TextStyle(color: Colors.grey[350], fontSize: 12),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'color': color,
      'day': day,
      'hour': hour,
      'minutes': minutes,
      'minutesDuration': minutesDuration,
      'daysDuration': daysDuration,
      'taskName': taskName,
    };
  }

  static TaskModel fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      color: json['color'],
      day: json['day'],
      hour: json['hour'],
      minutes: json['minutes'],
      minutesDuration: json['minutesDuration'],
      daysDuration: json['daysDuration'],
      taskName: json['taskName'],
    );
  }

  static Color colorFromString(String color) {
    // Checks that the color string is long enough and starts with a '#'
    if (color.length < 7 || color[0] != '#') {
      // Return a default color if the string is invalid
      return Colors.grey;
    }

    // Assuming color is in the format "#RRGGBB"
    int colorInt = int.parse(color.substring(1), radix: 16);
    return Color(colorInt).withOpacity(1.0);
  }


}
