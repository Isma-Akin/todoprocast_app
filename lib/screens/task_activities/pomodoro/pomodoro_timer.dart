import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todoprocast_app/blocs/parkinsons_cubit/parkinsonslaw_bloc.dart';
import 'package:todoprocast_app/blocs/pomodoros/pomodoro_bloc.dart';
import 'package:todoprocast_app/screens/task_activities/parkinsons_law/parkinsonslaw_page.dart';
import 'package:uuid/uuid.dart';

import '../../../blocs/parkinsons_cubit/parkinsonslaw_event.dart';
import '../../../blocs/parkinsons_cubit/parkinsonslaw_state.dart';
import '../../../blocs/todos/selected_todos/selected_todo_bloc.dart';
import '../../../blocs/todos/selected_todos/selected_todo_event.dart';
import '../../../blocs/todos/selected_todos/selected_todo_state.dart';
import '../../../blocs/todos/todos_bloc.dart';
import '../../../blocs/todos_status/todos_status_bloc.dart';
import '../../../models/todo_models.dart';
import '../../todo_detail_screen.dart';


class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({Key? key}) : super(key: key);

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}
enum TodoSortCriteria { favourites, dueDate, alphabetically }

class _PomodoroTimerState extends State<PomodoroTimer> {
  PomodoroBloc _pomodoroBloc = PomodoroBloc();
  TodoSortCriteria _sortCriteria = TodoSortCriteria.dueDate;

  late List<Todo>? sortedTodos;

  List<Todo> _sortTodos(List<Todo> todos, TodoSortCriteria sortCriteria) {
    switch (sortCriteria) {
      case TodoSortCriteria.favourites:
        return todos
            .where((todo) => todo.isFavourite ?? false)
            .toList()
          ..sort((a, b) => ((b.isFavourite ?? false) ? 1 : 0) - ((a.isFavourite ?? false) ? 1 : 0));
      case TodoSortCriteria.dueDate:
        return todos..sort((a, b) => (a.dueDate?.compareTo(b.dueDate!) ?? 0));
      case TodoSortCriteria.alphabetically:
      default:
        return todos..sort((a, b) => a.task.compareTo(b.task));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Container(
          child: SafeArea(
            child: Center(
                child: ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.home, size: 30,),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.table_rows_rounded),
                    onPressed: () {
                      // context.read<PomodoroBloc>().add(StopPomodoroEvent());
                    },
                  ),
                  title: Center(
                    child: Text(
                      'Pomodoro Timer',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
            ),),
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/cloudbackground.jpg'),
              colorFilter: ColorFilter.mode(
                Colors.orange.withOpacity(0.7),
                BlendMode.srcATop,
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ) ,
      ),
        body: BlocConsumer<PomodoroBloc, PomodoroState>(
          listener: (context, state) {
            if (state is PomodoroFinished) {
              Fluttertoast.showToast(
                  msg: "Pomodoro Timer Finished!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.orange,
                  textColor: Colors.black,
                  fontSize: 20.0);
            }
          },
          builder: (context, state) {
            if (state is PomodoroInitial) {
              return pomodoroInitial(_pomodoroBloc);
            } else if (state is PomodoroInProgress) {
              return pomodoroInProgress(_pomodoroBloc, context);
            } else if (state is PomodoroPaused) {
              return pomodoroPaused(_pomodoroBloc, context);
            } else if (state is PomodoroFinished) {
              return pomodoroFinished(context, state.todoId);
            } else {
              return Center(
                child: Column(
                  children: const [
                    Text("Something went wrong"),
                    CircularProgressIndicator(),
                  ],
                ),
              ); // loading state
            }
          },
        ));
  }

  Widget pomodoroInitial(PomodoroBloc parkinsonsBloc) {
    return _selectTodoBloc();
  }

  BlocBuilder<TodosStatusBloc, TodosStatusState> _selectTodoBloc() {
    return BlocBuilder<TodosStatusBloc, TodosStatusState>(
      builder: (context, todosState) {
        if (todosState is TodosStatusLoaded) {
          sortedTodos = _sortTodos([...todosState.pendingTodos], _sortCriteria);

          return SingleChildScrollView(
            primary: false,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 5,),
                Container(
                  child: Column(
                    children: [
                      Divider(
                        height: 10,
                        thickness: 2,
                        color: Colors.orange[200],),
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const AssetImage('assets/images/pomodoro.png'),
                            colorFilter: ColorFilter.mode(
                              Colors.orange.withOpacity(0.7),
                              BlendMode.dstATop,
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: const [
                            Text(
                              ' ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 10,
                        thickness: 2,
                        color: Colors.orange[200],),
                      PomodoroInstructionsPanel(),
                      const SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text("Select a todo", style: Theme.of(context).textTheme.headline6?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),),
                            const Spacer(),
                            DropdownButton<TodoSortCriteria>(
                              value: _sortCriteria,
                              items: <TodoSortCriteria>[
                                TodoSortCriteria.favourites,
                                TodoSortCriteria.dueDate,
                                TodoSortCriteria.alphabetically
                              ].map((TodoSortCriteria value) {
                                return DropdownMenuItem<TodoSortCriteria>(
                                  value: value,
                                  child: Text(value.toString().split('.').last),
                                );
                              }).toList(),
                              onChanged: (TodoSortCriteria? value) {
                                setState(() {
                                  _sortCriteria = value!;
                                  sortedTodos = _sortTodos([...todosState.pendingTodos], _sortCriteria);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true, // To let ListView take the minimum required space
                        itemCount: sortedTodos!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: _sortCriteria == TodoSortCriteria.favourites
                                ? const Icon(Icons.star, color: Colors.yellow,)
                                : _sortCriteria == TodoSortCriteria.dueDate
                                ? const Icon(Icons.access_time, color: Colors.blue,)
                                : _sortCriteria == TodoSortCriteria.alphabetically
                                ? const Icon(Icons.sort_by_alpha, color: Colors.deepOrange,)
                                : null,
                            title: Text(sortedTodos![index].task),
                            onLongPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TodoDetailScreen(todo: sortedTodos![index],)));
                            },
                            subtitle: Text("Due date: ${sortedTodos![index].formattedDueDate.toString()}",
                              style: Theme.of(context).textTheme.caption?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),),
                            onTap: () {
                              final todo = sortedTodos![index];
                              const uuid = Uuid();
                              final timerId = uuid.v1();
                              if (todo.dueDate != null) {
                                print('todo has been selected: $todo');
                                print('todo id has been selected: ${todo.id}');
                                context.read<SelectedTodoBloc>().add(SelectTodo(todo));
                                context.read<PomodoroBloc>().add(StartPomodoroEvent(todo));
                                // context.read<PomodoroBloc>().add(StartPomodoroEvent(selectedTodoState.todo!));
                              }
                            },
                            // onTap: () {
                            //   final todo = sortedTodos![index];
                            //   final updatedTodo = todo.copyWith(isParkinson: !todo.isParkinson); // toggle the isParkinson attribute
                            //   context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
                            //   context.read<ParkinsonBloc>().add(StartParkinson(updatedTodo.deadline, updatedTodo)
                            //   );
                            // },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // BlocBuilder<TodosStatusBloc, TodosStatusState> _activeTodoBloc() {
  //   return BlocBuilder<TodosStatusBloc, TodosStatusState>(
  //     builder: (context, todosState) {
  //       if (todosState is TodosStatusLoaded) {
  //         sortedTodos = _sortTodos([...todosState.pendingTodos], _sortCriteria);
  //
  //         return Column(
  //           children: [
  //             const SizedBox(height: 5,),
  //             Container(
  //               child: Column(
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(horizontal: 16),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(16),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey.withOpacity(0.5),
  //                           spreadRadius: 2,
  //                           blurRadius: 4,
  //                           offset: const Offset(0, 3), // changes position of shadow
  //                         ),
  //                       ],
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         Text("Select a todo", style: Theme.of(context).textTheme.headline6?.copyWith(
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.bold),),
  //                         const Spacer(),
  //                         DropdownButton<TodoSortCriteria>(
  //                           value: _sortCriteria,
  //                           items: <TodoSortCriteria>[
  //                             TodoSortCriteria.favourites,
  //                             TodoSortCriteria.dueDate,
  //                             TodoSortCriteria.alphabetically
  //                           ].map((TodoSortCriteria value) {
  //                             return DropdownMenuItem<TodoSortCriteria>(
  //                               value: value,
  //                               child: Text(value.toString().split('.').last),
  //                             );
  //                           }).toList(),
  //                           onChanged: (TodoSortCriteria? value) {
  //                             setState(() {
  //                               _sortCriteria = value!;
  //                               sortedTodos = _sortTodos([...todosState.pendingTodos], _sortCriteria);
  //                             });
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   ListView.builder(
  //                     shrinkWrap: true, // To let ListView take the minimum required space
  //                     itemCount: sortedTodos!.length,
  //                     itemBuilder: (BuildContext context, int index) {
  //                       return ListTile(
  //                         leading: _sortCriteria == TodoSortCriteria.favourites
  //                             ? const Icon(Icons.star)
  //                             : _sortCriteria == TodoSortCriteria.dueDate
  //                             ? const Icon(Icons.access_time)
  //                             : _sortCriteria == TodoSortCriteria.alphabetically
  //                             ? const Icon(Icons.sort_by_alpha)
  //                             : null,
  //                         title: Text(sortedTodos![index].task),
  //                         onLongPress: () {
  //                           Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                   builder: (context) =>
  //                                       TodoDetailScreen(todo: sortedTodos![index],)));
  //                         },
  //                         subtitle: Text(sortedTodos![index].formattedDueDate.toString(),
  //                           style: Theme.of(context).textTheme.caption?.copyWith(
  //                               color: Colors.black,
  //                               fontWeight: FontWeight.bold),),
  //                         onTap: () {
  //                           final todo = sortedTodos![index];
  //                           const uuid = Uuid();
  //                           final timerId = uuid.v1();
  //                           if (todo.dueDate != null) {
  //                             print('todo has been selected: $todo');
  //                             print('todo id has been selected: ${todo.id}');
  //                             context.read<SelectedTodoBloc>().add(SelectTodo(todo));
  //                             context.read<PomodoroBloc>().add(StartPomodoroEvent(todo));
  //                           }
  //                         },
  //                       );
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         );
  //       }
  //       return const Center(child: CircularProgressIndicator());
  //     },
  //   );
  // }

  Widget pomodoroPaused(PomodoroBloc state, BuildContext context) {
    final state = context.watch<PomodoroBloc>().state;
    final selectedTodoState = context.read<SelectedTodoBloc>().state;
    int? selectedTodoId = 0;
    if (selectedTodoState is SelectedTodoState) {
      selectedTodoId = selectedTodoState.todo?.id;
    }

    Duration remainingTime = Duration.zero;
    if (state is PomodoroInProgress && state.todoId == selectedTodoId) {
      remainingTime = state.remainingTime;
    }

    final minutes = remainingTime.inMinutes.remainder(60);
    final seconds = remainingTime.inSeconds.remainder(60);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // _activeTodoBloc(),
            TickingClockAnimation(),
            SizedBox(height: 50,),
            Text(
              '$minutes:${seconds.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.headline1,
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow, size: 30,),
              onPressed: () {
                context.read<PomodoroBloc>().add(ResumePomodoroEvent(selectedTodoId!));
              },
            ),
            IconButton(
              icon: const Icon(Icons.stop, size: 30,),
              onPressed: () {
                context.read<PomodoroBloc>().add(StopPomodoroEvent(selectedTodoId!, selectedTodoState.todo!));
              },
            ),
            IconButton(
              icon: const Icon(Icons.cancel, size: 30,),
              onPressed: () {
                context.read<PomodoroBloc>().add(StopAllPomodorosEvent());
              },
            )
          ],
        ),
      ),
    );
  }

  Widget pomodoroInProgress(PomodoroBloc state, BuildContext context) {
    final state = context.watch<PomodoroBloc>().state;
    final selectedTodoState = context.read<SelectedTodoBloc>().state;
    int? selectedTodoId = 0;
    if (selectedTodoState is SelectedTodoState) {
      selectedTodoId = selectedTodoState.todo?.id;
    }

    Duration remainingTime = Duration.zero;
    if (state is PomodoroInProgress && state.todoId == selectedTodoId) {
      remainingTime = state.remainingTime;
    }

    final minutes = remainingTime.inMinutes.remainder(60);
    final seconds = remainingTime.inSeconds.remainder(60);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // _activeTodoBloc(),
            TickingClockAnimation(),
            const SizedBox(height: 50,),
            Text(
              '$minutes:${seconds.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.headline1,
            ),
            IconButton(
              icon: const Icon(Icons.pause, size: 30,),
              onPressed: () {
                context.read<PomodoroBloc>().add(PausePomodoroEvent(selectedTodoId!));
              },
            ),
            IconButton(
              icon: const Icon(Icons.stop, size: 30,),
              onPressed: () {
                context.read<PomodoroBloc>().add(StopPomodoroEvent(selectedTodoId!, selectedTodoState.todo!));
              },
            ),
            IconButton(
              icon: const Icon(Icons.cancel, size: 30,),
              onPressed: () {
                context.read<PomodoroBloc>().add(StopAllPomodorosEvent());
              },
            )
          ],
        ),
      ),
    );
  }

  // Widget pomodoroInProgressNew(PomodoroBloc state, BuildContext context) {
  //   final selectedTodoState = context.read<SelectedTodoBloc>().state;
  //   int? selectedTodoId = 0;
  //   if (selectedTodoState is SelectedTodoState) {
  //     selectedTodoId = selectedTodoState.todo?.id;
  //   }
  //
  //   Duration remainingTime;
  //   if (state is PomodoroInProgress) {
  //     remainingTime = state.remainingTime;
  //   } else if (state is PomodoroPaused) {
  //     remainingTime = state.remainingTime;
  //   } else {
  //     remainingTime = Duration.zero;
  //   }
  //
  //   return Scaffold(
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           TickingClockAnimation(),
  //           SizedBox(height: 50,),
  //           Text(
  //             '${(remainingTime.inMinutes).floor()}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
  //             style: Theme.of(context).textTheme.headline1,
  //           ),
  //           IconButton(
  //             icon: const Icon(Icons.play_arrow, size: 30,),
  //             onPressed: () {
  //               context.read<PomodoroBloc>().add(ResumePomodoroEvent(selectedTodoId!));
  //             },
  //           ),
  //           IconButton(
  //             icon: const Icon(Icons.pause, size: 30,),
  //             onPressed: () {
  //               context.read<PomodoroBloc>().add(PausePomodoroEvent(selectedTodoId!));
  //             },
  //           ),
  //           IconButton(
  //             icon: const Icon(Icons.stop, size: 30,),
  //             onPressed: () {
  //               context.read<PomodoroBloc>().add(StopPomodoroEvent(selectedTodoId!));
  //             },
  //           ),
  //           IconButton(
  //             icon: const Icon(Icons.cancel, size: 30,),
  //             onPressed: () {
  //               context.read<PomodoroBloc>().add(StopAllPomodorosEvent());
  //             },
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }


  Widget pomodoroFinished(BuildContext context, int todoId) {
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // _selectTodoBloc(),
          Center(
            child: Text("Pomodoro timer for ID: $todoId has finished!",
              style: Theme.of(context).textTheme.headline6,),
          ),
          const SizedBox(height: 50,),
          IconButton(
            onPressed: () {
              context.read<PomodoroBloc>().add(ResetPomodoroEvent(todoId));
            },
            icon: const Icon(
              Icons.replay, size: 30,
            ),
          ),
        ],
      ),
    );
  }

  // Column pomodoroRunning(PomodoroInProgress pomodoroState, BuildContext context) {
  //   final selectedTodoState = context.read<SelectedTodoBloc>().state;
  //   int? selectedTodoId = 0;
  //   if (selectedTodoState is SelectedTodoState) {
  //     selectedTodoId = selectedTodoState.todo?.id;
  //   }
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       BlocBuilder<TodosStatusBloc, TodosStatusState>(
  //         builder: (context, todosState) {
  //           print('Todos state: $todosState');
  //           if (todosState is TodosStatusLoaded) {
  //             print('Pending todos count: ${todosState.pendingTodos.length}');
  //             return Column(
  //               children: [
  //                 DropdownButton(
  //                   items: todosState.pendingTodos.map((Todo todo) {
  //                     return DropdownMenuItem(
  //                       value: todo,
  //                       child: Text(todo.task),
  //                     );
  //                   }).toList(),
  //                   hint: const Text("Select a Todo"),
  //                   onChanged: (Todo? todo) {
  //                     if (todo != null) {
  //                       context.read<SelectedTodoBloc>().add(SelectTodo(todo));
  //                     }
  //                   },
  //                 ),
  //               ],
  //             );
  //           } else {
  //             return const Center(child: CircularProgressIndicator());
  //           }
  //         },
  //       ),
  //       Text(
  //         '${(pomodoroState.secondsRemaining / 60).floor()}:${(pomodoroState.secondsRemaining % 60).toString().padLeft(2, '0')}',
  //         style: Theme.of(context).textTheme.headline1,
  //       ),
  //       const SizedBox(height: 16),
  //       IconButton(
  //         icon: const Icon(Icons.cancel, size: 30,),
  //         onPressed: () {
  //           context.read<PomodoroBloc>().add(PausePomodoroEvent(selectedTodoId!));
  //         },
  //       ),
  //       const SizedBox(height: 16),
  //       IconButton(
  //         icon: const Icon(Icons.cancel, size: 30,),
  //         onPressed: () {
  //           context.read<PomodoroBloc>().add(StopPomodoroEvent(selectedTodoId!));
  //         },
  //       ),
  //       const SizedBox(height: 16),
  //       IconButton(
  //         icon: const Icon(Icons.cancel, size: 30,),
  //         onPressed: () {
  //           context.read<PomodoroBloc>().add(StopAllPomodorosEvent());
  //         },
  //       )
  //     ],
  //   );
  // }

}

class TickingClockAnimation extends StatefulWidget {
  @override
  _TickingClockAnimationState createState() => _TickingClockAnimationState();
}

class _TickingClockAnimationState extends State<TickingClockAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2.0 * 3.1415,
          child: const Icon(Icons.access_time, size: 100, color: Colors.orangeAccent,),
        );
      },
    );
  }
}

class PomodoroInstructionsPanel extends StatefulWidget {
  @override
  _PomodoroInstructionsPanelState createState() => _PomodoroInstructionsPanelState();
}

class _PomodoroInstructionsPanelState extends State<PomodoroInstructionsPanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(
                leading: Icon(Icons.info),
                title: Text('Pomodoro Instructions'),
              );
            },
            body: Column(
              children: const [
                ListTile(
                  title: Text('1. Choose a task you want to work on.'),
                ),
                ListTile(
                  title: Text('2. Set a timer for 25 minutes.'),
                ),
                ListTile(
                  title: Text('3. Work on the task until the timer rings.'),
                ),
              ],
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }
}