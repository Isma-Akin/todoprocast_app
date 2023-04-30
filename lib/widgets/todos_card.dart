import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/todos/todos_bloc.dart';
import '../constants.dart';
import '../models/todo_models.dart';
import '../screens/todo_detail_screen.dart';
import 'package:like_button/like_button.dart';


InkWell todosCard(
    BuildContext context,
    Todo todo,
    ) {

  return InkWell(
    splashColor: Colors.blue.withAlpha(30),
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
    child: Card(
      // color: todo.taskCompleted == true ? Colors.orange : AppColors.blueSecondaryColor,
      color: AppColors.orangeSecondaryColor,
      margin: const EdgeInsets.only(bottom: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${todo.id}: ${todo.task}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            Text('Due date: ${todo.formattedDueDate}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            BlocBuilder<TodosBloc, TodosState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LikeButton(
                      isLiked: todo.isFavourite,
                      onTap: (isLiked) {
                        context.read<TodosBloc>().add(
                          MarkTodoAsFavOrUnFav(todo: todo),
                        );
                        return Future.value(!isLiked);
                      },
                      size: 25,
                      circleColor: CircleColor(
                        start: Color(0xff00ddff),
                        end: Color(0xff0099cc),
                      ),
                      bubblesColor: BubblesColor(
                        dotPrimaryColor: Color(0xff33b5e5),
                        dotSecondaryColor: Color(0xff0099cc),
                      ),
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          isLiked ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
                          size: 25,
                        );
                      },
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: IconButton(
                        onPressed: () {
                          final isCompleted = todo.taskCompleted ?? false;
                          final updatedTodo = todo.copyWith(taskCompleted: !isCompleted);
                          context.read<TodosBloc>().add(
                            UpdateTodo(todo: updatedTodo),
                          );
                        },
                        icon: Icon(todo.taskCompleted ?? false
                            ? Icons.check_box
                            : Icons.check_box_outline_blank),
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