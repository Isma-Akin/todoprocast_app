import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/calendar_page.dart';
import '../screens/favourite_tasks_screen.dart';
import '../screens/home_screen.dart';


class TaskList extends StatelessWidget {
  const TaskList({
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
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (context, animation, secondaryAnimation) => const FavouriteTasksScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
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
          child: Container(
              width: screenWidth,
              height: 50,
              color: AppColors.secondaryColor,
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  Icon(Icons.all_inbox, color: Colors.limeAccent,),
                  SizedBox(width: 10,),
                  Text('Task list', style: TextStyle(fontSize: 25),),],)
          ),
        ),
      ],
    );
  }
}

class ImportantTasks extends StatelessWidget {
  const ImportantTasks({
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
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (context, animation, secondaryAnimation) => const FavouriteTasksScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
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
          child: Container(
              width: screenWidth,
              height: 50,
              color: AppColors.secondaryColor,
              margin: EdgeInsets.zero,
              child: Row(
                children: [Icon(Icons.all_inbox, color: Colors.teal,),
                  SizedBox(width: 10,),
                  Text('Important Tasks', style: TextStyle(fontSize: 25),),
                ],)
          ),
        ),
      ],
    );
  }
}

class YourDay extends StatelessWidget {
  const YourDay({
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
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (context, animation, secondaryAnimation) => const CalendarPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
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
          child: Container(
              width: screenWidth,
              height: 50,
              color: AppColors.secondaryColor,
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.purple,),
                  SizedBox(width: 10,),
                  Text('Your Day', style: TextStyle(fontSize: 25),),],)
          ),
        ),
      ],
    );
  }
}

class TaskPlanner extends StatelessWidget {
  const TaskPlanner({
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const HomeScreen(),
              //   ),
              // );
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var begin = Offset(1.0, 0.0);
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
            child: Container(
                width: screenWidth,
                height: 50,
                color: AppColors.secondaryColor,
                margin: EdgeInsets.zero,
                child: Row(
                  children: [
                    Icon(Icons.sticky_note_2, color: Colors.orange,),
                    SizedBox(width: 10,),
                    Text('Task Planner', style: TextStyle(fontSize: 25),),],)
            ),
          ),
        ]
    );
  }
}