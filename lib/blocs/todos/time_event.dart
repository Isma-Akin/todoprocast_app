import 'package:equatable/equatable.dart';

abstract class TimeEvent extends Equatable {
  const TimeEvent();

  @override
  List<Object> get props => [];
}

// class UpdateTime extends TimeEvent {
//   const UpdateTime();
//
//   @override
//   List<Object> get props => [];
// }

class UpdateTimeEvent extends TimeEvent {}

// class TimeBloc extends Bloc<TimeEvent, DateTime> {
//   TimeBloc() : super(DateTime.now());
//
//   Stream<DateTime> mapEventToState(TimeEvent event) async* {
//     if (event is UpdateTime) {
//       while (true) {
//         await Future.delayed(const Duration(seconds: 1));
//         yield DateTime.now();
//       }
//     }
//   }
// }
