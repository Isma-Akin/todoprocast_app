// import 'package:flutter/material.dart';
// import 'package:timer_count_down/timer_count_down.dart';
// import 'package:timer_count_down/timer_controller.dart';
//
//
// class PomodoroTimer extends StatefulWidget {
//   @override
//   _PomodoroTimerState createState() => _PomodoroTimerState();
// }
//
// class _PomodoroTimerState extends State<PomodoroTimer> {
//
//   CountdownController _controller = CountdownController();
//
//   @override
//   void initState() {
//     super.initState();
//
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFF00BFA5),
//                 Color(0xFF00C853),
//               ],
//             ),
//           ),
//         ),
//         title: const Text('Pomodoro Timer'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Countdown(
//               controller: _controller,
//               seconds: 25 * 60,
//               build: (_, double time) => Text(
//                 '${time ~/ 60}:${(time % 60).toInt().toString().padLeft(2, '0')}',
//                 style: const TextStyle(fontSize: 50),
//               ),
//               interval: const Duration(milliseconds: 100),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     _controller.start();
//                   },
//                   child: const Text('Start'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     _controller.pause();
//                   },
//                   child: const Text('Pause'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     _controller.restart();
//                   },
//                   child: const Text('Restart'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }

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
                  state.userPaused
                      ? 'Resume timer at ${(state.secondsRemaining / 60).floor()}:${(state.secondsRemaining % 60).toString().padLeft(2, '0')}'
                      : 'Break for ${(state.secondsRemaining / 60).floor()} minutes',
                  style: Theme.of(context).textTheme.headline2,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<PomodoroBloc>().add(StartPomodoro()),
                  child: const Text('Start'),
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
