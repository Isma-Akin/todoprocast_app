import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoprocast_app/blocs/todos_status/todos_status_bloc.dart';

import '../../../blocs/pomodoros/pomodoro_bloc.dart';
import '../../../blocs/todos/selected_todos/selected_todo_bloc.dart';
import '../../../blocs/todos/selected_todos/selected_todo_event.dart';
import '../../../blocs/todos/selected_todos/selected_todo_state.dart';
import '../../../models/timer_models.dart';
import '../../../models/todo_models.dart';
import '../../todo_detail_screen.dart';
import 'package:uuid/uuid.dart';


class PomodoroTimer extends StatefulWidget {

  const PomodoroTimer({Key? key,}) : super(key: key);

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}
enum TodoSortCriteria { favourites, dueDate, alphabetically }

class _PomodoroTimerState extends State<PomodoroTimer> {
  PomodoroBloc? _pomodoroBloc;
  List<Todo>? sortedTodos;
  Todo? _selectedTodo;
  TodoSortCriteria _sortCriteria = TodoSortCriteria.dueDate;
  bool _isExpanded = false;

  // @override
  // void initState() {
  //   super.initState();
  //   // _pomodoroBloc = context.read<PomodoroBloc>();  // }
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   final selectedTodoState = context.read<SelectedTodoBloc>().state;
  //   if (selectedTodoState is SelectedTodoState) {
  //     _selectedTodo = selectedTodoState.todo;
  //     String? timerId = _pomodoroBloc?.todoTimerMap[_selectedTodo?.id.toString()];
  //     if (timerId != null) {
  //       context.read<PomodoroBloc>().add(LoadPomodoro(timerId: timerId));
  //     }
  //   }
  // }
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      String? todoId = prefs.getString('selectedTodoId');
      if (todoId != null) {
        String? timerId = _pomodoroBloc?.todoTimerMap[todoId];
        if (timerId != null) {
          context.read<PomodoroBloc>().add(LoadPomodoro(timerId: timerId));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _pomodoroBloc = context.read<PomodoroBloc>();    return BlocProvider<SelectedTodoBloc>(
      create: (context) => SelectedTodoBloc(),
      child: BlocBuilder<SelectedTodoBloc, SelectedTodoState>(
        builder: (context, state) {
          return BlocBuilder<PomodoroBloc, PomodoroState>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.navigate_before_rounded,
                        color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  centerTitle: true,
                  title: Text('Pomodoro Timer',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),),
                  flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/cloudbackground.jpg',
                            fit: BoxFit.cover,
                          ),
                          Container(
                            color: Colors.orange[900]?.withOpacity(0.6),
                          ),
                        ],
                      )
                  ),
                ),
                body: const Center(
                  child: PomodoroTimerItem(),
                ),
              );
            },
          );
        },
      ),
    );
    _pomodoroBloc = context.read<PomodoroBloc>();
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
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 2,
        //     blurRadius: 4,
        //     offset: const Offset(0, 3), // changes position of shadow
        //   ),
        // ],
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


class PomodoroTimerItem extends StatefulWidget {
  const PomodoroTimerItem({Key? key}) : super(key: key);

  @override
  State<PomodoroTimerItem> createState() => _PomodoroTimerItemState();
}

class _PomodoroTimerItemState extends State<PomodoroTimerItem> {
  PomodoroBloc? _pomodoroBloc;
  Todo? _selectedTodo;  // Keeps track of the currently selected Todo

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
    _pomodoroBloc = context.read<PomodoroBloc>();    return BlocBuilder<PomodoroBloc, PomodoroState>(
      builder: (context, pomodoroState) {
        if (pomodoroState is PomodoroNotStarted ||
            pomodoroState is PomodoroInitial) {
          return pomodoroBlocBuilder(_pomodoroBloc!);
        } else if (pomodoroState is PomodoroRunning) {
          return pomodoroRunning(pomodoroState, context);
        } else if (pomodoroState is PomodoroPaused) {
          return pomodoroPaused(pomodoroState, context);
        } else if (pomodoroState is Break) {
          return pomodoroBreak(context);
        } else if (pomodoroState is PomodoroCompleted) {
          return pomodoroCompleted(context);
        } else if (pomodoroState is PomodoroStopped) {
          return pomodoroBlocBuilder(_pomodoroBloc!);
        } else {
          return Center(child: Column(
            children: const [
              Text('Loading...'),
              CircularProgressIndicator(),
            ],
          ));
        }
      },
    );
  }

  Column pomodoroCompleted(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<TodosStatusBloc, TodosStatusState>(
          builder: (context, todosState) {
            print('Todos state: $todosState');
            if (todosState is TodosStatusLoaded) {
              print('Pending todos count: ${todosState.pendingTodos.length}');
              return Column(
                children: [
                  DropdownButton(
                    items: todosState.pendingTodos.map((Todo todo) {
                      return DropdownMenuItem(
                        value: todo,
                        child: Text(todo.task),
                      );
                    }).toList(),
                    hint: const Text("Select a Todo"),
                    onChanged: (Todo? todo) {
                      _selectedTodo = todo;
                      String? timerId = _pomodoroBloc?.todoTimerMap[todo?.id];
                      if (timerId != null) {
                        context.read<PomodoroBloc>().add(StartPomodoro(
                            timerId: timerId,
                            todoId: _selectedTodo!.id.toString()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(duration: Duration(seconds: 1),
                            content: Text('Timer not found'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        Text(
          'Pomodoro completed!',
          style: Theme.of(context).textTheme.headline1,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            String? timerId = _pomodoroBloc?.todoTimerMap[_selectedTodo?.id];
            if (timerId != null && _selectedTodo != null) {
              context.read<PomodoroBloc>().add(StartPomodoro(
                  todoId: _selectedTodo!.id.toString(), timerId: timerId));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Timer not found'),
                ),
              );
            }
          },
          child: const Text('Reset'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            String? timerId = _pomodoroBloc?.todoTimerMap[_selectedTodo?.id];
            if (timerId != null) {
              context.read<PomodoroBloc>().add(StopPomodoro(timerId));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Timer not found'),
                ),
              );
            }
          },
          child: const Text('Stop'),
        ),
      ],
    );
  }

  Column pomodoroBreak(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<TodosStatusBloc, TodosStatusState>(
          builder: (context, todosState) {
            print('Todos state: $todosState');
            if (todosState is TodosStatusLoaded) {
              print('Pending todos count: ${todosState.pendingTodos.length}');
              return Column(
                children: [
                  DropdownButton(
                    items: todosState.pendingTodos.map((Todo todo) {
                      return DropdownMenuItem(
                        value: todo,
                        child: Text(todo.task),
                      );
                    }).toList(),
                    hint: const Text("Select a Todo"),
                    onChanged: (Todo? todo) {
                      _selectedTodo = todo;
                      String? timerId = _pomodoroBloc?.todoTimerMap[todo?.id];
                      if (timerId != null) {
                        context.read<PomodoroBloc>().add(StartPomodoro(todoId: _selectedTodo!.id.toString(),timerId: timerId));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Timer not found'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        Text(
          'Take a break!',
          style: Theme.of(context).textTheme.headline1,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            String? timerId = _pomodoroBloc?.todoTimerMap[_selectedTodo?.id];
            if (timerId != null) {
              context.read<PomodoroBloc>().add(ResetPomodoro(timerId));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Timer not found'),
                ),
              );
            }
          },
          child: const Text('Reset'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            String? timerId = _pomodoroBloc?.todoTimerMap[_selectedTodo?.id];
            if (timerId != null) {
              context.read<PomodoroBloc>().add(StopPomodoro(timerId));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Timer not found'),
                ),
              );
            }
          },
          child: const Text('Stop'),
        ),
      ],
    );
  }

  Column pomodoroPaused(PomodoroPaused pomodoroState, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<TodosStatusBloc, TodosStatusState>(
          builder: (context, todosState) {
            print('Todos state: $todosState');
            if (todosState is TodosStatusLoaded) {
              print('Pending todos count: ${todosState.pendingTodos.length}');
              return Column(
                children: [
                  DropdownButton(
                    items: todosState.pendingTodos.map((Todo todo) {
                      return DropdownMenuItem(
                        value: todo,
                        child: Text(todo.task),
                      );
                    }).toList(),
                    hint: const Text("Select a Todo"),
                    onChanged: (Todo? todo) {
                      _selectedTodo = todo;
                      String? timerId = _pomodoroBloc?.todoTimerMap[todo?.id];
                      if (timerId != null) {
                        context.read<PomodoroBloc>().add(StartPomodoro(todoId: _selectedTodo!.id.toString(),timerId: timerId));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Timer not found'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        Text(
          '${(pomodoroState.secondsRemaining / 60).floor()}:${(pomodoroState.secondsRemaining % 60).toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.headline1,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final selectedTodoState = context.read<SelectedTodoBloc>().state;
            if (selectedTodoState is SelectedTodoState) {
              print('Selected Todo Id: ${selectedTodoState.todo?.id}');
              print('Todo Timer Map: ${_pomodoroBloc?.todoTimerMap}');
              String? timerId = _pomodoroBloc?.todoTimerMap[selectedTodoState.todo?.id.toString()];
              if (timerId != null) {
                context.read<PomodoroBloc>().add(ResumePomodoro(timerId: timerId));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Timer not found'),
                  ),
                );
              }
            }
          },
          child: const Text('Resume'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final selectedTodoState = context.read<SelectedTodoBloc>().state;
            if (selectedTodoState is SelectedTodoState) {
              String? timerId = _pomodoroBloc?.todoTimerMap[selectedTodoState.todo?.id.toString()]; //Changes here
              if (timerId != null) {
                context.read<PomodoroBloc>().add(ResetPomodoro(timerId));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Timer not found'),
                  ),
                );
              }
            }
          },
          child: const Text('Reset'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final selectedTodoState = context.read<SelectedTodoBloc>().state;
            if (selectedTodoState is SelectedTodoState) {
              String? timerId = _pomodoroBloc?.todoTimerMap[selectedTodoState.todo?.id.toString()];
              if (timerId != null) {
                context.read<PomodoroBloc>().add(StopPomodoro(timerId));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Timer not found'),
                  ),
                );
              }
            }
          },
          child: const Text('Stop'),
        ),
      ],
    );
  }

  Column pomodoroRunning(PomodoroRunning pomodoroState, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<TodosStatusBloc, TodosStatusState>(
          builder: (context, todosState) {
            print('Todos state: $todosState');
            if (todosState is TodosStatusLoaded) {
              print('Pending todos count: ${todosState.pendingTodos.length}');
              return Column(
                children: [
                  DropdownButton(
                    items: todosState.pendingTodos.map((Todo todo) {
                      return DropdownMenuItem(
                        value: todo,
                        child: Text(todo.task),
                      );
                    }).toList(),
                    hint: const Text("Select a Todo"),
                    // onChanged: (Todo? todo) {
                    //   _selectedTodo = todo;
                    //   String? timerId = _pomodoroBloc?.todoTimerMap[todo?.id];
                    //   if (timerId != null) {
                    //     context.read<PomodoroBloc>().add(StartPomodoro(timerId: timerId));
                    //   } else {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //         content: Text('Timer not found'),
                    //       ),
                    //     );
                    //   }
                    // },
                    onChanged: (Todo? todo) {
                      if (todo != null) {
                        context.read<SelectedTodoBloc>().add(SelectTodo(todo));
                      }
                    },
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        Text(
          '${(pomodoroState.secondsRemaining / 60).floor()}:${(pomodoroState.secondsRemaining % 60).toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.headline1,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final selectedTodoState = context.read<SelectedTodoBloc>().state;
            if (selectedTodoState is SelectedTodoState) {
              print('Selected Todo Id: ${selectedTodoState.todo?.id}');
              print('Todo Timer Map: ${_pomodoroBloc?.todoTimerMap}');
              String? timerId = _pomodoroBloc?.todoTimerMap[selectedTodoState.todo?.id.toString()];
              if (timerId != null) {
                context.read<PomodoroBloc>().add(PausePomodoro(timerId));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Timer not found'),
                  ),
                );
              }
            }
          },
          child: const Text('Pause'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final selectedTodoState = context.read<SelectedTodoBloc>().state;
            if (selectedTodoState is SelectedTodoState) {
              print('Selected Todo Id: ${selectedTodoState.todo?.id}');
              print('Todo Timer Map: ${_pomodoroBloc?.todoTimerMap}');
              String? timerId = _pomodoroBloc?.todoTimerMap[selectedTodoState.todo?.id.toString()];
              if (timerId != null) {
                context.read<PomodoroBloc>().add(ResetPomodoro(timerId));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Timer not found'),
                  ),
                );
              }
            }
          },
          child: const Text('Reset'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final selectedTodoState = context.read<SelectedTodoBloc>().state;
            if (selectedTodoState is SelectedTodoState) {
              print('Selected Todo Id: ${selectedTodoState.todo?.id}');
              print('Todo Timer Map: ${_pomodoroBloc?.todoTimerMap}');
              String? timerId = _pomodoroBloc?.todoTimerMap[selectedTodoState.todo?.id.toString()];
              if (timerId != null) {
                context.read<PomodoroBloc>().add(StopPomodoro(timerId));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Timer not found'),
                  ),
                );
              }
            }
          },
          child: const Text('Stop'),
        ),
      ],
    );
  }

  BlocBuilder<TodosStatusBloc, TodosStatusState> pomodoroBlocBuilder(PomodoroBloc _pomodoroBloc) {
    return BlocBuilder<TodosStatusBloc, TodosStatusState>(
      builder: (context, todosState) {
        if (todosState is TodosStatusLoaded) {
          sortedTodos = _sortTodos([...todosState.pendingTodos], _sortCriteria);

          return Column(
            children: [
              const SizedBox(height: 5,),
              Container(
                child: Column(
                  children: [
                    Divider(
                      height: 10,
                      thickness: 2,
                      color: Colors.orange[900],),
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
                      color: Colors.orange[900],),
                    PomodoroInstructionsPanel(),
                    SizedBox(height: 10,),
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
                      shrinkWrap: true,
                      itemCount: sortedTodos!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: _sortCriteria == TodoSortCriteria.favourites
                              ? const Icon(Icons.star)
                              : _sortCriteria == TodoSortCriteria.dueDate
                              ? const Icon(Icons.access_time)
                              : _sortCriteria == TodoSortCriteria.alphabetically
                              ? const Icon(Icons.sort_by_alpha)
                              : null,
                          title: Text(sortedTodos![index].task),
                          onLongPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TodoDetailScreen(todo: sortedTodos![index],)));
                          },
                          subtitle: Text(sortedTodos![index].formattedDueDate.toString(),
                            style: Theme.of(context).textTheme.caption?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),),
                          onTap: () async {
                            var uuid = const Uuid();
                            String timerId = uuid.v4();
                            String todoId = sortedTodos![index].id.toString();
                            DateTime startTime = DateTime.now();
                            int duration = 25 * 60;
                            TimerModel timer = TimerModel(timerId, todoId, startTime, duration, TimerStatus.running);
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString(timer.id, jsonEncode(timer.toJson()));
                            _pomodoroBloc.todoTimerMap[sortedTodos![index].id.toString()] = timerId;
                            print(_pomodoroBloc.todoTimerMap);
                            context.read<PomodoroBloc>().add(StartPomodoro(todoId: sortedTodos![index].id.toString(), timerId: timerId));
                            context.read<SelectedTodoBloc>().add(SelectTodo(sortedTodos![index]));
                            print(_pomodoroBloc.todoTimerMap);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}