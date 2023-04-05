import 'package:equatable/equatable.dart';

abstract class TimeEvent extends Equatable {
  const TimeEvent();

  @override
  List<Object> get props => [];
}


class UpdateTimeEvent extends TimeEvent {}

