import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/todos/todos_bloc.dart';
import '../constants.dart';
import '../models/todo_models.dart';
import '../screens/todo_detail_screen.dart';
import 'package:like_button/like_button.dart';
import 'package:todoprocast_app/screens/main_screen.dart';



Dismissible todosCardOld(
    BuildContext context,
    Todo todo,
    ) {

  return Dismissible(
    key: UniqueKey(),
    onDismissed: (direction) {
      // Remove the dismissed item from the list.
      // context.read<TodosBloc>().add(RemoveTodo(todo.id));
      context.read<TodosBloc>().add(RemoveTodo(todo: todo.copyWith(taskCancelled: true),
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${todo.task} dismissed")),
      );
    },
    background: Container(color: Colors.red),
    child: Card(
      // color: todo.taskCompleted == true ? Colors.orange : AppColors.blueSecondaryColor,
      color: AppColors.orangeSecondaryColor,
      margin: const EdgeInsets.only(bottom: 5.0),
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
              Text(
                '${todo.id}: ${todo.task}',
                style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(
                color: Colors.black,thickness: 2,
              ),
              Text('Due date: ${todo.formattedDueDate}',
                style: GoogleFonts.openSans(fontSize: 16),
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
                        circleColor: const CircleColor(
                          start: Color(0xff00ddff),
                          end: Color(0xff0099cc),
                        ),
                        bubblesColor: const BubblesColor(
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
                      LikeButton(
                        isLiked: todo.taskCompleted ?? false,
                        onTap: (isLiked) {
                          final updatedTodo = todo.copyWith(taskCompleted: !isLiked);
                          context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
                          return Future.value(!isLiked);
                        },
                        size: 25,
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
                            color: isLiked ? Colors.green : Colors.black,
                            size: 25,
                          );
                        },
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      //   child: IconButton(
                      //     onPressed: () {
                      //       final isCompleted = todo.taskCompleted ?? false;
                      //       final updatedTodo = todo.copyWith(taskCompleted: !isCompleted);
                      //       context.read<TodosBloc>().add(
                      //         UpdateTodo(todo: updatedTodo),
                      //       );
                      //     },
                      //     icon: Icon(todo.taskCompleted ?? false
                      //         ? Icons.check_box
                      //         : Icons.check_box_outline_blank),
                      //   ),
                      // ),
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
    ),
  );
}

Dismissible todosCard(
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
    background: Container(color: Colors.red),
    child: Card(
      color: AppColors.orangePrimaryColor,
      margin: const EdgeInsets.only(bottom: 5.0),
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
                      Text(
                        '${todo.id}: ${todo.task}',
                        style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      LikeButton(
                        isLiked: todo.isFavourite,
                        onTap: (isLiked) {
                          context.read<TodosBloc>().add(
                            MarkTodoAsFavOrUnFav(todo: todo),
                          );
                          return Future.value(!isLiked);
                        },
                        size: 25,
                        circleColor: const CircleColor(
                          start: Color(0xff00ddff),
                          end: Color(0xff0099cc),
                        ),
                        bubblesColor: const BubblesColor(
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
                      LikeButton(
                        isLiked: todo.taskCompleted ?? false,
                        onTap: (isLiked) {
                          final updatedTodo = todo.copyWith(taskCompleted: !isLiked);
                          context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
                          return Future.value(!isLiked);
                        },
                        size: 25,
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
                            color: isLiked ? Colors.green : Colors.black,
                            size: 25,
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
                  Icon(Icons.lightbulb_outline_rounded, color: Colors.grey,),
                  Text('Due date: ${todo.formattedDueDate}',
                    style: GoogleFonts.openSans(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}