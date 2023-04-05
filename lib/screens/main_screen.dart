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
              icon: const Icon(Icons.settings))],
          title: const Text('Main Screen'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20,),
            TaskPlanner(screenWidth: screenWidth),
            const Divider(height: 4, color: Colors.grey,),
            YourDay(screenWidth: screenWidth),
            const Divider(height: 4, color: Colors.grey,),
            ImportantTasks(screenWidth: screenWidth),
            const Divider(height: 4, color: Colors.grey,),
            TaskList(screenWidth: screenWidth),
            const Divider(height: 10, color: Colors.grey,),
            SizedBox(
              height: 100,
              child: SizedBox(
                width: 700,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) => const Card(
                    child: Center(child: Text('Dummy Card Text')),
                  ),
                ),
              ),
            ),
    ],
    ),
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