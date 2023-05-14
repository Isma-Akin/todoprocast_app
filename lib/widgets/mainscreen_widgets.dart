import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoprocast_app/screens/grouped_tasks_screen.dart';
import 'package:todoprocast_app/screens/task_activity_screen.dart';

import '../blocs/todos/todos_bloc.dart';
import '../models/todo_models.dart';
import '../screens/calendar_screen.dart';
import '../screens/favourite_tasks_screen.dart';
import '../screens/task_planner_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';


class TaskPlannerWidget extends StatelessWidget {
  const TaskPlannerWidget({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
              TaskPlanner(todosBloc: context.read<TodosBloc>()),
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
        splashFactory: InkRipple.splashFactory,
        highlightColor: Colors.blue[900],
        splashColor: Colors.blue[900],
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/cloudbackground.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.blue.withOpacity(0.5),
                BlendMode.darken,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(
                  Icons.sticky_note_2_outlined,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Task planner',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class YourDayWidget extends StatelessWidget {
  const YourDayWidget({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
              const CalendarPage(),
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
        highlightColor: Colors.purple,
        splashColor: Colors.purple,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/cloudbackground.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.purple.withOpacity(0.5),
                BlendMode.darken,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Your day',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImportantTasksWidget extends StatelessWidget {
  const ImportantTasksWidget({
    Key? key,
  }) : super(key: key);

@override
Widget build(BuildContext context) {
return Card(
    elevation: 5,
    child: InkWell(
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
   highlightColor: Colors.teal,
   splashColor: Colors.teal,
   child: Container(
   height: 100,
   decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/images/cloudbackground.jpg'),
         fit: BoxFit.cover,
         colorFilter: ColorFilter.mode(
          Colors.green.withOpacity(0.5),
            BlendMode.darken,
         ),
        ),
      ),
      child: Padding(
         padding: const EdgeInsets.all(16.0),
                              child: Row(
                            children: [
                  const Icon(
                      Icons.all_inbox,
                      color: Colors.white,
                      size: 40,
                      ),
                  const SizedBox(width: 16),
                        Expanded(
                        child: Text(
                          'Important Tasks',
                          style: TextStyle(
                          fontSize: 20,
                        color: Colors.white,
                       ),
                    ),
                 ),
                              BlocBuilder<TodosBloc, TodosState>(
                                builder: (context, state) {
                                  int favoriteCount = 0;
                                  if (state is TodosLoaded) {
                                    favoriteCount = state.todos.where((todo) => todo.isFavourite == true).toList().length;
                                  }
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '$favoriteCount',
                                            style: GoogleFonts.openSans(fontSize: 24, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                ],
                ),
             ),
            ),
          ),
          );
      }
    }

class TaskActivityWidget extends StatelessWidget {
  final List<Todo> todos;
  const TaskActivityWidget({Key? key,
    required this.todos}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  TaskActivityScreen(todos: todos),
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
        highlightColor: Colors.pinkAccent,
        splashColor: Colors.pinkAccent,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/cloudbackground.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.pink.withOpacity(0.9),
                BlendMode.darken,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(
                  Icons.airplay,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Task Activity',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImportantTasksWidgetOld extends StatelessWidget {
  const ImportantTasksWidgetOld({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          highlightColor: Colors.teal,
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
                BlocBuilder<TodosBloc, TodosState>(
                  builder: (context, state) {
                    int favoriteCount = 0;
                    if (state is TodosLoaded) {
                      favoriteCount = state.todos.where((todo) => todo.isFavourite == true).toList().length;
                    }
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '$favoriteCount',
                              style: GoogleFonts.openSans(fontSize: 24, color: Colors.teal),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          highlightColor: Colors.limeAccent,
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