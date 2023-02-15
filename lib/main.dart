import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoprocast_app/blocs/todos_bloc.dart';
import 'package:todoprocast_app/models/todo_models.dart';
import 'package:todoprocast_app/screens/home_screen.dart';

void main() {
  runApp(const TodoApp());
}


class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers:[BlocProvider(
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
    ],
        child: MaterialApp(
          title: 'Todo App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomeScreen(),
        ));
  }
}
