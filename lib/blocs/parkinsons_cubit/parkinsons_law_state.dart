abstract class ParkinsonState {}
class ParkinsonInitial extends ParkinsonState {}

class ParkinsonRunning extends ParkinsonState {
  final int remainingTime;
  ParkinsonRunning(this.remainingTime);
}

class ParkinsonPaused extends ParkinsonState {
  final int remainingTime;
  ParkinsonPaused(this.remainingTime);
}
class ParkinsonCompleted extends ParkinsonState {}

class ParkinsonStopped extends ParkinsonState {}

class ParkinsonNotStarted extends ParkinsonState {}