
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

class _TaskPlannerState extends State<TaskPlanner> {
  bool _isCompletedListVisible = true;
  bool _isPendingListVisible = true;

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
            appBar: AppBar(
                backgroundColor: Colors.orange,
              elevation: 0,
              actions: [
                IconButton(onPressed: () {
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
                  );
                },
                  icon: const Icon(Icons.table_rows_rounded, color: AppColors.blueTertiaryColor,)),
              ],
              title: Center(
                child: Text("Task planner",
                style: GoogleFonts.openSans(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: AppColors.blueTertiaryColor,),
              ),
            ),
          body: SafeArea(
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
                        padding: const EdgeInsets.all(8.0),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            _todoPending(
                              state.pendingTodos,
                              'Pending',
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
                ));
          }


Column _todoPending(List<Todo> todos, String status) {
  return Column(
    children: [
      SizedBox(
        height: 50,
        child: Row(
          children: [
            Text(
              '$status Tasks: ${todos.length}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Visibility(
              visible: todos.isNotEmpty,
              child: IconButton(
                  onPressed: () {
                    context.read<TodosBloc>().add(RemoveAllTodos());
                  },
                  icon: const Icon(Icons.delete_forever)),
            ),
            Visibility(
              visible: todos.isNotEmpty,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _isPendingListVisible = !_isPendingListVisible;
                  });
                },
                icon: Icon(_isPendingListVisible ? Icons.visibility : Icons.visibility_off),
              ),
            ),
          ],
        ),
      ),
      if (_isPendingListVisible)
        ListView.builder(
          shrinkWrap: true,
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            return todosCard(
              context,
              todos[index],
            );
          },
        ),
    ],
  );
}

Column _todoCompleted(List<Todo> todos, String status) {
  return Column(
    children: [
      Divider(
        thickness: 2,
        color: Colors.grey,
      ),
      SizedBox(
        height: 50,
        child: Row(
          children: [
            Text(
              '$status Tasks: ${todos.length}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Visibility(
              visible: todos.isNotEmpty,
              child: IconButton(
                onPressed: () {
                  context.read<TodosBloc>().add(RemoveAllTodos());
                },
                icon: const Icon(Icons.delete_forever),
              ),
            ),
            Visibility(
              visible: todos.isNotEmpty,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _isCompletedListVisible = !_isCompletedListVisible;
                  });
                },
                icon: Icon(_isCompletedListVisible ? Icons.visibility : Icons.visibility_off),
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
      if (_isCompletedListVisible)
ListView.builder(
        shrinkWrap: true,
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          return todosCard(
          context,
          todos[index],
         );
        },
     ),

    ],
  );
}
}