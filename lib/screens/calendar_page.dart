import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../blocs/todos/time_bloc.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      BlocProvider.of<TimeBloc>(context).add(UpdateTime());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimeBloc(),
      child: MaterialApp(debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Calendar'),
          ),
          body: BlocBuilder<TimeBloc, DateTime>(
            builder: (context, state) {
              return Column(
                  children: [
                    Text(DateFormat('hh:mm:ss').format(DateTime.now()),
                      style: const TextStyle(fontSize: 30),),
                    Text(DateFormat('EEEE, MMM d').format(DateTime.now()),
                      style: const TextStyle(fontSize: 30),),
                    TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: DateTime.now(),
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
