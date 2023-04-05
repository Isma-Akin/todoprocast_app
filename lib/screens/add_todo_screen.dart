import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoprocast_app/constants.dart';

import '../api/todo_repository.dart';
import '../blocs/todos/todos_bloc.dart';
import '../models/todo_models.dart';
import 'home_screen.dart';

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
    TextEditingController idController = TextEditingController();

    List<Todo> defaultTodos = [
      Todo(
        dateCreated: DateTime.now(),
        task: 'Buy groceries',
        description: 'Task description',
        id: 4,
        dueDate: DateTime.now().add(Duration(days: 1)),
      ),Todo(
        dateCreated: DateTime.now(),
        task: 'Study for exams',
        description: 'Task description',
        id: 3,
        dueDate: DateTime.now().add(Duration(days: 5)),
      ),Todo(
        dateCreated: DateTime.now(),
        task: 'Do laundry',
        description: 'Task description',
        id: 2,
        dueDate: DateTime.now().add(Duration(days: 2)),
      ),Todo(
        dateCreated: DateTime.now(),
        task: 'Meal prep',
        description: 'Task description',
        id: 1,
        dueDate: DateTime.now().add(Duration(days: 3)),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text("Add a new task",
            style: TextStyle(
                fontSize: 24),),
          SizedBox(height: 10,),
          TextField(
            autocorrect: true,
            controller: taskController,
            decoration: InputDecoration(
              hintText: "Enter a task name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
      Container(
        height: 75.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: defaultTodos.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () async {
                context.read<TodosBloc>().add(AddTodo(todo: defaultTodos[index]));
                // TodoRepository.createTodo(defaultTodos[index]);
                BlocProvider.of<TodosBloc>(context).add(const LoadTodos());
              },
              child: Card(
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
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(style: TextButton.styleFrom(primary: AppColors.secondaryColor),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(fontSize: 20),)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: AppColors.tertiaryColor),
                  onPressed: () async {
                    var todo = Todo(
                        id: 1,
                        task: taskController.text,
                        description: "",
                        dateCreated: DateTime.now(),
                        dueDate: DateTime.now(),
                        taskCompleted: false,
                        taskCancelled: false,
                        isFavourite: false);
                    context.read<TodosBloc>().add(AddTodo(todo: todo));
                    TodoRepository.createTodo(todo);
                    BlocProvider.of<TodosBloc>(context).add(const LoadTodos());
                    Navigator.pop(context);
                  },
                  child: Text("Add Todo",
                    style: TextStyle(
                        color: Colors.white,
                      fontWeight: FontWeight.bold),))
            ],
          ),
        ],),
    );
  }
}