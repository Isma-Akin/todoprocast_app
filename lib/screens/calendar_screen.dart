import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todoprocast_app/blocs/blocs.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/screens/todo_detail_screen.dart';

import '../blocs/todos/time_bloc.dart';
import '../models/todo_models.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();

  List<Todo> _selectedTasks = [];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimeBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          // backgroundColor: Colors.deepPurple[100],
          // appBar: PreferredSize(
          //   preferredSize: const Size.fromHeight(50.0),
          //   child: Stack(
          //     fit: StackFit.expand,
          //     children: [
          //       Image.asset(
          //         'assets/images/cloudbackground.jpg',
          //         fit: BoxFit.cover,
          //       ),
          //       Container(
          //         decoration: BoxDecoration(
          //           color: Colors.purpleAccent[200]?.withOpacity(0.6),
          //           borderRadius: BorderRadius.only(
          //             bottomLeft: Radius.circular(20),
          //             bottomRight: Radius.circular(20),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
                          // context.read<ParkinsonsLawBloc>().add(StopCountdownEvent());
                        },
                      ),
                      title: Center(
                        child: Text(
                          'Your Day',
                          style: Theme.of(context).textTheme.headline4?.copyWith(
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
                    Colors.purple.withOpacity(0.7),
                    BlendMode.srcATop,
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ) ,
          ),
          body: BlocBuilder<TimeBloc, DateTime>(
            builder: (context, state) {
              return Column(
                  children: [
                    const SizedBox(height: 30,),
                    // Text(DateFormat('hh:mm:ss').format(DateTime.now()),
                    //   style: const TextStyle(fontSize: 30),),
                    Text(DateFormat('EEEE, MMM d').format(DateTime.now()),
                      style: GoogleFonts.openSans(fontSize: 30),),
                    TableCalendar(
                      calendarBuilders: CalendarBuilders(
                        selectedBuilder: (context, date, events) =>
                            Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.bluePrimaryColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                date.day.toString(),
                                style: GoogleFonts.openSans(fontSize: 24),
                              ),
                            ),
                                todayBuilder: (context, date, events) =>
                            Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.blueSecondaryColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                date.day.toString(),
                                style: GoogleFonts.openSans(color: Colors.white,
                                    fontSize: 24),
                                  ),
                                ),
                                markerBuilder: (context, date, events) {
                          final state = context.watch<TodosStatusBloc>().state;
                          if (state is TodosStatusLoaded) {
                            final todosDueOnDate = state.pendingTodos.where((task) =>
                                isSameDay(task.dueDate, date)).toList();
                            if (todosDueOnDate.isNotEmpty) {
                              return Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  width: 6,
                                  height: 6,
                                ),
                              );
                            }
                          }
                          return null;
                        },
                      ),
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

                    const Divider(color: Colors.black,),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: _selectedTasks.length,
                        itemBuilder: (context, index) {
                          final task = _selectedTasks[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TodoDetailScreen(todo: task),
                                ),
                              );
                            },
                            child: _calendartodoscard(task: task),
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

class _calendartodoscard extends StatelessWidget {
  const _calendartodoscard({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Todo task;

  @override
  Widget build(BuildContext context) {
    bool isOverdue = DateTime.now().isAfter(task.dueDate!);
    return Card(
      elevation: 2,
      color: isOverdue ? Colors.grey : AppColors.blueSecondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10),
          color: isOverdue ? Colors.grey : Colors.purple,
          image: DecorationImage(
            image: const AssetImage('assets/images/cloudbackground.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.purple.withOpacity(0.5),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: ListTile(
          textColor: Colors.white,
          title: Text(
            task.task + " is due today!",
            style: const TextStyle(color: Colors.black),
          ),
          subtitle: Text(
            task.description,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
