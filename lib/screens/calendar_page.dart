import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todoprocast_app/blocs/blocs.dart';
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
                    SizedBox(height: 30,),
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
                          final state = context.read<TodosStatusBloc>().state;
                          if (state is TodosStatusLoaded) {
                            _selectedTasks = state.pendingTodos.where((task) =>
                                isSameDay(task.dueDate, selectedDay)).toList();
                          } else {
                            _selectedTasks = [];
                          }
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: _selectedTasks.length,
                        itemBuilder: (context, index) {
                          final task = _selectedTasks[index];
                          return ListTile(
                            title: Text(task.task + " is due today!"),
                            subtitle: Text(task.description),
                          );
                        },
                      ),
                    ),
                  ],
              );
            },
          ),
        ),
      ),
    );
  }
}
