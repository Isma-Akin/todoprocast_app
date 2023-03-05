import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoprocast_app/blocs/blocs.dart';
import 'package:todoprocast_app/screens/todo_detail_screen.dart';

import '../models/todo_models.dart';

class FavouriteTasksScreen extends StatefulWidget {
  const FavouriteTasksScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteTasksScreen> createState() => _FavouriteTasksScreenState();
}

class _FavouriteTasksScreenState extends State<FavouriteTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            backgroundColor: Colors.blueAccent,
            title: const Text('Favourite Tasks'),
          ),
          body: BlocBuilder<TodosBloc, TodosState>(
              builder: (context, state) {
                if (state is TodosLoaded) {
                  final favouriteTodos = state.todos.where(
                      (todo) => todo.isFavourite ?? false).toList();
                  return ListView.builder(
                      itemCount: favouriteTodos.length,
                      itemBuilder: (context, index) {
                        final todo = favouriteTodos[index];
                        return _todosCard(context, todo);
                      }
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ));
  }

  InkWell _todosCard(
      BuildContext context,
      Todo todo,
      ) {
    return InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoDetailScreen(todo: todo),
          ),
        );
      },
      child: Card(
        color: todo.taskCompleted == true ? Colors.orange : Colors.blue,
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${todo.id}: ${todo.task}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              BlocBuilder<TodosBloc, TodosState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<TodosBloc>().add(
                              MarkTodoAsFavOrUnFav(todo: todo));
                        },
                        icon: Icon(
                            todo.isFavourite! ? Icons.star : Icons.star_border),
                        color: Colors.yellow,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: IconButton(
                          onPressed: () {
                            context.read<TodosBloc>().add(
                              UpdateTodo(
                                todo: todo.copyWith(taskCompleted: true),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_task),
                        ),
                      ),IconButton(
                        onPressed: () {
                          context.read<TodosBloc>().add(
                            RemoveTodo(
                              todo: todo.copyWith(taskCancelled: true),
                            ),
                          );
                        },
                        icon: const Icon(Icons.cancel),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
}}
