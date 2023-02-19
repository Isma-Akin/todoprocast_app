import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todoprocast_app/main_bloc_observer.dart';
import 'package:todoprocast_app/blocs/todos/todos_bloc.dart';
import 'package:todoprocast_app/models/todo_models.dart';
import 'package:todoprocast_app/screens/home_screen.dart';
import 'package:todoprocast_app/blocs/todos_status/todos_status_bloc.dart';

import 'logic/navigation/navigation_cubit.dart';

void main() {
  Bloc.observer = MainBlocObserver();
  runApp(const TodoApp());
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers:[
      BlocProvider(
      create: (context) => TodosBloc()
      ..add(
        LoadTodos(
          todos: [
            Todo(
          id: '1',
          task: 'Your first task',
          description: 'Enter a description',
        ),
      ],
     ),
    ),
   ),
    BlocProvider(
      create: (context) => TodosStatusBloc(
        todosBloc: BlocProvider.of<TodosBloc>(context),
      )..add(UpdateTodosStatus()),
    ),
    BlocProvider<NavigationCubit>(
    create: (context) => NavigationCubit(),
    ),
    ],
        child: MaterialApp(
          title: 'Todo App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomeScreen(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
