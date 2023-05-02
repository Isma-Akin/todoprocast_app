import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todoprocast_app/blocs/todos/todos_bloc.dart';
import 'package:todoprocast_app/blocs/todos_status/todos_status_bloc.dart';
import 'package:todoprocast_app/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/todo_repository.dart';
import 'logic/navigation/navigation_cubit.dart';


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
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Todo App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}