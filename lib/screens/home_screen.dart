import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/screens/mini_task_detail_screen.dart';
import 'package:todoprocast_app/services/settings.dart';
import 'package:todoprocast_app/widgets/mainscreen_widgets.dart';

import '../api/todo_repository.dart';
import '../blocs/todos/todos_bloc.dart';
import '../models/todo_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TodoRepository repository;
  late final TodosBloc todosBloc;

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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TodosBloc>(context).add(const LoadTodos());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   flexibleSpace: Container(
        //     decoration: BoxDecoration(
        //       image: DecorationImage(
        //         colorFilter: ColorFilter.mode(Colors.indigo.withOpacity(0.3), BlendMode.dstATop),
        //         image: const AssetImage('assets/images/cloudbackground.jpg'),
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //   ),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   actions: [
        //     IconButton(
        //       onPressed: () {
        //         showSearch(context: context, delegate: SearchBar());
        //       },
        //       icon: const Icon(Icons.search, color: Colors.black,),
        //     ),
        //     PopupMenuButton(
        //       itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        //         PopupMenuItem(
        //           onTap: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => const Settings(),
        //               ),
        //             );
        //           },
        //           value: 1,
        //           child: const Text('Settings'),
        //         ),
        //         const PopupMenuItem(
        //           value: 2,
        //           child: Text('Change Theme'),
        //         ),
        //         const PopupMenuItem(
        //           value: 3,
        //           child: Text('View Profile'),
        //         ),
        //       ],
        //       onSelected: (value) {
        //         // Handle menu item selection here
        //       },
        //       icon: const Icon(Icons.more_vert, color: Colors.black,),
        //     ),
        //   ],
        //   title: Text(
        //     'Welcome back!',
        //     style: GoogleFonts.openSans(
        //         fontSize: 29, fontWeight: FontWeight.bold, color: Colors.black),
        //   ),
        //   centerTitle: true,
        // ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: Container(
            child: SafeArea(
              child: Center(
                  child: ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.search, size: 30,),
                      onPressed: () {
                        showSearch(context: context, delegate: SearchBar());
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
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

                                );
                      },
                    ),
                    title: Center(
                      child: Text(
                        'Welcome!',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
              ),
            ),
            height: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/cloudbackground.jpg'),
                colorFilter: ColorFilter.mode(
                  Colors.grey.withOpacity(0.7),
                  BlendMode.srcATop,
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ) ,
        ),
        body: Column(
          children: [
            SizedBox(height: 10,),
            GridView.count(
              padding: const EdgeInsets.all(1),
              primary: false,
              childAspectRatio: 1.3,
              shrinkWrap: true,
              crossAxisSpacing: 1,
              crossAxisCount: 2,
              children: const [
                TaskPlannerWidget(),
                YourDayWidget(),
                ImportantTasksWidget(),
                TaskActivityWidget(todos: [],),
                // const TaskListWidget(),
              ],
            ),
            _buildTaskList(),
            _buildTaskInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
        color: AppColors.bluePrimaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)
       ),
      ),
      child: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (BuildContext context, int index) {
          final task = _tasks[index];
          return Card(
              child: Container(
              decoration: const BoxDecoration(
              image: DecorationImage(
              image: AssetImage("assets/images/cloudbackground.jpg"),
          fit: BoxFit.cover,
          ),
          ),
            child: ListTile(
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _tasks.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete_forever),
              ),
              title: Text(task),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => MiniTaskDetailScreen(
                      taskTitle: task),
               ),
               );
              },
            ),
          ),
          );
        },
      ),
    ),
    );
  }

  Widget _buildTaskInput() {
    return TextFormField(
      onFieldSubmitted: (value) {
        final taskName = _taskController.text;
        setState(() {
          _tasks.add(taskName);
          _taskController.clear();
        });
      },
      controller: _taskController,
      decoration: const InputDecoration(
        labelText: 'Add a mini task',
        prefixIcon: Icon(Icons.add),
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
