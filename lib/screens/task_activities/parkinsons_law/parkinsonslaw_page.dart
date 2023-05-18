import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoprocast_app/models/models.dart';

import '../../../blocs/parkinsons_cubit/parkinsons_law_bloc.dart';
import '../../../blocs/parkinsons_cubit/parkinsons_law_event.dart';
import '../../../blocs/parkinsons_cubit/parkinsons_law_state.dart';
import '../../../blocs/todos_status/todos_status_bloc.dart';

// class ParkinsonsLawPage extends StatefulWidget {
//   final Todo todo;
//
//   const ParkinsonsLawPage({required this.todo});
//
//   @override
//   _ParkinsonsLawPageState createState() => _ParkinsonsLawPageState();
// }
//
// class _ParkinsonsLawPageState extends State<ParkinsonsLawPage> {
//   late Duration _timeRemaining;
//   late Timer _timer;
//
//   void _startParkinsonsLawTimer(Duration duration) {
//     setState(() {
//       _timeRemaining = duration;
//     });
//     Timer.periodic(Duration(seconds: 1), (_) {
//       setState(() {
//         if (_timeRemaining.inSeconds > 0) {
//           _timeRemaining -= Duration(seconds: 1);
//         } else {
//           _timeRemaining = Duration.zero;
//         }
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     _timeRemaining = widget.todo.deadline.difference(DateTime.now());
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // Cancel the timer if the screen is disposed
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//         BlocBuilder<TodosStatusBloc, TodosStatusState>(
//       builder: (context, todosState) {
//         print('Todos state: $todosState');
//         if (todosState is TodosStatusLoaded) {
//           print('Pending todos count: ${todosState.pendingTodos.length}');
//           return Column(
//             children: [
//               DropdownButton(
//                 items: todosState.pendingTodos.map((Todo todo) {
//                   return DropdownMenuItem(
//                     value: todo,
//                     child: Text(todo.task),
//                   );
//                 }).toList(),
//                 hint: const Text("Select a Todo"),
//                 onChanged: (Todo? todo) {
//                   // context.read<PomodoroBloc>().add(StartPomodoro(todo: todo));
//                 },
//               ),
//             ],
//           );
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//       ),
//         ],
//         title: Text('Parkinson\'s law'),
//         titleTextStyle: GoogleFonts.openSans(
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//           fontSize: 28,
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//             Text(widget.todo.task, style: GoogleFonts.openSans(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 28,
//             ),),
//         const SizedBox(height: 16),
//         Text('Time remaining: ${_timeRemaining.inDays} days '
//                 '${_timeRemaining.inHours % 24} hours '
//                 '${_timeRemaining.inMinutes % 60} minutes '
//                 '${_timeRemaining.inSeconds % 60} seconds',
//               style: GoogleFonts.openSans(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//         ),),
//           const SizedBox(height: 16),
//           Text('Set Parkinson\'s law timer:', style: GoogleFonts.openSans(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//           ),),
//           Row(
//             children: [
//           Expanded(
//             child: TextField(
//               decoration: const InputDecoration(
//                 hintText: 'Enter time in minutes',
//               ),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 final durationInMinutes = int.tryParse(value);
//                 if (durationInMinutes != null) {
//                   _startParkinsonsLawTimer(Duration(minutes: durationInMinutes));
//                 }
//               },
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _startParkinsonsLawTimer(Duration(minutes: 30));
//             },
//             child: Text('30 mins', style: GoogleFonts.openSans(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),),
//             ),
//         ],
//       ),
//     ],
//     ),
//         ),
//     );
//     }
//   }


class ParkinsonsLawPage extends StatelessWidget {
  const ParkinsonsLawPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parkinsonsBloc = BlocProvider.of<ParkinsonBloc>(context);
    return BlocBuilder<ParkinsonBloc, ParkinsonState>(
      builder: (context, state) {
        if (state is ParkinsonNotStarted || state is ParkinsonInitial) {
          return parkinsonsNotStarted(parkinsonsBloc);
        } else if (state is ParkinsonRunning) {
          return parkinsonsRunning(state, context);
        } else if (state is ParkinsonPaused) {
          return parkinsonsPaused(state, context);
        } else if (state is ParkinsonCompleted) {
          return parkinsonsCompleted(context);
        } else {
          return const CircularProgressIndicator(); // loading state
        }
      },
    );
  }

  Widget parkinsonsNotStarted(ParkinsonBloc parkinsonsBloc) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parkinson\'s law'),
        actions: [
          BlocBuilder<TodosStatusBloc, TodosStatusState>(
            builder: (context, todosState) {
              if (kDebugMode) {
                print('Todos state: $todosState');
              }
              if (todosState is TodosStatusLoaded) {
                return Column(
                  children: [
                    DropdownButton(
                      items: todosState.pendingTodos.map((Todo todo) {
                        return DropdownMenuItem(
                          value: todo,
                          child: Text(todo.task),
                        );
                      }).toList(),
                      hint: const Text("Select a Todo"),
                      onChanged: (Todo? selectedTodo) {
                        if (selectedTodo != null) {
                          final deadline = selectedTodo.deadline;
                          parkinsonsBloc.add(StartParkinson(deadline, selectedTodo));
                        }
                      },
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Select a todo to start the timer'),
      ),
    );
  }


  Widget parkinsonsRunning(ParkinsonRunning state, BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Time remaining: ${state.remainingTime}'),
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () {
                BlocProvider.of<ParkinsonBloc>(context).add(PauseParkinson());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget parkinsonsPaused(ParkinsonPaused state, BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Time remaining: ${state.remainingTime}'),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                BlocProvider.of<ParkinsonBloc>(context).add(ResumeParkinson());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget parkinsonsCompleted(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Parkinson\'s Law timer has finished!'),
      ),
    );

  }
}
