import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/todos/todos_bloc.dart';
import '../constants.dart';
import '../models/todo_models.dart';
import '../screens/todo_detail_screen.dart';
import 'package:like_button/like_button.dart';



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
    background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
        image: DecorationImage(
          image: AssetImage('assets/images/cloudbackground.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.2),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Card(
        // color: todo.taskCompleted == true ? Colors.blue[300] : AppColors.orangePrimaryColor,
        color: AppColors.orangePrimaryColor,
        // margin: const EdgeInsets.only(bottom: 5.0),
        margin: const EdgeInsets.all(0.5),
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
                        // IconButton(
                        //     onPressed: () {},
                        //     icon: const Icon(Icons.arrow_drop_down_rounded)),
                        Text(
                          todo.task,
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const Spacer(),
                      LikeButton(
                        isLiked: todo.isFavourite ?? false,
                          onTap: (isLiked) {
                            final updatedTodo = todo.copyWith(isFavourite: !isLiked);
                            context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
                              return Future.value(!isLiked);
                                },
                            size: 35,
                            circleColor: const CircleColor(
                             start: Colors.yellow,
                             end: Colors.yellowAccent,
                              ),
                             bubblesColor: const BubblesColor(
                             dotPrimaryColor: Colors.yellow,
                             dotSecondaryColor: Colors.yellow,
                              ),
                               likeBuilder: (bool isLiked) {
                                 return Icon(
                                  isLiked ? Icons.star : Icons.star_outline_rounded,
                                   color: isLiked ? Colors.yellow : Colors.white,
                                    size: 35,
                                  );
                                 },
                               ),
                        // LikeButton(
                        //   isLiked: todo.isFavourite,
                        //   onTap: (isLiked) {
                        //     context.read<TodosBloc>().add(
                        //       MarkTodoAsFavOrUnFav(todo: todo),
                        //     );
                        //     return Future.value(!isLiked);
                        //   },
                        //   size: 25,
                        //   circleColor: const CircleColor(
                        //     start: Color(0xff00ddff),
                        //     end: Color(0xff0099cc),
                        //   ),
                        //   bubblesColor: const BubblesColor(
                        //     dotPrimaryColor: Color(0xff33b5e5),
                        //     dotSecondaryColor: Color(0xff0099cc),
                        //   ),
                        //   likeBuilder: (bool isLiked) {
                        //     return Icon(
                        //       isLiked ? Icons.star : Icons.star_border,
                        //       color: Colors.yellow,
                        //       size: 25,
                        //     );
                        //   },
                        // ),
                      LikeButton(
                          isLiked: todo.taskCompleted ?? false,
                          onTap: (isLiked) {
                            final updatedTodo = todo.copyWith(taskCompleted: !isLiked);
                            context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
                            return Future.value(!isLiked);
                          },
                          size: 35,
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
                              color: isLiked ? Colors.green : Colors.white,
                              size: 35,
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
                    const Icon(Icons.lightbulb_outline_rounded, color: Colors.grey,),
                    Text('Due date: ${todo.formattedDueDate}',
                      style: GoogleFonts.openSans(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Dismissible todosCardTest(
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
      child: SizedBox(
        height: 80, // increase the height as desired
        width: double.infinity, // use maximum available width
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<TodosBloc, TodosState>(
                  builder: (context, state) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: Colors.blue[100],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${todo.id}: ${todo.task}',
                            style: GoogleFonts.openSans(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: Colors.blue[200],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: Colors.grey,
                      ),
                      Text(
                        'Due date: ${todo.formattedDueDate}',
                        style: GoogleFonts.openSans(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
// LikeButton(
//   isLiked: todo.isFavourite,
//   onTap: (isLiked) {
//     context.read<TodosBloc>().add(
//       MarkTodoAsFavOrUnFav(todo: todo),
//     );
//     return Future.value(!isLiked);
//   },
//   size: 25,
//   circleColor: const CircleColor(
//     start: Color(0xff00ddff),
//     end: Color(0xff0099cc),
//   ),
//   bubblesColor: const BubblesColor(
//     dotPrimaryColor: Color(0xff33b5e5),
//     dotSecondaryColor: Color(0xff0099cc),
//   ),
//   likeBuilder: (bool isLiked) {
//     return Icon(
//       isLiked ? Icons.star : Icons.star_border,
//       color: Colors.yellow,
//       size: 25,
//     );
//   },
// ),