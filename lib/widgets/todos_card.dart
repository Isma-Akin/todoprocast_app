import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/todos/todos_bloc.dart';
import '../constants.dart';
import '../models/todo_models.dart';
import '../screens/todo_detail_screen.dart';


InkWell todosCard(
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
      color: todo.taskCompleted == true ? Colors.orange : AppColors
          .secondaryColor,
      margin: const EdgeInsets.only(bottom: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#${todo.id}: ${todo.task}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            Text('Due date: ${todo.formattedDueDate}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            BlocBuilder<TodosBloc, TodosState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                    ),
                    IconButton(
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
}