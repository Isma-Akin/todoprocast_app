import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:time_planner/time_planner.dart';

import '../../blocs/timeblocks/time_block_bloc.dart';
import '../../blocs/timeblocks/time_block_event.dart';
import '../../blocs/timeblocks/time_block_state.dart';
import '../../blocs/todos_status/todos_status_bloc.dart';
import '../../models/timeblock_models.dart';
import '../../models/todo_models.dart';

class TimeBlockingPage extends StatefulWidget {
  const TimeBlockingPage({Key? key}) : super(key: key);

  @override
  _TimeBlockingPageState createState() => _TimeBlockingPageState();
}

class _TimeBlockingPageState extends State<TimeBlockingPage> {
  List<TimePlannerTask> tasks = [];
  Color pickerColor = Colors.blue;
  Todo? selectedTodo;

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
                    id: '1',
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
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.deepPurple.withOpacity(0.2), BlendMode.dstATop),
              image: const AssetImage('assets/images/cloudbackground.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
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
              return const CircularProgressIndicator();
            },
          ),
        ],
        title: Text(selectedTodo?.task ?? "Time blocks"),
        centerTitle: true,
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
                style: GoogleFonts.openSans(fontSize: 26),),
            );
          }
          else {
            return Center(
              child: Text("Welcome to the Time Blocking page!",
                style: GoogleFonts.openSans(fontSize: 26),),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }
}