import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/screens/task_activities/eat_that_frog/eatthatfrog_page.dart';
import 'package:todoprocast_app/screens/task_activities/eat_that_frog/eatthatfrog_screen.dart';
import 'package:todoprocast_app/screens/task_activities/eisenhower/eisenhower_page.dart';
import 'package:todoprocast_app/screens/task_activities/eisenhower/eisenhower_screen.dart';
import 'package:todoprocast_app/screens/task_activities/pareto_analysis/paretoanalysis_page.dart';
import 'package:todoprocast_app/screens/task_activities/pareto_analysis/paretoanalysis_screen.dart';
import 'package:todoprocast_app/screens/task_activities/parkinsons_law/parkinsons_law_page.dart';
import 'package:todoprocast_app/screens/task_activities/parkinsons_law/parkinsonslaw_page.dart';
import 'package:todoprocast_app/screens/task_activities/parkinsons_law/parkinsonslaw_screen.dart';
import 'package:todoprocast_app/screens/task_activities/pomodoro/pomodoro_screen.dart';
import 'package:todoprocast_app/screens/task_activities/pomodoro/pomodoro_timer.dart';
import 'package:todoprocast_app/screens/task_activities/time_blocking/timeblocking_page.dart';
import 'package:todoprocast_app/screens/task_activities/time_blocking/timeblocking_screen.dart';
import 'package:todoprocast_app/screens/todo_detail_screen.dart';

import '../blocs/todos/todos_bloc.dart';
import '../models/todo_models.dart';
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: Container(
            child: SafeArea(
              child: Center(
                  child: ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.home, size: 30,),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.table_rows_rounded),
                      onPressed: () {
                      },
                    ),
                    title: Center(
                      child: Text(
                        'Task Activities',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
              ),),
            height: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/cloudbackground.jpg'),
                colorFilter: ColorFilter.mode(
                  Colors.red.withOpacity(0.7),
                  BlendMode.srcATop,
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ) ,
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
                const SizedBox(height: 10,),
                GridView.count(
                  padding: const EdgeInsets.all(1),
                  primary: false,
                  childAspectRatio: 1.3,
                  shrinkWrap: true,
                  crossAxisSpacing: 1,
                  crossAxisCount: 2,
                  children: [
                  _pomodoroCard(context),
                  _timeBlockingCard(context),
                  _eisenhowerCard(context),
                  _eatThatFrogCard(context),
                  _paretoAnalysisCard(context),
                  _parkinsonsLawCard(context),
                  // Card(
                  //   elevation: 2,
                  //   child: InkWell(
                  //     highlightColor: Colors.blue[900],
                  //     customBorder: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const PomodoroScreen(),
                  //         ),
                  //       );
                  //     },
                  //     splashColor: Colors.blue[900],
                  //     child: Container(
                  //         decoration: BoxDecoration(
                  //           image: DecorationImage(
                  //             colorFilter: ColorFilter.mode(
                  //                 Colors.red.withOpacity(0.5), BlendMode.dstATop),
                  //             image: const AssetImage('assets/images/pomodoro.png'),
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //         width: MediaQuery.of(context).size.width,
                  //         height: 50,
                  //         margin: EdgeInsets.zero,
                  //         child: Row(
                  //           children: [
                  //             Text('Pomodoro',
                  //                 style: GoogleFonts.openSans(
                  //                     fontSize: 18,
                  //                     fontWeight: FontWeight.bold)),],)
                  //     ),
                  //   ),
                  // ),
                  // Card(
                  //   elevation: 2,
                  //   child: InkWell(
                  //     highlightColor: Colors.blue[900],
                  //     customBorder: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const TimeBlockingScreen(),
                  //         ),
                  //       );
                  //     },
                  //     splashColor: Colors.blue[900],
                  //     child: Container(
                  //         decoration: BoxDecoration(
                  //           image: DecorationImage(
                  //             colorFilter: ColorFilter.mode(
                  //                 Colors.red.withOpacity(0.5), BlendMode.dstATop),
                  //             image: const AssetImage('assets/images/time_blocking.jpg'),
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //         width: MediaQuery.of(context).size.width,
                  //         height: 50,
                  //         margin: EdgeInsets.zero,
                  //         child: Row(
                  //           children: [
                  //             Text('Time blocking',
                  //                 style: GoogleFonts.openSans(
                  //                     fontSize: 18,
                  //                     fontWeight: FontWeight.bold)),],)
                  //     ),
                  //   ),
                  // ),
                  // Card(
                  //   elevation: 2,
                  //   child: InkWell(
                  //     highlightColor: Colors.blue[900],
                  //     customBorder: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const EisenHowerScreen(),
                  //         ),
                  //       );
                  //     },
                  //     splashColor: Colors.blue[900],
                  //     child: Container(
                  //         decoration: BoxDecoration(
                  //           image: DecorationImage(
                  //             colorFilter: ColorFilter.mode(
                  //                 Colors.red.withOpacity(0.2), BlendMode.dstATop),
                  //             image: const AssetImage('assets/images/eisenhower.png'),
                  //             fit: BoxFit.contain,
                  //           ),
                  //         ),
                  //         width: MediaQuery.of(context).size.width,
                  //         height: 50,
                  //         margin: EdgeInsets.zero,
                  //         child: Row(
                  //           children:  [
                  //             Text('Eisenhower matrix',
                  //                 style: GoogleFonts.openSans(
                  //                     fontSize: 18,
                  //                     fontWeight: FontWeight.bold)),],)
                  //     ),
                  //   ),
                  // ),
                  // Card(
                  //   elevation: 2,
                  //   child: InkWell(
                  //     highlightColor: Colors.blue[900],
                  //     customBorder: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const EatThatFrogScreen(),
                  //         ),
                  //       );
                  //     },
                  //     splashColor: Colors.blue[900],
                  //     child: Container(
                  //         decoration: BoxDecoration(
                  //           image: DecorationImage(
                  //             colorFilter: ColorFilter.mode(
                  //                 Colors.red.withOpacity(0.2), BlendMode.dstATop),
                  //             image: const AssetImage('assets/images/eat-that-frog-2.png'),
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //         width: MediaQuery.of(context).size.width,
                  //         height: 50,
                  //         margin: EdgeInsets.zero,
                  //         child: Row(
                  //           children:  [
                  //             Text('Eat that frog',
                  //                 style: GoogleFonts.openSans(
                  //                     fontSize: 18,
                  //                     fontWeight: FontWeight.bold)),],)
                  //     ),
                  //   ),
                  // ),
                  // Card(
                  //   elevation: 2,
                  //   child: InkWell(
                  //     highlightColor: Colors.blue[900],
                  //     customBorder: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const ParetoAnalysisScreen(),
                  //         ),
                  //       );
                  //     },
                  //     splashColor: Colors.blue[900],
                  //     child: Container(
                  //         decoration: BoxDecoration(
                  //           image: DecorationImage(
                  //             colorFilter: ColorFilter.mode(
                  //                 Colors.red.withOpacity(0.2), BlendMode.dstATop),
                  //             image: const AssetImage('assets/images/pareto_1.png'),
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //         width: MediaQuery.of(context).size.width,
                  //         height: 50,
                  //         margin: EdgeInsets.zero,
                  //         child: Row(
                  //           children:  [
                  //             Text('Pareto analysis',
                  //                 style: GoogleFonts.openSans(
                  //                     fontSize: 18,
                  //                     fontWeight: FontWeight.bold)),],)
                  //     ),
                  //   ),
                  // ),
                  // Card(
                  //   elevation: 2,
                  //   child: InkWell(
                  //     highlightColor: Colors.blue[900],
                  //     customBorder: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const ParkinsonsLawScreen(),
                  //         ),
                  //       );
                  //     },
                  //     splashColor: Colors.blue[900],
                  //     child: Container(
                  //         decoration: BoxDecoration(
                  //           image: DecorationImage(
                  //             colorFilter: ColorFilter.mode(
                  //                 Colors.red.withOpacity(0.2), BlendMode.dstATop),
                  //             image: const AssetImage('assets/images/Parkinsons-Law-min-1.jpg'),
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //         width: MediaQuery.of(context).size.width,
                  //         height: 50,
                  //         margin: EdgeInsets.zero,
                  //         child: Row(
                  //           children:  [
                  //             Text('Parkinsons law',
                  //                 style: GoogleFonts.openSans(
                  //                     fontSize: 18,
                  //                     fontWeight: FontWeight.bold)),],)
                  //     ),
                  //   ),
                  // ),
                ],),
              ],
            ),
        ),
    );
  }

  Card _parkinsonsLawCard(BuildContext context) {
    return Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const ParkinsonsLawCountDownPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;
                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  splashFactory: InkRipple.splashFactory,
                  highlightColor: Colors.blue[900],
                  splashColor: Colors.blue[900],
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.5,
                        image: const AssetImage('assets/images/Parkinsons-Law-min-1.jpg'),
                        colorFilter: ColorFilter.mode(
                          Colors.red.withOpacity(0.2),
                          BlendMode.srcATop,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Parkinsons Law',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }

  Card _paretoAnalysisCard(BuildContext context) {
    return Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const ParetoAnalysisPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;
                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  splashFactory: InkRipple.splashFactory,
                  highlightColor: Colors.blue[900],
                  splashColor: Colors.blue[900],
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.5,
                        image: const AssetImage('assets/images/pareto-chart.png'),
                        colorFilter: ColorFilter.mode(
                          Colors.red.withOpacity(0.2),
                          BlendMode.srcATop,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Pareto analysis',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }

  Card _eatThatFrogCard(BuildContext context) {
    return Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const EatThatFrogPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;
                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  splashFactory: InkRipple.splashFactory,
                  highlightColor: Colors.blue[900],
                  splashColor: Colors.blue[900],
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.5,
                        image: const AssetImage('assets/images/eat-that-frog-2.png'),
                        colorFilter: ColorFilter.mode(
                          Colors.red.withOpacity(0.2),
                          BlendMode.srcATop,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Eat That Frog',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }

  Card _eisenhowerCard(BuildContext context) {
    return Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const EisenhowerPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;
                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  splashFactory: InkRipple.splashFactory,
                  highlightColor: Colors.blue[900],
                  splashColor: Colors.blue[900],
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.5,
                        image: const AssetImage('assets/images/eisenhower2.png'),
                        colorFilter: ColorFilter.mode(
                          Colors.red.withOpacity(0.2),
                          BlendMode.srcATop,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Eisenhower',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }

  Card _timeBlockingCard(BuildContext context) {
    return Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const TimeBlockingPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;
                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  splashFactory: InkRipple.splashFactory,
                  highlightColor: Colors.blue[900],
                  splashColor: Colors.blue[900],
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.5,
                        image: const AssetImage('assets/images/time_blocking.jpg'),
                        colorFilter: ColorFilter.mode(
                          Colors.orange.withOpacity(0.2),
                          BlendMode.srcATop,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Time Blocking',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }

  Card _pomodoroCard(BuildContext context) {
    return Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const PomodoroTimer(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;
                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  splashFactory: InkRipple.splashFactory,
                  highlightColor: Colors.blue[900],
                  splashColor: Colors.blue[900],
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.5,
                        image: const AssetImage('assets/images/pomodoro.png'),
                        colorFilter: ColorFilter.mode(
                          Colors.red.withOpacity(0.2),
                          BlendMode.srcATop,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Pomodoro',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }
}
