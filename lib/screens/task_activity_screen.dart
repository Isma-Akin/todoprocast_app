import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/screens/task_activities/eatthatfrog_screen.dart';
import 'package:todoprocast_app/screens/task_activities/eisenhower_screen.dart';
import 'package:todoprocast_app/screens/task_activities/paretoanalysis_screen.dart';
import 'package:todoprocast_app/screens/task_activities/parkinsonslaw_screen.dart';
import 'package:todoprocast_app/screens/task_activities/pomodoro_screen.dart';
import 'package:todoprocast_app/screens/task_activities/timeblocking_screen.dart';
import 'package:todoprocast_app/screens/todo_detail_screen.dart';

import '../blocs/todos/todos_bloc.dart';
import '../blocs/todos_status/todos_status_bloc.dart';
import '../models/todo_models.dart';
import '../widgets/todos_card.dart';
import 'package:todoprocast_app/blocs/todos/todos_bloc.dart';

class TaskActivityScreen extends StatefulWidget {
  final List<Todo> todos;
  const TaskActivityScreen({Key? key, required this.todos}) : super(key: key);

  @override
  _TaskActivityScreenState createState() => _TaskActivityScreenState();
}

class _TaskActivityScreenState extends State<TaskActivityScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // void _showTodoList(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return BlocBuilder<TodosBloc, TodosState>(
  //         builder: (context, state) {
  //           if (state is TodosLoaded) {
  //             return SimpleDialog(
  //               title: const Text('Select a todo'),
  //               children: [
  //                 Container(
  //                   height: 300,
  //                   width: 300,
  //                   child: ListView.builder(
  //                     itemCount: state.todos.length,
  //                     itemBuilder: (context, index) {
  //                       return ListTile(
  //                         title: Text(state.todos[index].task),
  //                         onTap: () {
  //                           // Apply the time management method to the selected todo
  //                         },
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             );
  //           } else {
  //             return const CircularProgressIndicator();
  //           }
  //         },
  //       );
  //     },
  //   );
  // }

  void _showTodoList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<TodosBloc, TodosState>(
          builder: (context, state) {
            if (state is TodosLoaded) {
              return SimpleDialog(
                title: const Text('Apply it to a todo'),
                children: [
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: ListView.builder(
                      itemCount: state.todos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.todos[index].task),
                          onTap: () {
                            // Apply the time management method to the selected todo
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return state is TodosInitial
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink();
            }
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.red.withOpacity(0.5), BlendMode.dstATop),
                image: AssetImage('assets/images/cloudbackground.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          centerTitle: true,
          title:  Center(
              child: Text('Task Activity Screen',
                style: GoogleFonts.openSans(
                    fontSize: 24,
                    ),)),
          backgroundColor: Colors.pinkAccent,
          leading: IconButton(
              icon:  Icon(Icons.home, color: Colors.red[400],),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
        ),
        body: Column(
              children: [
                // SlideTransition(
                //   position: Tween<Offset>(
                //     begin: Offset(1.0, 0.0),
                //     end: Offset.zero,
                //   ).animate(CurvedAnimation(
                //     parent: _animationController,
                //     curve: Curves.easeIn,
                //   )),
                //   child: Container(
                //     child: const Text('Please select a task activity',
                //       style: TextStyle(fontSize: 30),
                //     ),
                //   ),
                // ),
                Container(
                  child: const Text('Apply a task activity to a todo',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                const SizedBox(height: 30,),
                Card(
                  elevation: 2,
                  child: InkWell(
                    highlightColor: Colors.blue[900],
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PomodoroScreen(),
                        ),
                      );
                    },
                    splashColor: Colors.blue[900],
                    child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.red.withOpacity(0.5), BlendMode.dstATop),
                            image: const AssetImage('assets/images/pomodoro.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: EdgeInsets.zero,
                        child: Row(
                          children: [
                            Text('Pomodoro',
                                style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),],)
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  child: InkWell(
                    highlightColor: Colors.blue[900],
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TimeBlockingScreen(),
                        ),
                      );
                    },
                    splashColor: Colors.blue[900],
                    child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.red.withOpacity(0.5), BlendMode.dstATop),
                            image: const AssetImage('assets/images/time_blocking.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: EdgeInsets.zero,
                        child: Row(
                          children: [
                            Text('Time blocking',
                                style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),],)
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  child: InkWell(
                    highlightColor: Colors.blue[900],
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EisenHowerScreen(),
                        ),
                      );
                    },
                    splashColor: Colors.blue[900],
                    child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.red.withOpacity(0.2), BlendMode.dstATop),
                            image: const AssetImage('assets/images/eisenhower.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: EdgeInsets.zero,
                        child: Row(
                          children:  [
                            Text('Eisenhower matrix',
                                style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),],)
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  child: InkWell(
                    highlightColor: Colors.blue[900],
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EatThatFrogScreen(),
                        ),
                      );
                    },
                    splashColor: Colors.blue[900],
                    child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.red.withOpacity(0.2), BlendMode.dstATop),
                            image: const AssetImage('assets/images/eat-that-frog-2.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: EdgeInsets.zero,
                        child: Row(
                          children:  [
                            Text('Eat that frog',
                                style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),],)
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  child: InkWell(
                    highlightColor: Colors.blue[900],
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ParetoAnalysisScreen(),
                        ),
                      );
                    },
                    splashColor: Colors.blue[900],
                    child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.red.withOpacity(0.2), BlendMode.dstATop),
                            image: const AssetImage('assets/images/pareto_1.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: EdgeInsets.zero,
                        child: Row(
                          children:  [
                            Text('Pareto analysis',
                                style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),],)
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  child: InkWell(
                    highlightColor: Colors.blue[900],
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ParkinsonsLawScreen(),
                        ),
                      );
                    },
                    splashColor: Colors.blue[900],
                    child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.red.withOpacity(0.2), BlendMode.dstATop),
                            image: const AssetImage('assets/images/Parkinsons-Law-min-1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: EdgeInsets.zero,
                        child: Row(
                          children:  [
                            Text('Parkinsons law',
                                style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),],)
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
              ],
            ),
        ),
    );
  }


  Column _todo(List<Todo> todos, String status) {
    return Column(
      children: [
        Container(
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

  // InkWell _todosCard(BuildContext context,
  //     Todo todo,) {
  //   return InkWell(
  //     splashColor: Colors.blue.withAlpha(30),
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => TodoDetailScreen(todo: todo),
  //         ),
  //       );
  //     },
  //     child: Card(
  //       color: todo.taskCompleted == true ? Colors.orange : AppColors.blueSecondaryColor,
  //       margin: const EdgeInsets.only(bottom: 5.0),
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               '#${todo.id}: ${todo.task}',
  //               style: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             const Divider(
  //               color: Colors.black,
  //             ),
  //             Text('Due date: ${todo.formattedDueDate}',
  //               style: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             BlocBuilder<TodosBloc, TodosState>(
  //               builder: (context, state) {
  //                 return Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     IconButton(
  //                       onPressed: () {
  //                         context.read<TodosBloc>().add(
  //                             MarkTodoAsFavOrUnFav(todo: todo));
  //                       },
  //                       icon: Icon(
  //                           todo.isFavourite! ? Icons.star : Icons.star_border),
  //                       color: Colors.yellow,
  //                     ),
  //                     InkWell(
  //                       onTap: () {
  //                         Navigator.pop(context);
  //                       },
  //                       child: IconButton(
  //                         onPressed: () {
  //                           final isCompleted = todo.taskCompleted ?? false;
  //                           final updatedTodo = todo.copyWith(
  //                               taskCompleted: !isCompleted);
  //                           context.read<TodosBloc>().add(
  //                             UpdateTodo(todo: updatedTodo),
  //                           );
  //                         },
  //                         icon: Icon(todo.taskCompleted ?? false
  //                             ? Icons.check_box
  //                             : Icons.check_box_outline_blank),
  //                       ),
  //                     ),
  //                     IconButton(
  //                       onPressed: () {
  //                         context.read<TodosBloc>().add(
  //                           RemoveTodo(
  //                             todo: todo.copyWith(taskCancelled: true),
  //                           ),
  //                         );
  //                       },
  //                       icon: const Icon(Icons.cancel),
  //                     ),
  //                   ],
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
          color: Colors.blue,
          image: DecorationImage(
            image: AssetImage('assets/images/cloudbackground.jpg'),
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
                          // LikeButton(
                          //   isLiked: todo.isFavourite,
                          //   onTap: (isLiked) {
                          //     context.read<TodosBloc>().add(
                          //       MarkTodoAsFavOrUnFav(todo: todo),
                          //     );
                          //     return Future.value(!isLiked);
                          //   },
                          //   size: 25,
                          //   circleColor: const CircleColor(
                          //     start: Color(0xff00ddff),
                          //     end: Color(0xff0099cc),
                          //   ),
                          //   bubblesColor: const BubblesColor(
                          //     dotPrimaryColor: Color(0xff33b5e5),
                          //     dotSecondaryColor: Color(0xff0099cc),
                          //   ),
                          //   likeBuilder: (bool isLiked) {
                          //     return Icon(
                          //       isLiked ? Icons.star : Icons.star_border,
                          //       color: Colors.yellow,
                          //       size: 25,
                          //     );
                          //   },
                          // ),
                          LikeButton(
                            isLiked: todo.taskCompleted ?? false,
                            onTap: (isLiked) {
                              final updatedTodo = todo.copyWith(taskCompleted: !isLiked);
                              context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
                              return Future.value(!isLiked);
                            },
                            size: 35,
                            circleColor: const CircleColor(
                              start: Colors.green,
                              end: Colors.greenAccent,
                            ),
                            bubblesColor: const BubblesColor(
                              dotPrimaryColor: Colors.green,
                              dotSecondaryColor: Colors.lightGreen,
                            ),
                            likeBuilder: (bool isLiked) {
                              return Icon(
                                isLiked ? Icons.check_box : Icons.check_box_outline_blank,
                                color: isLiked ? Colors.green : Colors.white,
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
}

// GridView(
//   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: 3),
//   scrollDirection: Axis.vertical,
//   primary: false,
//   shrinkWrap: true,
//   children: [
//     GestureDetector(
//       onTap: () {
//         _showTodoList(context);
//       },
//       child: Card(
//         child: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("assets/images/pomodoro.png"),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Text("Pomodoro"),
//         ),
//       ),
//     ),
//     InkWell(
//       onTap: () {},
//       child: Card(
//         child: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("assets/images/time_blocking.jpg"),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Text("Time blocking"),
//         ),
//       ),
//     ),
//     InkWell(
//       onTap: () {},
//       child: Card(
//         child: Text("Monkey method"),
//       ),
//     ),
//   ],
// ),
// BlocBuilder<TodosStatusBloc, TodosStatusState>(
//   builder: (context, state) {
//     if (state is TodosStatusLoading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//     if (state is TodosStatusLoaded) {
//       return Expanded(
//           child: ListView(
//               children: [
//                 _todo(
//                   state.pendingTodos,
//                   ' ',
//                 )
//               ]
//           )
//       );
//     } else {
//       return const Text('Something went wrong.');
//     }
//   },
// ),