import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoprocast_app/models/todo_models.dart';
import 'package:todoprocast_app/models/timeblock_models.dart';
import 'package:time_planner/time_planner.dart';

import '../../blocs/todos/todos_bloc.dart';


class TimeBlockingPage extends StatefulWidget {
  const TimeBlockingPage({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  @override
  _TimeBlockingPageState createState() => _TimeBlockingPageState();
}

class _TimeBlockingPageState extends State<TimeBlockingPage> {
  List<TimePlannerTask> tasks = [];

  final now = DateTime.now();
  final dateFormat = DateFormat('M/d/yyyy');
  final dayFormat = DateFormat('EEEE');

  List<TimePlannerTitle> getHeaders() {
    return List.generate(
      7,
          (index) => TimePlannerTitle(
        date: dateFormat.format(now.add(Duration(days: index))),
        title: dayFormat.format(now.add(Duration(days: index))).toLowerCase(),
      ),
    );
  }

  void _addObject(BuildContext context) async {
    List<Color?> colors = [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.lime[600]
    ];

    // show dialog box to prompt user for task details
    String? taskName = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          TextEditingController _taskNameController = TextEditingController();
          TimeOfDay? _startTime;
          int _duration = 60;

          // update start time when user selects a new time
          void _selectTime() async {
            TimeOfDay? newTime = await showTimePicker(
                context: context, initialTime: TimeOfDay.now());
            if (newTime != null) {
              setState(() {
                _startTime = newTime;
              });
            }
          }

          return AlertDialog(
            title: const Text('Add Task'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _taskNameController,
                    decoration: const InputDecoration(
                        hintText: 'Enter task name'),
                  ),
                  ListTile(
                    title: const Text('Start Time'),
                    subtitle: _startTime == null
                        ? const Text('Select a time')
                        : Text('${_startTime!.format(context)}'),
                    onTap: _selectTime,
                  ),
                  Slider(
                    min: 30,
                    max: 240,
                    divisions: 6,
                    value: _duration.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        _duration = value.round();
                      });
                    },
                    label: '${_duration} min',
                  ),
                  const Text('Duration'),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    String taskName = _taskNameController.text;
                    if (taskName.isNotEmpty && _startTime != null) {
                      DateTime now = DateTime.now();
                      DateTime taskStartTime = DateTime(
                          now.year, now.month, now.day, _startTime!.hour, _startTime!.minute);
                      setState(() {
                        tasks.add(
                          TimePlannerTask(
                            color: colors[Random().nextInt(colors.length)],
                            dateTime: TimePlannerDateTime(
                                day: taskStartTime.weekday - 1,
                                hour: taskStartTime.hour,
                                minutes: taskStartTime.minute),
                            minutesDuration: _duration,
                            daysDuration: 1,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                      Text('You clicked on a task!')));
                            },
                            child: Text(
                              taskName,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                          ),
                        );
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Task added to time planner!')));
                      Navigator.pop(context, taskName);
                    }
                  },
                  child: const Text('Add')),
            ],
          );
        });

    if (taskName != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Task added to time planner!')));
    }
  }

  // void _addObject(BuildContext context) {
  //   List<Color?> colors = [
  //     Colors.purple,
  //     Colors.blue,
  //     Colors.green,
  //     Colors.orange,
  //     Colors.lime[600]
  //   ];
  //
  //   setState(() {
  //     tasks.add(
  //       TimePlannerTask(
  //         color: colors[Random().nextInt(colors.length)],
  //         dateTime: TimePlannerDateTime(
  //             day: Random().nextInt(14),
  //             hour: Random().nextInt(18) + 6,
  //             minutes: Random().nextInt(60)),
  //         minutesDuration: Random().nextInt(90) + 30,
  //         daysDuration: Random().nextInt(4) + 1,
  //         onTap: () {
  //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //               content: Text('You click on time planner object')));
  //         },
  //         child: Text(
  //           'this is a demo',
  //           style: TextStyle(color: Colors.grey[350], fontSize: 12),
  //         ),
  //       ),
  //     );
  //   });
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Random task added to time planner!')));
  // }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/cloudbackground.jpg',
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.pink[900]?.withOpacity(0.6),
                ),
              ],
            )
        ),
        title: Text(widget.todo.task),
        centerTitle: true,
        titleTextStyle: GoogleFonts.openSans(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white),
      ),
      body: Center(
        child: TimePlanner(
          startHour: 6,
          endHour: 23,
          style: TimePlannerStyle(
            // cellHeight: 60,
            // cellWidth: 60,
            showScrollBar: true,
          ),
          headers: getHeaders(),
          tasks: tasks,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addObject(context),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
        backgroundColor: Colors.purple[800],
      ),
    );
  }
}