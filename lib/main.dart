import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:todoprocast_app/main_bloc_observer.dart';
import 'package:todoprocast_app/blocs/todos/todos_bloc.dart';
import 'package:todoprocast_app/blocs/todos_status/todos_status_bloc.dart';
import 'package:todoprocast_app/screens/main_screen.dart';

import 'api/todo_repository.dart';
import 'logic/navigation/navigation_cubit.dart';
import 'models/todo_models.dart';

Future<void> main() async {
  //initialize hive
  // await Hive.initFlutter();
  //register adapters for todo class
  // Hive.registerAdapter(TodoAdapter());
  //open box for todos
  // await Hive.openBox<Todo>('todos');

  // final todosRepository = TodoRepository(todoBox);
  // final todosBloc = TodosBloc(todosRepository: todosRepository);
  Bloc.observer = MainBlocObserver();
  runApp(const TodoApp());
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
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodosBloc>(
          create: (context) => TodosBloc(TodoRepository()),
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
        home: const MainScreen(),
      ),
    );
  }
}
