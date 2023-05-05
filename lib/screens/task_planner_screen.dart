
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoprocast_app/constants.dart';

import '../services/settings.dart';
import '../widgets/todos_card.dart';
import '/models/models.dart';
import '/blocs/blocs.dart';
import 'add_todo_screen.dart';

class TaskPlanner extends StatefulWidget {
  final TodosBloc todosBloc;
  const TaskPlanner({Key? key, required this.todosBloc}) : super(key: key);
  @override
  State<TaskPlanner> createState() => _TaskPlannerState();
}

class _TaskPlannerState extends State<TaskPlanner> with TickerProviderStateMixin {
  bool _isCompletedListVisible = true;
  bool _isPendingListVisible = true;
  late TabController _tabController;
  void _addTodo(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
            child: AddTodoScreen(todosBloc: context.read<TodosBloc>()),
      ),
    ));
  }

  void _showDeleteAllTodosDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Todo'),
          content: const Text('Are you sure you want to delete every todo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<TodosBloc>().add(RemoveAllTodos());
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Todo app",
        debugShowCheckedModeBanner: false,
        color: appcolors[2],
        home: Scaffold(
          extendBodyBehindAppBar: true,
          floatingActionButton: FloatingActionButton(backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          onPressed: () {
            _addTodo(context);
          },child: const Icon(Icons.add, size: 30),
            elevation: 0.1,
        ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.orangeAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.navigate_before,
                  color: AppColors.blueTertiaryColor,
                ),
              ),
              title:  Center(
                  child: Text('Task planner', style: GoogleFonts.openSans(fontSize: 25, color: Colors.black),)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings,color: AppColors.blueTertiaryColor,),
                    onPressed: () {
                      // Code to open settings
                    },
                  ),
                ],
                floating: true,
                snap: true,
              ),
              SliverToBoxAdapter(
                child: SafeArea(
                  top: true,
                  child: BlocBuilder<TodosStatusBloc, TodosStatusState>(
                    builder: (context, state) {
                      BlocProvider.of<TodosBloc>(context).add(const LoadTodos());
                      print('Current TodosStatusState: $state');
                      if (state is TodosStatusLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is TodosStatusLoaded) {
                        return CustomScrollView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.all(1.0),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate([
                                  _todoPending(
                                    state.pendingTodos,
                                    'Active',
                                  ),
                                  if (state.pendingTodos.isEmpty)
                                    Column(
                                      children: const [
                                        Text('You have no pending tasks.',
                                          style: TextStyle(
                                              color: AppColors.blueSecondaryColor,
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),),
                                        SizedBox(height: 20,),
                                        Text('Add a task by clicking the + button below.',
                                          style: TextStyle(
                                              color: AppColors.blueSecondaryColor,
                                              fontSize: 20.2,
                                              fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  _todoCompleted(
                                    state.completedTodos,
                                    'Completed',
                                  ),
                                  // if (state.completedTodos.isEmpty)
                                  //  const Text('You have no completed tasks.',
                                  //     style: TextStyle(
                                  //     color: AppColors.blueSecondaryColor,
                                  //     fontSize: 27,
                                  //     fontWeight: FontWeight.bold),),
                                ]),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Text('Something went wrong.');
                      }
                    },
                  ),
                ),
              ),
              ],
            ),
          ),
        );
  }


Column _todoPending(List<Todo> todos, String status) {
  return Column(
    children: [
      SizedBox(
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '$status Tasks: ${todos.length}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Visibility(
                visible: todos.isNotEmpty,
                child: IconButton(
                    onPressed: () {
                      _showDeleteAllTodosDialog(context);
                    },
                    icon: const Icon(Icons.delete_forever, color: Colors.grey,)),
              ),
              Visibility(
                visible: todos.isNotEmpty,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPendingListVisible = !_isPendingListVisible;
                    });
                  },
                  icon: Icon(_isPendingListVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey,),
                ),
              ),
            ],
          ),
        ),
      ),
      // if (_isPendingListVisible)
      //   ListView.builder(
      //     shrinkWrap: true,
      //     itemCount: todos.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return todosCard(
      //         context,
      //         todos[index],
      //       );
      //     },
      //   ),
      AnimatedContainer(
        height: _isPendingListVisible ? todos.length * 104 : 0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 2.0, left: 3.0, right: 3.0, top: 8.0),
              child: todosCard(
                context, todos[index],
              ),
            );
          },
        ),
      ),
    ],
  );
}

Column _todoCompleted(List<Todo> todos, String status) {
  return Column(
    children: [
      const Divider(
        thickness: 2,
        color: Colors.grey,
      ),
      SizedBox(
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '$status Tasks: ${todos.length}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Visibility(
                visible: todos.isNotEmpty,
                child: IconButton(
                    onPressed: () {
                      _showDeleteAllTodosDialog(context);
                    },
                    icon: const Icon(Icons.delete_forever, color: Colors.grey,)),
              ),
              Visibility(
                visible: todos.isNotEmpty,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isCompletedListVisible = !_isCompletedListVisible;
                    });
                  },
                  icon: Icon(_isCompletedListVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey,),
                ),
              ),
              // IconButton(
              //   onPressed: () {
              //     setState(() {
              //       _isListVisible = !_isListVisible;
              //     });
              //   },
              //   icon: Icon(_isListVisible ? Icons.visibility : Icons.visibility_off),
              // ),
            ],
          ),
        ),
      ),
      AnimatedContainer(
        height: _isCompletedListVisible ? todos.length * 104 : 0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 2.0, left: 3.0, right: 3.0, top: 8.0),
              child: todosCard(
                context, todos[index],
         ),
            );
        },
      ),
     ),
    ],
  );
}
}