import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/screens/pomodoro_screen.dart';
import 'package:todoprocast_app/screens/todo_detail_screen.dart';

import '../blocs/todos/todos_bloc.dart';
import '../blocs/todos_status/todos_status_bloc.dart';
import '../models/todo_models.dart';
import '../widgets/todos_card.dart';
import 'package:todoprocast_app/blocs/todos/todos_bloc.dart';

class TaskActivityScreen extends StatefulWidget {
  final List<Todo> todos;
  const TaskActivityScreen({Key? key, required this.todos}) : super(key: key);

  @override
  _TaskActivityScreenState createState() => _TaskActivityScreenState();
}

class _TaskActivityScreenState extends State<TaskActivityScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // void _showTodoList(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return BlocBuilder<TodosBloc, TodosState>(
  //         builder: (context, state) {
  //           if (state is TodosLoaded) {
  //             return SimpleDialog(
  //               title: const Text('Select a todo'),
  //               children: [
  //                 Container(
  //                   height: 300,
  //                   width: 300,
  //                   child: ListView.builder(
  //                     itemCount: state.todos.length,
  //                     itemBuilder: (context, index) {
  //                       return ListTile(
  //                         title: Text(state.todos[index].task),
  //                         onTap: () {
  //                           // Apply the time management method to the selected todo
  //                         },
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             );
  //           } else {
  //             return const CircularProgressIndicator();
  //           }
  //         },
  //       );
  //     },
  //   );
  // }

  void _showTodoList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<TodosBloc, TodosState>(
          builder: (context, state) {
            if (state is TodosLoaded) {
              return SimpleDialog(
                title: const Text('Select a todo'),
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    child: ListView.builder(
                      itemCount: state.todos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.todos[index].task),
                          onTap: () {
                            // Apply the time management method to the selected todo
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return state is TodosInitial
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink();
            }
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Task Activity Screen'),
          backgroundColor: AppColors.tertiaryColor,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
        ),
        body: BlocBuilder<TodosStatusBloc, TodosStatusState>(
          builder: (context, state) {
            return Column(
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeIn,
                  )),
                  child: Container(
                    child: const Text('Please select a task activity',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  scrollDirection: Axis.vertical,
                  primary: false,
                  shrinkWrap: true,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showTodoList(context);
                      },
                      child: Card(
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/pomodoro.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Text("Pomodoro"),
                        ),
                      ),
                    ), InkWell(
                      onTap: () {},
                      child: Card(
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/time_blocking.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Text("Time blocking"),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Card(
                        child: Text("Monkey method"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                BlocBuilder<TodosStatusBloc, TodosStatusState>(
                  builder: (context, state) {
                    print('Current TodosStatusState: $state');
                    if (state is TodosStatusLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is TodosStatusLoaded) {
                      return Expanded(
                          child: ListView(
                              children: [
                                _todo(
                                  state.pendingTodos,
                                  ' ',
                                )
                              ]
                          )
                      );
                    } else {
                      return const Text('Something went wrong.');
                    }
                  },
                ),

              ],
            );
          },
        ),
      ),
    );
  }


  Column _todo(List<Todo> todos, String status) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Text(
                '$status Available Tasks: ${todos.length}',
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
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            return _todosCard(
              context,
              todos[index],
            );
          },
        ),
      ],
    );
  }

  InkWell _todosCard(BuildContext context,
      Todo todo,) {
    return InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoDetailScreen(todo: todo),
          ),
        );
      },
      child: Card(
        color: todo.taskCompleted == true ? Colors.orange : AppColors
            .secondaryColor,
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${todo.id}: ${todo.task}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              Text('Due date: ${todo.formattedDueDate}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              BlocBuilder<TodosBloc, TodosState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<TodosBloc>().add(
                              MarkTodoAsFavOrUnFav(todo: todo));
                        },
                        icon: Icon(
                            todo.isFavourite! ? Icons.star : Icons.star_border),
                        color: Colors.yellow,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: IconButton(
                          onPressed: () {
                            final isCompleted = todo.taskCompleted ?? false;
                            final updatedTodo = todo.copyWith(
                                taskCompleted: !isCompleted);
                            context.read<TodosBloc>().add(
                              UpdateTodo(todo: updatedTodo),
                            );
                          },
                          icon: Icon(todo.taskCompleted ?? false
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<TodosBloc>().add(
                            RemoveTodo(
                              todo: todo.copyWith(taskCancelled: true),
                            ),
                          );
                        },
                        icon: const Icon(Icons.cancel),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


