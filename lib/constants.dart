import 'package:flutter/material.dart';

const color = [Colors.blue, Colors.orange, Colors.green, Colors.purple];
final taskdetails = [
  "Your first task",
  "Your second task",
  "Your third task",
  "Your fourth task"
];

final tasks = ["Task 1", "Task 2", "Task 3", "Task 4"];

// style: Theme.of(context).textTheme.bodyText1,

final todotitle = [TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
  TextStyle(fontSize: 15, fontWeight: FontWeight.w200),
  TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
  TextStyle(fontSize: 10, fontWeight: FontWeight.w400),];

final appcolors = [
  Color(0x1A2F64E1),
  Color(0x4C2F64E1),
  Color(0x992F64E1),
];

class AppColors {
  static const Color primaryColor = Color(0x1A2F64E1);
  static const Color secondaryColor = Color(0x4C2F64E1);
  static const Color tertiaryColor = Color(0x992F64E1);
}