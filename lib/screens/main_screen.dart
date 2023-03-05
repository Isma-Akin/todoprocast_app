import 'package:flutter/material.dart';
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
          backgroundColor: Colors.blueAccent,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  child: Card(
                      elevation: 10,
                    color: Colors.grey,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text('Task planner'),
                          SizedBox(width: 386,),
                          Icon(Icons.book_online_rounded)
                        ],)
                    )
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
                      MaterialPageRoute(
                        builder: (context) => const CalendarPage(),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [Text('Your day'),
                          SizedBox(width: 412,),
                          Icon(Icons.home)],)
                    )
                  ),
                ),
              ]
            ),
            Row(
              children: [
                InkWell(onTap: (){
                  Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) => const FavouriteTasksScreen()));},
                  child: Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [Text('Important tasks'),
                          SizedBox(width: 366,),
                          Icon(Icons.lightbulb)],)
                    )
                  ),
                ),
              ]
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => const FavouriteTasksScreen()));},
                  child: Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [Text('Task list'),
                          SizedBox(width: 413,),
                          Icon(Icons.lightbulb)],)
                    ),
                  ),
                ),
              ]
            ),
            Divider(height: 50, color: Colors.black,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: screenWidth,
              height: 300,
            )
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