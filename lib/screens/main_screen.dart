import 'package:flutter/material.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/screens/add_todo.dart';
import 'package:todoprocast_app/screens/add_todo_screen.dart';
import 'package:todoprocast_app/screens/calendar_page.dart';
import 'package:todoprocast_app/screens/favourite_tasks_screen.dart';
import 'package:todoprocast_app/screens/home_screen.dart';
import 'package:todoprocast_app/services/settings.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String? selectedTask;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.tertiaryColor,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchBar());
              },
              icon: const Icon(Icons.search),
            ),
          IconButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Settings(),
              ),
            );
          },
              icon: Icon(Icons.settings))],
          title: const Text('Main Screen'),
        ),
        body: Column(
          children: [
            SizedBox(height: 20,),
            Row(
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
                    padding: const EdgeInsets.all(4.0),
                    width: screenWidth,
                    child: Card(shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                      margin: EdgeInsets.only(left: 1, right: 1),
                      color: AppColors.secondaryColor,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: screenWidth - 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Task planner', style: TextStyle(fontSize: 25),),
                              // SizedBox(width: MediaQuery.of(context).size.width - 80,),
                              Icon(Icons.book_online_rounded, color: Colors.lightGreen,)
                            ],),
                        )
                      )
                    ),
                  ),
                ),
              ]
            ),
            Row(
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
                    );
                  },
                  child: Container(
                    width: screenWidth,
                    padding: const EdgeInsets.all(4.0),
                    child: Card(shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                        margin: EdgeInsets.only(left: 1, right: 1),
                      color: AppColors.secondaryColor,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('Your day', style: TextStyle(fontSize: 25),),
                            // SizedBox(width: 412,),
                            Icon(Icons.home, color: Colors.greenAccent,)],)
                      )
                    ),
                  ),
                ),
              ]
            ),
            Row(
              children: [
                InkWell(onTap: (){
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
                    padding: const EdgeInsets.all(4.0),
                    child: Card(shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                      margin: EdgeInsets.only(left: 1, right: 1),
                      color: AppColors.secondaryColor,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('Important tasks', style: TextStyle(fontSize: 25),),
                            // SizedBox(width: 366,),
                            Icon(Icons.lightbulb, color: Colors.teal,)],)
                      )
                    ),
                  ),
                ),
              ]
            ),
            Row(
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
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                      margin: EdgeInsets.only(left: 1, right: 1),
                      color: AppColors.secondaryColor,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('Task list', style: TextStyle(fontSize: 25),),
                            // SizedBox(width: 413,),
                            Icon(Icons.all_inbox, color: Colors.limeAccent,)],)
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 50, color: Colors.black,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: screenWidth,
              height: 300,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Catch up with tasks!', style: TextStyle(fontSize: 25),),
                      ),
                    ],
                  ),
                  Divider(height: 10, color: Colors.black,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Task 1', style: TextStyle(fontSize: 20),),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Task 2', style: TextStyle(fontSize: 20),),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Task 3', style: TextStyle(fontSize: 20),),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Task 4', style: TextStyle(fontSize: 20),),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Task 5', style: TextStyle(fontSize: 20),),
                      ),
                    ],
                  ),
                ],
              )
            ),
          ],
        )
      ),
    );
  }
}

class SearchBar extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}