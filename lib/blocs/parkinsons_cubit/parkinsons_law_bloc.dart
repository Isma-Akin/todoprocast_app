import 'dart:async';

import 'package:todoprocast_app/blocs/parkinsons_cubit/parkinsons_law_event.dart';
import 'package:todoprocast_app/blocs/parkinsons_cubit/parkinsons_law_state.dart';

import '../blocs.dart';

class ParkinsonBloc extends Bloc<ParkinsonEvent, ParkinsonState> {
  Timer? _timer;

  ParkinsonBloc() : super(ParkinsonInitial()) {
    on<StartParkinson>(_mapStartParkinsonToState);
    on<PauseParkinson>(_mapPauseParkinsonToState);
    on<ResumeParkinson>(_mapResumeParkinsonToState);
    on<StopParkinson>(_mapStopParkinsonToState);
    on<TickParkinson>(_mapTickParkinsonToState);
  }

  void _mapStartParkinsonToState(StartParkinson event, Emitter<ParkinsonState> emit) {
    _timer?.cancel();
    final deadline = event.deadline;
    final remainingTime = deadline.difference(DateTime.now()).inSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TickParkinson());
    });
    emit(ParkinsonRunning(remainingTime));
  }

  void _mapPauseParkinsonToState(PauseParkinson event, Emitter<ParkinsonState> emit) {
    if (state is ParkinsonRunning) {
      final secondsRemaining = (state as ParkinsonRunning).remainingTime;
      _timer?.cancel();
      emit(ParkinsonPaused(secondsRemaining));
    }
  }

  void _mapResumeParkinsonToState(ResumeParkinson event, Emitter<ParkinsonState> emit) {
    if (state is ParkinsonPaused) {
      final secondsRemaining = (state as ParkinsonPaused).remainingTime;
      emit(ParkinsonRunning(secondsRemaining));
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        add(TickParkinson());
      });
    }
  }

  void _mapStopParkinsonToState(StopParkinson event, Emitter<ParkinsonState> emit) {
    _timer?.cancel();
    emit(ParkinsonStopped());
  }

  void _mapTickParkinsonToState(TickParkinson event, Emitter<ParkinsonState> emit) {
    if (state is ParkinsonRunning) {
      final secondsRemaining = (state as ParkinsonRunning).remainingTime - 1;
      if (secondsRemaining > 0) {
        emit(ParkinsonRunning(secondsRemaining));
      } else {
        _timer?.cancel();
        emit(ParkinsonCompleted());
      }
    }
  }
}