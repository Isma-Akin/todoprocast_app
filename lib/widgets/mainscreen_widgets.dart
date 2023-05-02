import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoprocast_app/screens/grouped_tasks_screen.dart';
import 'package:todoprocast_app/screens/task_activity_screen.dart';

import '../blocs/todos/todos_bloc.dart';
import '../constants.dart';
import '../models/todo_models.dart';
import '../screens/calendar_screen.dart';
import '../screens/favourite_tasks_screen.dart';
import '../screens/task_planner_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';


class TaskPlannerWidget extends StatelessWidget {
  const TaskPlannerWidget({
    Key? key,
    required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) => TaskPlanner(todosBloc: context.read<TodosBloc>()),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(1.0, 0.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            splashColor: Colors.orange,
            child: Container(
                width: screenWidth,
                height: 50,
                margin: EdgeInsets.zero,
                child: Row(
                  children:  [
                    const SizedBox(width: 10,),
                    const Icon(Icons.sticky_note_2, color: Colors.orange,),
                    const SizedBox(width: 10,),
                    Text('Task Planner', style: GoogleFonts.openSans(fontSize: 24)),],)
            ),
          ),
        ]
    );
  }
}

class YourDayWidget extends StatelessWidget {
  const YourDayWidget({
    Key? key,
    required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (context, animation, secondaryAnimation) => const CalendarPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );},
          splashColor: Colors.purple,
          child: Container(
              width: screenWidth,
              height: 50,
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  const SizedBox(width: 10,),
                  const Icon(Icons.calendar_today, color: Colors.purple,),
                  const SizedBox(width: 10,),
                  Text('Your Day', style: GoogleFonts.openSans(fontSize: 24),),],)
          ),
        ),
      ],
    );
  }
}

class ImportantTasksWidget extends StatelessWidget {
  const ImportantTasksWidget({
    Key? key,
    required this.screenWidth,
    required this.favouriteTasks,
  }) : super(key: key);

  final double screenWidth;
  final List<Todo> favouriteTasks;

  int getNumFavouriteTasks(List<Todo> todos) {
    return todos.where((todo) => todo.isFavourite ?? false).length;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (context, animation, secondaryAnimation) =>
                const FavouriteTasksScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
          splashColor: Colors.teal,
          child: Container(
            width: screenWidth,
            height: 50,
            margin: EdgeInsets.zero,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.all_inbox,
                  color: Colors.teal,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Important Tasks',
                  style: GoogleFonts.openSans(fontSize: 24),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${getNumFavouriteTasks(favouriteTasks)}',
                          style: GoogleFonts.openSans(fontSize: 24, color: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    Key? key,
    required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (context, animation, secondaryAnimation) => const GroupedTasksScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );},
          splashColor: Colors.limeAccent,
          child: Container(
              width: screenWidth,
              height: 50,
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  const SizedBox(width: 10,),
                  const Icon(Icons.all_inbox, color: Colors.limeAccent,),
                  const SizedBox(width: 10,),
                  Text('Grouped Tasks', style: GoogleFonts.openSans(fontSize: 24),),],)
          ),
        ),
      ],
    );
  }
}

class TaskActivityWidget extends StatelessWidget {
  final List<Todo> todos;
  const TaskActivityWidget({Key? key,
    required this.screenWidth,
    required this.todos}) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (context, animation, secondaryAnimation) => TaskActivityScreen(todos: todos,),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );},
          splashColor: Colors.pinkAccent,
          child: Container(
              width: screenWidth,
              height: 50,
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  const SizedBox(width: 10,),
                  const Icon(Icons.airplay, color: Colors.pinkAccent,),
                  const SizedBox(width: 10,),
                  Text('Task Activity', style: GoogleFonts.openSans(fontSize: 24),),],)
          ),
        ),
      ],
    );
  }
}
