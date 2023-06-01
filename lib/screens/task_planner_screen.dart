
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoprocast_app/constants.dart';

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
  final List _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  void _addTodo(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
            child: AddTodoScreen(todosBloc: context.read<TodosBloc>(), isFromFavouritesScreen: false,),
      ),
    ));
  }

  // void _addTodo(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       bool isExpanded = false;
  //       TextEditingController taskController = TextEditingController();
  //       TextEditingController detailsController = TextEditingController();
  //
  //       void _toggleExpansion() {
  //         setState(() {
  //           isExpanded = !isExpanded;
  //         });
  //       }
  //
  //       void _submitTodo() {
  //         // Implement the logic to submit the to-do here
  //       }
  //
  //       return SingleChildScrollView(
  //         child: Container(
  //           padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: TextField(
  //                       controller: taskController,
  //                       decoration: InputDecoration(hintText: 'Enter task'),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 8,
  //                   ),
  //                   ElevatedButton(
  //                     onPressed: _toggleExpansion,
  //                     child: Text('More details'),
  //                   ),
  //                 ],
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //               ),
  //               const Divider(
  //                 thickness: 2,
  //                 color: Colors.grey,
  //               ),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //               ElevatedButton(
  //                 onPressed: _submitTodo,
  //                 child: Text('Add to-do'),
  //               ),
  //               if (isExpanded) ...[
  //                 SizedBox(height: 20),
  //                 TextField(
  //                   controller: detailsController,
  //                   decoration: InputDecoration(
  //                       hintText: 'Enter details',
  //                       border: OutlineInputBorder()),
  //                   minLines: 1,
  //                   maxLines: 5,
  //                 ),
  //                 SizedBox(height: 20),
  //                 ElevatedButton(
  //                   onPressed: _submitTodo,
  //                   child: Text('Add to-do with details'),
  //                 ),
  //               ]
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
    BlocProvider.of<TodosBloc>(context).add(const LoadTodos());
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
          backgroundColor: Colors.blueGrey[50],
          extendBodyBehindAppBar: true,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          onPressed: () {
            _addTodo(context);
          },child: const Icon(Icons.add, size: 30),
            elevation: 4,
        ),
          body: Container(
            // decoration:  const BoxDecoration(
            //   image: DecorationImage(
            //     opacity: 0.4,
            //     image: AssetImage("assets/images/cloudbackground.jpg"),
            //     // image: NetworkImage('https://media.tenor.com/VXwpcfsk17UAAAAd/bubble-abth.gif'),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            child: SafeArea(
              child: CustomScrollView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/cloudbackground.jpg',
                            fit: BoxFit.cover,
                          ),
                          Container(
                            color: Colors.blue.withOpacity(0.6),
                          ),
                        ],
                      )
                    ),
                  backgroundColor: Colors.blue,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.home,
                      color: Colors.blue[900],
                      size: 30,
                    ),
                  ),
                  title:  Center(
                      child: Text('Task planner',
                        style: GoogleFonts.openSans(
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                            // fontStyle: FontStyle.italic,
                            color: Colors.white),)),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.settings,
                          color: Colors.blue[900],
                        size: 30,),
                        onPressed: () {
                          // Code to open settings
                        },
                      ),
                    ],
                    floating: true,
                    snap: true,
                  ),
                  SliverToBoxAdapter(
                    child: BlocBuilder<TodosStatusBloc, TodosStatusState>(
                      builder: (context, state) {
                        print('Current TodosStatusState: $state');
                        if (state is TodosStatusLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is TodosStatusLoaded) {
                          return _todoPending(
                            state.pendingTodos,
                            'Active',
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: BlocBuilder<TodosStatusBloc, TodosStatusState>(
                      builder: (context, state) {
                        if (state is TodosStatusLoaded) {
                          return state.pendingTodos.isEmpty
                              ? Column(
                            children: const [
                              Text(
                                'Add a task by clicking the + button below.',
                                style: TextStyle(
                                  color: AppColors.blueSecondaryColor,
                                  fontSize: 20.2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                              : _todoCompleted(
                            state.completedTodos,
                            'Completed',
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  ],
                ),
            ),
          ),
          // bottomNavigationBar: BottomAppBar(
          //   child: _buildTaskInput(),
          // ),
          ),
        );
  }

  // Widget _buildTaskList() {
  //   return Expanded(
  //     child: Container(
  //       decoration: const BoxDecoration(
  //         color: AppColors.bluePrimaryColor,
  //         borderRadius: BorderRadius.all(Radius.circular(10)
  //         ),
  //       ),
  //       child: ListView.builder(
  //         itemCount: _tasks.length,
  //         itemBuilder: (BuildContext context, int index) {
  //           final task = _tasks[index];
  //           return Card(
  //             child: Container(
  //               decoration: const BoxDecoration(
  //                 image: DecorationImage(
  //                   image: AssetImage("assets/images/cloudbackground.jpg"),
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               child: ListTile(
  //                 trailing: IconButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       _tasks.removeAt(index);
  //                     });
  //                   },
  //                   icon: const Icon(Icons.delete_forever),
  //                 ),
  //                 title: Text(task),
  //                 onTap: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => MiniTaskDetailScreen(
  //                           taskTitle: task),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

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


Column _todoPending(List<Todo> todos, String status) {
  return Column(
    children: [
      SizedBox(
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[100],
            borderRadius: BorderRadius.circular(2),
            // border: const Border.fromBorderSide(
            //   BorderSide(
            //     color: Colors.orange,
            //     width: 2,
            //   ),
            // ),
          ),
          child: Row(
            children: [
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
            ],
          ),
        ),
      ),
      AnimatedContainer(
        height: _isPendingListVisible ? todos.length * 104 : 0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: ListView.builder(
          reverse: true,
          primary: false,
          shrinkWrap: true,
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(
                  bottom: 2.0,
                  left: 3.0,
                  right: 3.0,
                  top: 8.0),
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
            color: Colors.blueGrey[100],
            borderRadius: BorderRadius.circular(2),
            // border: const Border.fromBorderSide(
            //   BorderSide(
            //     color: Colors.orange,
            //     width: 2,
            //   ),
            // ),
          ),
          child: Row(
            children: [
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
          primary: false,
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