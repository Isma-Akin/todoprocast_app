import 'package:flutter/material.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/services/settings.dart';
import 'package:todoprocast_app/widgets/mainscreen_widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // String? selectedTask;
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
            TaskPlanner(screenWidth: screenWidth),
            Divider(height: 4, color: Colors.black,),
            YourDay(screenWidth: screenWidth),
            Divider(height: 4, color: Colors.black,),
            ImportantTasks(screenWidth: screenWidth),
            Divider(height: 4, color: Colors.black,),
            TaskList(screenWidth: screenWidth),
            Divider(height: 10, color: Colors.black,),
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