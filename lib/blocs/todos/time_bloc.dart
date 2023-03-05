import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todoprocast_app/blocs/todos/time_event.dart';

class TimeBloc extends Bloc<TimeEvent, DateTime> {
  TimeBloc() : super(DateTime.now());

  @override
  Stream<DateTime> mapEventToState(TimeEvent event) async* {
    if (event is UpdateTime) {
      // while (true) {
        await Future.delayed(const Duration(seconds: 1));
        yield DateTime.now();
      }
    }
  }


class TimeEvent {}

class UpdateTime extends TimeEvent {}

