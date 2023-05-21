import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoprocast_app/blocs/paretos/pareto_bloc.dart';
import 'package:todoprocast_app/blocs/parkinsons_cubit/parkinsons_law_bloc.dart';

import 'package:todoprocast_app/blocs/todos/todos_bloc.dart';
import 'package:todoprocast_app/blocs/todos_status/todos_status_bloc.dart';
import 'package:todoprocast_app/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/time_blocks_repository.dart';
import 'api/todo_repository.dart';
import 'blocs/blocs.dart';
import 'blocs/groups/group_bloc.dart';
import 'blocs/pomodoros/pomodoro_bloc.dart';
import 'blocs/timeblocks/time_block_bloc.dart';
import 'blocs/todos/selected_todos/selected_todo_bloc.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  final prefs = await SharedPreferences.getInstance();
  runApp(TodoApp(prefs: prefs));
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      print(event);
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      print(transition);
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print(error);
    }
    super.onError(bloc, error, stackTrace);
  }
}

class TodoApp extends StatelessWidget {
  final SharedPreferences prefs;

  const TodoApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodosBloc>(
          create: (context) => TodosBloc(TodoRepository(prefs: prefs), prefs),
        ),
        BlocProvider<TodosStatusBloc>(
          create: (context) => TodosStatusBloc(
            todosBloc: BlocProvider.of<TodosBloc>(context),
          )..add(const UpdateTodosStatus()),
        ),
        BlocProvider<PomodoroBloc>(
          create: (context) => PomodoroBloc(),),
        BlocProvider<SelectedTodoBloc>(create: (_) => SelectedTodoBloc(),),
        // BlocProvider<NavigationCubit>(
        //   create: (context) => NavigationCubit(),
        // ),
        BlocProvider<GroupBloc>(
          create: (context) => GroupBloc(TodoRepository(prefs: prefs), prefs),
        ),
        BlocProvider<ParetoBloc>(
          create: (context) => ParetoBloc(),
        ),
        BlocProvider<TimeBlocksBloc>(
          create: (context) => TimeBlocksBloc(TimeBlocksRepository()),
        ),
        // BlocProvider<ParkinsonBloc>(
        //   create: (context) => ParkinsonBloc(),
        // ),
      ],
      child: MaterialApp(
        title: 'Todo App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.openSansTextTheme(
            Theme.of(context).textTheme,
          ).copyWith(
            headline4: const TextStyle(color: Colors.white),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}