
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoprocast_app/constants.dart';

import '../blocs/todos/todos_bloc.dart';
import '../models/todo_models.dart';

class AddTodoScreen extends StatefulWidget {
  final TodosBloc todosBloc;
  const AddTodoScreen({
    Key? key, required this.todosBloc,
  }) : super(key: key);

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}
class _AddTodoScreenState extends State<AddTodoScreen> {

  @override
  Widget build(BuildContext context) {
    TextEditingController taskController = TextEditingController();

    List<Todo> defaultTodos = [
      Todo(
        dateCreated: DateTime.now(),
        id: 1,
        task: 'Buy groceries',
        description: 'Task description',
        dueDate: DateTime.now().add(Duration(days: 1)),
        steps: [],
      ),Todo(
        dateCreated: DateTime.now(),
        task: 'Study for exams',
        id: 2,
        description: 'Task description',
        dueDate: DateTime.now().add(Duration(days: 5)),
      ),Todo(
        dateCreated: DateTime.now(),
        task: 'Do laundry',
        description: 'Task description',
        dueDate: DateTime.now().add(Duration(days: 2)), id: 3,
      ),Todo(
        dateCreated: DateTime.now(),
        task: 'Meal prep',
        description: 'Task description',
        dueDate: DateTime.now().add(Duration(days: 3)), id: 4,
      ),Todo(
        dateCreated: DateTime.now(),
        task: 'Vacuum',
        description: 'Task description',
        dueDate: DateTime.now().add(Duration(days: 7)), id: 5,
      ),Todo(
        dateCreated: DateTime.now(),
        task: 'Replace light-bulbs',
        description: 'Task description',
        dueDate: DateTime.now().add(Duration(days: 2)), id: 6,
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                autocorrect: true,
                controller: taskController,
                decoration: const InputDecoration(
                  hintText: "Add a task",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  // Set the desired font size here
                  labelStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: 50,
              child: IconButton(
                onPressed: () async {
                  var todo = Todo(
                    task: taskController.text,
                    description: "Description",
                    dateCreated: DateTime.now(),
                    dueDate: DateTime.now().add(Duration(days: 10)),
                    taskCompleted: false,
                    taskCancelled: false,
                    isFavourite: false,
                    id: 7,
                  );
                  context.read<TodosBloc>().add(AddTodo(todo: todo));
                  BlocProvider.of<TodosBloc>(context).add(const LoadTodos());
                  taskController.clear();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.my_library_add_rounded,
                    color: AppColors.blueSecondaryColor,
                    size: 40,),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
    // const SizedBox(height: 10,),
        Divider(thickness: 1,color: Colors.white),
    SizedBox(
      height: 45.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: defaultTodos.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () async {
              context.read<TodosBloc>().add(AddTodo(todo: defaultTodos[index]));
              BlocProvider.of<TodosBloc>(context).add(const LoadTodos());
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(defaultTodos[index].task),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
        const SizedBox(height: 20,),
      ],);
  }
}