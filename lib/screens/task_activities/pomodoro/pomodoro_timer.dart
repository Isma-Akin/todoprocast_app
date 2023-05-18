import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoprocast_app/blocs/todos_status/todos_status_bloc.dart';

import '../../../blocs/pomodoros/pomodoro_bloc.dart';
import '../../../models/todo_models.dart';


class PomodoroTimer extends StatefulWidget {

  const PomodoroTimer({Key? key,}) : super(key: key);

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  PomodoroBloc? _pomodoroBloc;

  @override
  void initState() {
    super.initState();
    _pomodoroBloc = BlocProvider.of<PomodoroBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    _pomodoroBloc = BlocProvider.of<PomodoroBloc>(context);
    return BlocBuilder<PomodoroBloc, PomodoroState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Pomodoro Timer',
                style: GoogleFonts.openSans(
                    fontSize: 32,
                    fontWeight: FontWeight.bold),),
              flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/cloudbackground.jpg',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        color: Colors.orange[900]?.withOpacity(0.6),
                      ),
                    ],
                  )
              ),
            ),
            body: Center(
              child: PomodoroTimerItem(),
            ),
          );
        },
     );
  }
}


class PomodoroTimerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PomodoroBloc, PomodoroState>(
      builder: (context, pomodoroState) {
        print('Pomodoro state: $pomodoroState');
        if (pomodoroState is PomodoroNotStarted ||
            pomodoroState is PomodoroInitial) {
          return pomodoroBlocBuilder();
        } else if (pomodoroState is PomodoroRunning) {
          return pomodoroRunning(pomodoroState, context);
        } else if (pomodoroState is PomodoroPaused) {
          return pomodoroPaused(pomodoroState, context);
        } else if (pomodoroState is Break) {
          return pomodoroBreak(context);
        } else if (pomodoroState is PomodoroCompleted) {
          return pomodoroCompleted(context);
        } else {
          return BlocBuilder<TodosStatusBloc, TodosStatusState>(
            builder: (context, todosState) {
              print('Todos state: $todosState');
              if (todosState is TodosStatusLoaded) {
                print('Pending todos count: ${todosState.pendingTodos.length}');
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
                      onChanged: (Todo? todo) {
                        context.read<PomodoroBloc>().add(StartPomodoro(todo: todo));
                      },
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        }
      },
    );
  }

  Column pomodoroCompleted(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<TodosStatusBloc, TodosStatusState>(
          builder: (context, todosState) {
            print('Todos state: $todosState');
            if (todosState is TodosStatusLoaded) {
              print('Pending todos count: ${todosState.pendingTodos.length}');
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
                    onChanged: (Todo? todo) {
                      context
                          .read<PomodoroBloc>()
                          .add(StartPomodoro(todo: todo));
                    },
                  ),
                ],
              );
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        ),
        Text(
          'Pomodoro completed!',
          style: Theme.of(context).textTheme.headline1,
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
  }

  Column pomodoroBreak(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<TodosStatusBloc, TodosStatusState>(
          builder: (context, todosState) {
            print('Todos state: $todosState');
            if (todosState is TodosStatusLoaded) {
              print('Pending todos count: ${todosState.pendingTodos.length}');
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
                    onChanged: (Todo? todo) {
                      context
                          .read<PomodoroBloc>()
                          .add(StartPomodoro(todo: todo));
                    },
                  ),
                ],
              );
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        ),
        Text(
          'Take a break!',
          style: Theme.of(context).textTheme.headline1,
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
  }

  Column pomodoroPaused(PomodoroPaused pomodoroState, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<TodosStatusBloc, TodosStatusState>(
          builder: (context, todosState) {
            print('Todos state: $todosState');
            if (todosState is TodosStatusLoaded) {
              print('Pending todos count: ${todosState.pendingTodos.length}');
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
                    onChanged: (Todo? todo) {
                      context
                          .read<PomodoroBloc>()
                          .add(StartPomodoro(todo: todo));
                    },
                  ),
                ],
              );
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        ),
        Text(
          '${(pomodoroState.secondsRemaining / 60).floor()}:${(pomodoroState.secondsRemaining % 60).toString().padLeft(2, '0')}',
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
  }

  Column pomodoroRunning(PomodoroRunning pomodoroState, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<TodosStatusBloc, TodosStatusState>(
          builder: (context, todosState) {
            print('Todos state: $todosState');
            if (todosState is TodosStatusLoaded) {
              print('Pending todos count: ${todosState.pendingTodos.length}');
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
                    onChanged: (Todo? todo) {
                      context
                          .read<PomodoroBloc>()
                          .add(StartPomodoro(todo: todo));
                    },
                  ),
                ],
              );
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        ),
        Text(
          '${(pomodoroState.secondsRemaining / 60).floor()}:${(pomodoroState.secondsRemaining % 60).toString().padLeft(2, '0')}',
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
  }

  BlocBuilder<TodosStatusBloc, TodosStatusState> pomodoroBlocBuilder() {
    return BlocBuilder<TodosStatusBloc, TodosStatusState>(
      builder: (context, todosState) {
        print('Todos state: $todosState');
        if (todosState is TodosStatusLoaded) {
          print('Pending todos count: ${todosState.pendingTodos.length}');
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
                onChanged: (Todo? todo) {
                  context.read<PomodoroBloc>().add(StartPomodoro(todo: todo));
                },
              ),
            ],
          );
        } else {
          return Center(child: const CircularProgressIndicator());
        }
      },
    );
  }
}
