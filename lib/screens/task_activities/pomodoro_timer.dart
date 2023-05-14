import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/task_activities/pomodoro_bloc.dart';
import '../../models/todo_models.dart';


class PomodoroTimer extends StatelessWidget {
  final List<Todo> todos;
  const PomodoroTimer({Key? key, required this.todos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00BFA5),
                Color(0xFF00C853),
              ],
            ),
          ),
        ),
        title: const Text('Pomodoro Timer'),
      ),
      body: BlocBuilder<PomodoroBloc, PomodoroState>(
        builder: (context, state) {
          if (state is PomodoroRunning) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(state.secondsRemaining / 60).floor()}:${(state.secondsRemaining % 60).toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<PomodoroBloc>().add(PausePomodoro()),
                  child: const Text('Pause'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<PomodoroBloc>().add(ResetPomodoro()),
                  child: const Text('Reset'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<PomodoroBloc>().add(StopPomodoro()),
                  child: const Text('Stop'),
                ),
              ],
            );
          } else if (state is PomodoroPaused) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(state.secondsRemaining / 60).floor()}:${(state.secondsRemaining % 60).toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<PomodoroBloc>().add(ResumePomodoro()),
                  child: const Text('Resume'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<PomodoroBloc>().add(ResetPomodoro()),
                  child: const Text('Reset'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<PomodoroBloc>().add(StopPomodoro()),
                  child: const Text('Stop'),
                ),
              ],
            );
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () => context.read<PomodoroBloc>().add(StartPomodoro()),
                child: const Text('Start'),
              ),
            );
          }
        },
      ),
    );
  }
}
