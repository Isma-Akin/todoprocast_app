import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/screens/mini_task_detail_screen.dart';
import 'package:todoprocast_app/services/settings.dart';
import 'package:todoprocast_app/widgets/mainscreen_widgets.dart';

import '../models/todo_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Add a mini task',
                    border: OutlineInputBorder(),
                  ),
                  controller: _taskController,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      final taskName = _taskController.text;
                      setState(() {
                        _tasks.add(taskName);
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Add task'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

// void _showMiniTaskDetailSheet(BuildContext context, Todo todo) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return MiniTaskDetailScreen(todo: todo);
//       },
//     );
//   }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchBar());
              },
              icon: const Icon(Icons.search, color: Colors.black,),
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Settings(),
                      ),
                    );
                  },
                  value: 1,
                  child: const Text('Settings'),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text('Change Theme'),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Text('View Profile'),
                ),
              ],
              onSelected: (value) {
                // Handle menu item selection here
              },
              icon: Icon(Icons.more_vert, color: Colors.black,),
            ),
          ],
          title: Text('Welcome back!', style: GoogleFonts.openSans(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // const SizedBox(height: 10,),
              const Divider(height: 2, color: Colors.black,),
              TaskPlannerWidget(screenWidth: screenWidth),
              const Divider(height: 4, color: Colors.grey,),
              YourDayWidget(screenWidth: screenWidth),
              const Divider(height: 4, color: Colors.grey,),
              ImportantTasksWidget(
                screenWidth: screenWidth,
                favouriteTasks: _favouriteTasks,
              ),
              const Divider(height: 4, color: Colors.grey,),
              TaskListWidget(screenWidth: screenWidth),
              const Divider(height: 4, color: Colors.grey,),
              TaskActivityWidget(screenWidth: screenWidth, todos: const [],),
              const Divider(height: 4, color: Colors.grey,),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.bluePrimaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)

                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _tasks.length,
                          itemBuilder: (BuildContext context, int index) {
                            final task = _tasks[index];
                            return Card(
                              color: AppColors.blueSecondaryColor,
                              child: ListTile(
                                title: Text(task),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MiniTaskDetailScreen(taskTitle: task),
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
                          SizedBox(
                            // width: MediaQuery.of(context).size.width * 0.5,
                            width: screenWidth,
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                _showAddTaskSheet(context);
                              },
                              child: Text('Create Task', style: GoogleFonts.openSans(fontSize: 24),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
    ],
    ),
        ),
    ),
    );
  }
}

class HomeScreenCard extends StatelessWidget {
  const HomeScreenCard({
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