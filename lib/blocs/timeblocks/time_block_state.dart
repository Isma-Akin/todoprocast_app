import 'package:time_planner/time_planner.dart';

abstract class TimeBlocksState {}

class TimeBlocksLoadInProgress extends TimeBlocksState {}

class TimeBlocksLoadSuccess extends TimeBlocksState {
  final List<TimePlannerTask> tasks;

  TimeBlocksLoadSuccess(this.tasks);
}

class TimeBlocksLoadFailure extends TimeBlocksState {}

class TimeBlocksInitial extends TimeBlocksState {}
