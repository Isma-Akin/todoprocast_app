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
        splashColor: Colors.blue[900],
        child: Ink(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/cloudbackground.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.blue.withOpacity(0.5),
                BlendMode.darken,
              ),
            ),
          ),
          child: Container(
          height: 100,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 25),
                const Icon(
                  Icons.sticky_note_2_outlined,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Task planner',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
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
        splashColor: Colors.purple,
        child: Ink(
         decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/cloudbackground.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.purple.withOpacity(0.5),
                BlendMode.darken,
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 25),
                const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Your day',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
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
   splashColor: Colors.teal,
   child: Ink(
   decoration: BoxDecoration(
        image: DecorationImage(
        image: const AssetImage('assets/images/cloudbackground.jpg'),
         fit: BoxFit.cover,
         colorFilter: ColorFilter.mode(
          Colors.green.withOpacity(0.5),
            BlendMode.darken,
         ),
        ),
      ),
     child: Container(
     height: 100,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 25),
                const Icon(
                  Icons.all_inbox,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Important Tasks',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlocBuilder<TodosBloc, TodosState>(
                      builder: (context, state) {
                        int favoriteCount = 0;
                        if (state is TodosLoaded) {
                          favoriteCount = state.todos
                              .where((todo) => todo.isFavourite == true)
                              .toList()
                              .length;
                        }
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '$favoriteCount',
                                  style: Theme.of(context).textTheme.headline6?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
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
        splashColor: Colors.pinkAccent,
        child: Ink(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/cloudbackground.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.pink.withOpacity(0.9),
                BlendMode.darken,
              ),
            ),
          ),
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 25),
                const Icon(
                  Icons.airplay,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Task Activity',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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