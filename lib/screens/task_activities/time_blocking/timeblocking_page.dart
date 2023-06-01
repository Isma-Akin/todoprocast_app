import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:time_planner/time_planner.dart';
import 'package:uuid/uuid.dart';

import '../../../blocs/timeblocks/time_block_bloc.dart';
import '../../../blocs/timeblocks/time_block_event.dart';
import '../../../blocs/timeblocks/time_block_state.dart';
import '../../../blocs/todos/selected_todos/selected_todo_bloc.dart';
import '../../../blocs/todos/selected_todos/selected_todo_event.dart';
import '../../../blocs/todos_status/todos_status_bloc.dart';
import '../../../models/timeblock_models.dart';
import '../../../models/todo_models.dart';
import '../../todo_detail_screen.dart';
import '../pomodoro/pomodoro_timer.dart';

class TimeBlockingPage extends StatefulWidget {
  const TimeBlockingPage({Key? key}) : super(key: key);

  @override
  _TimeBlockingPageState createState() => _TimeBlockingPageState();
}

class _TimeBlockingPageState extends State<TimeBlockingPage> {
  List<TimePlannerTask> tasks = [];
  Color pickerColor = Colors.blue;
  Todo? selectedTodo;
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

  List<TimePlannerTitle> _generateHeaders() {
    List<TimePlannerTitle> headers = [];
    var now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      var date = now.add(Duration(days: i));
      headers.add(
        TimePlannerTitle(
          date: DateFormat("dd/MM/yyyy").format(date),
          title: DateFormat('EEEE').format(date), // EEEE will give full day name
        ),
      );
    }
    return headers;
  }

  void _showAddTaskDialog(BuildContext context) {
    String taskName = '';
    int day = 0;
    TimeOfDay selectedTime = TimeOfDay.now();
    double duration = 0.0;
    Color pickerColor = const Color(0xff443a49);
    Color currentColor = const Color(0xff443a49);

    void changeColor(Color? color) {
      if (color != null) {
        setState(() => pickerColor = color);
      }
    }

    showDialog<TaskModel>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {

          var uuid = const Uuid();
          String newId = uuid.v4();
          return AlertDialog(
            title: const Text('Add Task'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      taskName = value;
                    },
                    decoration: const InputDecoration(hintText: "Task Name"),
                  ),
                  const SizedBox(height: 10),
                  ColorPicker(
                    pickerColor: pickerColor,
                    onColorChanged: changeColor,
                    pickerAreaHeightPercent: 0.8,
                  ),
                  const SizedBox(height: 10),
                  DropdownButton(
                    value: day,
                    items: const <DropdownMenuItem<int>>[
                      DropdownMenuItem(value: 0, child: Text('Sunday')),
                      DropdownMenuItem(value: 1, child: Text('Monday')),
                      DropdownMenuItem(value: 2, child: Text('Tuesday')),
                      DropdownMenuItem(value: 3, child: Text('Wednesday')),
                      DropdownMenuItem(value: 4, child: Text('Thursday')),
                      DropdownMenuItem(value: 5, child: Text('Friday')),
                      DropdownMenuItem(value: 6, child: Text('Saturday')),
                    ],
                    onChanged: (int? newValue) {
                      setState(() {
                        day = newValue!;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setState(() {
                          selectedTime = picked;
                        });
                      }
                    },
                    child: Text("Select time: ${selectedTime.format(context)}"),
                  ),
                  Slider(
                    value: duration,
                    min: 0.0,
                    max: 120.0, // adjust the max value as needed
                    divisions: 120,
                    label: duration.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        duration = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Confirm Color'),
                onPressed: () {
                  setState(() => currentColor = pickerColor);
                },
              ),
              TextButton(
                child: const Text('Add'),
                onPressed: () {
                  String colorString = '#${currentColor.value.toRadixString(16).substring(2)}';
                  TaskModel taskModel = TaskModel(
                    taskName: taskName,
                    day: day,
                    hour: selectedTime.hour,
                    minutes: selectedTime.minute,
                    minutesDuration: duration.toInt(),
                    id: newId,
                    daysDuration: 1,
                    color: colorString,
                  );
                  Navigator.of(context).pop(taskModel);
                },
              ),
            ],
          );
        });
      },
    ).then((taskModel) {
      if (taskModel != null) {
        context.read<TimeBlocksBloc>().add(
            AddTimeBlock(
                todo: selectedTodo!,
                taskModel: taskModel));
        if (kDebugMode) {
          print('add taskModel: $taskModel');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosStatusBloc, TodosStatusState>(
        builder: (context, todosState) {
          if (todosState is TodosStatusLoaded) {
            sortedTodos = _sortTodos([...todosState.pendingTodos], _sortCriteria);

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
                              // BlocBuilder<TodosStatusBloc, TodosStatusState>(
                              //   builder: (context, state) {
                              //     if (state is TodosStatusLoaded) {
                              //       return DropdownButton(
                              //         value: selectedTodo,
                              //         items: state.pendingTodos.map((Todo todo) {
                              //           return DropdownMenuItem(
                              //             value: todo,
                              //             child: Text(todo.task),
                              //           );
                              //         }).toList(),
                              //         onChanged: (Todo? newValue) {
                              //           setState(() {
                              //             selectedTodo = newValue;
                              //             context.read<TimeBlocksBloc>().add(LoadTimeBlocks(selectedTodo!));
                              //           });
                              //         },
                              //       );
                              //     }
                              //     return Column(
                              //       children: const [
                              //         Center(
                              //             child: CircularProgressIndicator()),
                              //       ],
                              //     );
                              //   },
                              // );
                            },
                          ),
                          title: Center(
                            child: Text(
                              'Time Blocking',
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
                        Colors.cyanAccent.withOpacity(0.7),
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
              body: BlocBuilder<TimeBlocksBloc, TimeBlocksState>(
                builder: (context, state) {
                  if (state is TimeBlocksLoadSuccess) {
                    tasks = state.tasks;
                    return Center(
                      child: TimePlanner(
                        startHour: 6,
                        endHour: 23,
                        style: TimePlannerStyle(
                          // cellHeight: 60,
                          // cellWidth: 60,
                          showScrollBar: true,
                        ),
                        headers: _generateHeaders(),
                        tasks: tasks,
                      ),
                    );
                  }
                  else if (state is TimeBlocksInitial) {
                    return Center(
                      child: Text("Welcome to the Time Blocking page!",
                        style: GoogleFonts.openSans(
                            fontSize: 26),),);
                  }
                  else if (state is TimeBlocksLoadInProgress) {
                    return timeBlockInitial(context, todosState);
                  } else if (state is TimeBlocksLoadFailure) {
                    return Center(
                      child: Text("Something went wrong!",
                        style: GoogleFonts.openSans(
                            fontSize: 26),),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () => _showAddTaskDialog(context),
              //   tooltip: 'Add task',
              //   child: const Icon(Icons.add),
              //     ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  SingleChildScrollView timeBlockInitial(BuildContext context, TodosStatusLoaded todosState) {
    return SingleChildScrollView(
      primary: false,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Divider(
            height: 10,
            thickness: 2,
            color: Colors.tealAccent[200],),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/time_blocking.jpg'),
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
            color: Colors.tealAccent[200],),
          const TimeBlockingInstructionsPanel(),
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
                BlocBuilder<TodosStatusBloc, TodosStatusState>(
                  builder: (context, state) {
                    if (state is TodosStatusLoaded) {
                      return DropdownButton(
                        value: selectedTodo,
                        items: state.pendingTodos.map((Todo todo) {
                          return DropdownMenuItem(
                            value: todo,
                            child: Text(todo.task),
                          );
                        }).toList(),
                        onChanged: (Todo? newValue) {
                          setState(() {
                            selectedTodo = newValue;
                            context.read<TimeBlocksBloc>().add(LoadTimeBlocks(selectedTodo!));
                          });
                        },
                      );
                    }
                    return Column(
                      children: const [
                        Center(
                            child: CircularProgressIndicator()),
                      ],
                    );
                  },
                ),
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
                  final todo = sortedTodos![index];
                  if (todo.dueDate != null) {
                    context.read<SelectedTodoBloc>().add(SelectTodo(todo));
                    _showAddTaskDialog(context);
                  }
                },

              );
            },
          ),
        ],
      ),
    );
  }
}

class TimeBlockingInstructionsPanel extends StatefulWidget {
  const TimeBlockingInstructionsPanel({Key? key}) : super(key: key);

  @override
  _TimeBlockingInstructionsPanelState createState() => _TimeBlockingInstructionsPanelState();
}

class _TimeBlockingInstructionsPanelState extends State<TimeBlockingInstructionsPanel> {
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
                title: Text('Time Blocking instructions'),
              );
            },
            body: Column(
              children: const [
                ListTile(
                  title: Text('1. Divide your day into blocks of time.'),
                ),
                ListTile(
                  title: Text('2. Assign specific tasks to each block.'),
                ),
                ListTile(
                  title: Text('3. Focus on one task at a time.'),
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