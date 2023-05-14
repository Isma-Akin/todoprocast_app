import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:todoprocast_app/screens/task_activities/pomodoro_timer.dart';

import '../../blocs/task_activities/pomodoro_bloc.dart';
import '../../blocs/todos/todos_bloc.dart';
import '../../blocs/todos_status/todos_status_bloc.dart';
import '../../constants.dart';
import '../../models/todo_models.dart';
import '../todo_detail_screen.dart';
//
// import '../../models/todo_models.dart';
//
// class PomodoroScreen extends StatelessWidget {
//   final String cardOptionTitle;
//   final List<Todo> todos;
//
//   const PomodoroScreen({
//     required this.cardOptionTitle,
//     required this.todos,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(cardOptionTitle),
//       ),
//       body: ListView.builder(
//         itemCount: todos.length,
//         itemBuilder: (BuildContext context, int index) {
//           final todo = todos[index];
//
//           return CheckboxListTile(
//             title: Text(todo.task),
//             value: todo.isApplied,
//             onChanged: (bool? value) {
//               // You can dispatch a Bloc event here to apply the technique to the selected todo
//               // and update the `isApplied` flag for the todo.
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  // late PomodoroBloc _pomodoroBloc;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _pomodoroBloc = BlocProvider.of<PomodoroBloc>(context);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.navigate_before_rounded, size: 30,),
        ),
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
        centerTitle: true,
        title: Text(
          'Pomodoro',
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Divider(
              height: 10,
              thickness: 2,
              color: Colors.orange[900],),
            Column(
              children: [
                Container(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: const AssetImage('assets/images/pomodoro.png'),
                              colorFilter: ColorFilter.mode(
                                Colors.orange.withOpacity(0.7),
                                BlendMode.dstATop,
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: const [
                              Text(
                                ' ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 10,
                          thickness: 2,
                          color: Colors.orange[900],),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.black,
                              ),
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: const Text(
                              '1. Choose a task to be accomplished\n'
                                  '2. Set the Pomodoro to 25 minutes (the Pomodoro is the timer)\n'
                                  '3. Work on the task until the Pomodoro rings, then put a check on your sheet of paper\n'
                                  '4. Take a short break (5 minutes is OK)\n'
                                  '5. Every 4 Pomodoros take a longer break',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            Divider(
              height: 10,
              thickness: 0.5,
              color: Colors.grey[900],),
            // onTap: () async {
            //   // Filter the list of todos to get only those with the pomodoro applied
            //   List<Todo> todosWithPomodoro = _pomodoroBloc.state.pendingTodos.where((todo) => todo.isPomodoroApplied).toList();
            //
            //   // Show a dialog with a list of todos
            //   Todo selectedTodo = await showDialog(
            //     context: context,
            //     builder: (BuildContext context) {
            //       return SimpleDialog(
            //         title: Text('Select a Todo'),
            //         children: todosWithPomodoro.map((todo) {
            //           return SimpleDialogOption(
            //             child: Text(todo.task),
            //             onPressed: () {
            //               Navigator.pop(context, todo);
            //             },
            //           );
            //         }).toList(),
            //       );
            //     },
            //   );
            //
            //   // If a todo is selected, navigate to the PomodoroTimer screen with that todo
            //   if (selectedTodo != null) {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => PomodoroTimer(todo: selectedTodo),
            //       ),
            //     );
            //   }
            // },
        Card(
          elevation: 2,
          child: InkWell(
            highlightColor: Colors.orange[900],
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return BlocBuilder<TodosStatusBloc, TodosStatusState>(
                    builder: (context, state) {
                      if (state is TodosStatusLoaded) {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return ListView.builder(
                              itemCount: state.pendingTodos.length,
                              itemBuilder: (context, index) {
                                final todo = state.pendingTodos[index];
                                return CheckboxListTile(
                                  title: Text(todo.task),
                                  value: todo.isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      state.pendingTodos[index].isSelected = value!;
                                      if (value) {
                                        state.pendingTodos[index].updateTaskActivity('Pomodoro');
                                      } else {
                                        state.pendingTodos[index].updateTaskActivity('');
                                      }
                                    });
                                  },
                                );
                              },
                            );
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  );
                },
              ).then((value) {
                // Handle the selected todos here and navigate to the pomodoro timer page.
                final state = context.read<TodosStatusBloc>().state;
                if (state is TodosStatusLoaded) {
                  final selectedTodos = state.pendingTodos.where((todo) => todo.isSelected).toList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PomodoroTimer(todos: selectedTodos),
                    ),
                  );
                }
              });
            },
            splashColor: Colors.orange[900],
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  Icon(Icons.timer, color: Colors.orange[900]),
                  const SizedBox(width: 10),
                  Text(
                    'Pomodoro screen',
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Card(
              elevation: 2,
              child: InkWell(
                highlightColor: Colors.orange[900],
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return BlocBuilder<TodosStatusBloc, TodosStatusState>(
                        builder: (context, state) {
                          if (state is TodosStatusLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is TodosStatusLoaded) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      'Select Todo',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState) {
                                        return ListView.builder(
                                          itemCount: state.pendingTodos.length,
                                          itemBuilder: (context, index) {
                                            final todo = state.pendingTodos[index];
                                            return CheckboxListTile(
                                              title: Text(todo.task),
                                              value: todo.isSelected,
                                                onChanged: (value) {
                                                  setState(() {
                                                    // Update the selected state of the todo
                                                    state.pendingTodos[index].isSelected = value!;
                                                    if (value) {
                                                      state.pendingTodos[index].updateTaskActivity('Pomodoro');
                                                    } else {
                                                      state.pendingTodos[index].updateTaskActivity('');
                                                    }
                                                  });
                                                }

                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  // final List<Todo> selectedTodos =
                                  // state.pendingTodos.where((todo) => todo.isSelected ?? false).toList();
                                  // for (final todo in selectedTodos) {
                                  //   todo.pomodoros++;
                                  // }
                                  // for (final todo in state.pendingTodos) {
                                  //   todo.isSelected = false;
                                  // }
                                  // Navigator.pop(context);
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    // onPressed: () {
                                    //   final selectedTodos = state.pendingTodos.where((todo) => todo.isSelected).toList();
                                    //   Navigator.pop(context);
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => PomodoroTimer(todos: selectedTodos),
                                    //     ),
                                    //   );
                                    // },
                                    onPressed: () {
                                      final selectedTodos = state.pendingTodos.where((todo) => todo.isSelected).toList();
                                      for (var todo in selectedTodos) {
                                        context.read<TodosBloc>().add(UpdateTodo(todo: todo));
                                      }
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PomodoroTimer(todos: selectedTodos),
                                        ),
                                      );
                                    },
                                    child: const Text('Apply Pomodoro'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Text('Something went wrong.');
                      }
                    },
                  );
                },
              );
            },
            splashColor: Colors.orange[900],
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  Icon(Icons.task_outlined, color: Colors.orange[900]),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                      'Active pomodoros: ',
                      style: GoogleFonts.openSans(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
        Card(
          elevation: 2,
          child: InkWell(
            highlightColor: Colors.orange[900],
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () {},
            splashColor: Colors.orange[900],
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                margin: EdgeInsets.zero,
                child: Row(
                  children:  [
                    Icon(Icons.info_outline, color: Colors.orange[900],),
                    const SizedBox(width: 10,),
                    Text('Press to know more about Pomodoro ', style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),],)
            ),
          ),
        ),
        Divider(
          height: 10,
          thickness: 0.5,
          color: Colors.grey[900],),
        const SizedBox(height: 10,),
        Card(
          elevation: 2,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Text("Eisenhower matrix",
                    style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),),
                ],
              ),
            )
          ),
        ),
        Card(
          elevation: 2,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Text("Eat that frog",
                    style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),),
                ],
              ),
            )
          ),
        ),
        // BlocBuilder<TodosStatusBloc, TodosStatusState>(
        //   builder: (context, state) {
        //     if (state is TodosStatusLoading) {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //     if (state is TodosStatusLoaded) {
        //       return Expanded(
        //           child: ListView(children: [
        //             _todo(
        //               state.pendingTodos,
        //               ' ',
        //             )
        //           ]));
        //     } else {
        //       return const Text('Something went wrong.');
        //     }
        //   },
        // ),
      ],
        ),
      )

    );
  }

  Dismissible _todosCard(
      BuildContext context,
      Todo todo,
      ) {

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        context.read<TodosBloc>().add(RemoveTodo(todo: todo.copyWith(taskCancelled: true),
        ));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${todo.task} dismissed")),
        );
      },
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10),
          color: Colors.orange,
          image: DecorationImage(
            image: const AssetImage('assets/images/cloudbackground.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Card(
          // color: todo.taskCompleted == true ? Colors.blue[300] : AppColors.orangePrimaryColor,
          color: AppColors.orangePrimaryColor,
          // margin: const EdgeInsets.only(bottom: 5.0),
          margin: const EdgeInsets.all(0.5),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      TodoDetailScreen(todo: todo,),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(1.0, 0.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end).chain(
                        CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<TodosBloc, TodosState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // IconButton(
                          //     onPressed: () {},
                          //     icon: const Icon(Icons.arrow_drop_down_rounded)),
                          Text(
                            todo.task,
                            style: GoogleFonts.openSans(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const Spacer(),
                          LikeButton(
                            isLiked: todo.isFavourite ?? false,
                            onTap: (isLiked) {
                              final updatedTodo = todo.copyWith(isFavourite: !isLiked);
                              context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
                              return Future.value(!isLiked);
                            },
                            size: 35,
                            circleColor: const CircleColor(
                              start: Colors.yellow,
                              end: Colors.yellowAccent,
                            ),
                            bubblesColor: const BubblesColor(
                              dotPrimaryColor: Colors.yellow,
                              dotSecondaryColor: Colors.yellow,
                            ),
                            likeBuilder: (bool isLiked) {
                              return Icon(
                                isLiked ? Icons.star : Icons.star_outline_rounded,
                                color: isLiked ? Colors.yellow : Colors.white,
                                size: 35,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const Divider(
                    color: Colors.black,thickness: 2,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline_rounded, color: Colors.grey,),
                      Text('Due date: ${todo.formattedDueDate}',
                        style: GoogleFonts.openSans(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _todo(List<Todo> todos, String status) {
    return Column(
      children: [
        Card(
          elevation: 2,
          child: Container(
            color: Colors.grey[300],
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  Text(
                    '$status Available Tasks: ${todos.length}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Visibility(
                    visible: todos.isNotEmpty,
                    child: IconButton(
                        onPressed: () {
                          context.read<TodosBloc>().add(RemoveAllTodos());
                        },
                        icon: const Icon(Icons.delete_forever)),
                  ),
                ],
              ),
            ),
          ),
        ),
        ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 2.0, left: 3.0, right: 3.0, top: 8.0),
              child: _todosCard(
                context,
                todos[index],
              ),
            );
          },
        ),
      ],
    );
  }
}

// Card(
//   child: ListTile(
//     leading: const Icon(Icons.timer),
//     title: const Text('Pomodoro Timer'),
//     trailing: const Icon(Icons.navigate_next),
//     onTap: () {
//       Navigator.pushNamed(context, '/pomodoro_timer');
//     },
//   ),
// ),
// Column(
//   children: [
//     const SizedBox(height: 20),
//     const Text(
//       'Pomodoro',
//       style: TextStyle(
//         fontSize: 30,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     const SizedBox(height: 20),
//     const Text(
//       '25:00',
//       style: TextStyle(
//         fontSize: 50,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     const SizedBox(height: 20),
//     Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton(
//           onPressed: () {},
//           child: const Text('Start'),
//         ),
//         ElevatedButton(
//           onPressed: () {},
//           child: const Text('Pause'),
//         ),
//         ElevatedButton(
//           onPressed: () {},
//           child: const Text('Reset'),
//         ),
//       ],
//     ),
//     const SizedBox(height: 20),
//     const Text(
//       'Task Name',
//       style: TextStyle(
//         fontSize: 30,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     const SizedBox(height: 20),
//     const Text(
//       'Task Description',
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     const SizedBox(height: 20),
//     const Text(
//       'Task Steps',
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     const SizedBox(height: 20),
//     const Text(
//       'Task Steps',
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//   ],
// )

// BlocBuilder<TodosStatusBloc, TodosStatusState>
// (
// builder: (context, state) {
// if (state is TodosStatusLoading) {
// return const Center(
// child: CircularProgressIndicator(),
// );
// }
// if (state is TodosStatusLoaded) {
// return Expanded(
// child: ListView(children: [
// _todo(
// state.pendingTodos,
// ' ',
// )
// ]));
// } else {
// return const Text('Something went wrong.');
// }
// },
// )
// ,
