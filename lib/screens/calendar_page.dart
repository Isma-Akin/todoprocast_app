import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todoprocast_app/constants.dart';

import '../blocs/todos/time_bloc.dart';
import '../models/todo_models.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Timer? _timer;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     BlocProvider.of<TimeBloc>(context).add(UpdateTime());
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   _timer?.cancel();
  //   super.dispose();
  // }
  DateTime _selectedDay = DateTime.now();

  List<Todo> _selectedTasks = [];
  final List<Todo> _selectedTask = [
    Todo(task: 'Task 1', description: 'Do task 1', dueDate: DateTime.now(), id: '', dateCreated: DateTime.now(),),
    Todo(task: 'Task 1', description: 'Do task 1', dueDate: DateTime.now(), id: '', dateCreated: DateTime.now(),),
    Todo(task: 'Task 1', description: 'Do task 1', dueDate: DateTime.now(), id: '', dateCreated: DateTime.now(),),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimeBloc(),
      child: MaterialApp(debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.tertiaryColor,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text('Calendar'),
          ),
          body: BlocBuilder<TimeBloc, DateTime>(
            builder: (context, state) {
              return Column(
                  children: [
                    // Text(DateFormat('hh:mm:ss').format(DateTime.now()),
                    //   style: const TextStyle(fontSize: 30),),
                    Text(DateFormat('EEEE, MMM d').format(DateTime.now()),
                      style: const TextStyle(fontSize: 30),),
                    TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: DateTime.now(),
                      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _selectedTasks = _selectedTask.where((task) =>
                              isSameDay(task.dueDate, selectedDay)).toList();
                        });
                        },
                      calendarFormat: CalendarFormat.month,
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      calendarStyle: const CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Container(
                      height: 300,
                      child: ListView.builder(
                        itemCount: _selectedTasks.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_selectedTasks[index].task + " is due on this day!"),
                            subtitle: Text(_selectedTasks[index].description),
                          );
                        },
                      ),
                    ),
                  ]
              );
            },
          ),
        ),
      ),
    );
  }
}
