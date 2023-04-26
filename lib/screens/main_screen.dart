import 'package:flutter/material.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/screens/mini_task_detail_screen.dart';
import 'package:todoprocast_app/services/settings.dart';
import 'package:todoprocast_app/widgets/mainscreen_widgets.dart';

import '../models/todo_models.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final List<Todo> _task = [];
  final List _tasks = [];
  final List<Todo> _favouriteTasks = [];

  final TextEditingController _taskController = TextEditingController();


  void _showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Task',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Task Name',
                    border: OutlineInputBorder(),
                  ),
                  controller: _taskController,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final taskName = _taskController.text;
                    setState(() {
                      _tasks.add(taskName);
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Add Task'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

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
            PopupMenuButton(
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  value: 1,
                  child: Text('Settings'),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('Change Theme'),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text('View Profile'),
                ),
              ],
              onSelected: (value) {
                // Handle menu item selection here
              },
              icon: Icon(Icons.more_vert),
            ),
          ],
          title: const Text('Main Screen'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20,),
            TaskPlanner(screenWidth: screenWidth),
            const Divider(height: 4, color: Colors.grey,),
            YourDay(screenWidth: screenWidth),
            const Divider(height: 4, color: Colors.grey,),
            ImportantTasks(screenWidth: screenWidth, favouriteTasks: _favouriteTasks,),
            const Divider(height: 4, color: Colors.grey,),
            TaskList(screenWidth: screenWidth),
            const Divider(height: 4, color: Colors.grey,),
            TaskActivity(screenWidth: screenWidth),
            const Divider(height: 4, color: Colors.grey,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        final task = _tasks[index];
                        return Card(
                          child: ListTile(
                            title: Text(task),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MiniTaskDetailScreen(task: task),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: screenWidth,
                        color: AppColors.tertiaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _showAddTaskSheet(context);
                            },
                            child: Text('Create Task'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    ],
    ),
    ),
    );
  }
}

class MainScreenCard extends StatelessWidget {
  const MainScreenCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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