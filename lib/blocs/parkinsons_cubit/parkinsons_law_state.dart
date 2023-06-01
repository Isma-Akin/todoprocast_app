abstract class ParkinsonState {}
class ParkinsonInitial extends ParkinsonState {}

// class ParkinsonRunning extends ParkinsonState {
//   final int todoId;
//   final DateTime deadline;
//
//   ParkinsonRunning(this.todoId, this.deadline);
// }

class ParkinsonPaused extends ParkinsonState {
  final int remainingTime;
  ParkinsonPaused(this.remainingTime);
}
class ParkinsonCompleted extends ParkinsonState {
  final String todoId;
  ParkinsonCompleted(this.todoId);
}

class ParkinsonStopped extends ParkinsonState {
  final int todoId;
  ParkinsonStopped(this.todoId);
}

class ParkinsonNotStarted extends ParkinsonState {}

// class ParkinsonTicking extends ParkinsonState {
//   final String todoId;
//   final DateTime deadline;
//
//   ParkinsonTicking(this.todoId, this.deadline);
// }

class ParkinsonTicking extends ParkinsonState {
  final int todoId;
  final int remainingSeconds;

  ParkinsonTicking(this.todoId, this.remainingSeconds);
}
