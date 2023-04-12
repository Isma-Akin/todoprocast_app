
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      ),Todo(
        dateCreated: DateTime.now(),
        task: 'Vacuum',
        description: 'Task description',
        id: 1,
        dueDate: DateTime.now().add(Duration(days: 7)),
      ),Todo(
        dateCreated: DateTime.now(),
        task: 'Replace light-bulbs',
        description: 'Task description',
        id: 1,
        dueDate: DateTime.now().add(Duration(days: 2)),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(
                child: TextField(
                  autocorrect: true,
                  controller: taskController,
                  decoration: InputDecoration(
                    hintText: "Enter a task name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: IconButton(
                  onPressed: () {
                    var todo = Todo(
                      id: 1,
                      task: taskController.text,
                      description: "Description",
                      dateCreated: DateTime.now(),
                      dueDate: DateTime.now(),
                      taskCompleted: false,
                      taskCancelled: false,
                      isFavourite: false,
                    );
                    context.read<TodosBloc>().add(AddTodo(todo: todo));
                    taskController.clear();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.add_box_outlined,
                      color: AppColors.secondaryColor,
                      size: 40,),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
      const SizedBox(height: 10,),
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
                elevation: 5,
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
        ],),
    );
  }
}